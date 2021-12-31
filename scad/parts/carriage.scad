include <../cevo2.scad>
include <../defs/loops_defs.scad>

include <../../../xNopSCADlib/xVitamins/xnuts.scad>
include <../extparts/mosquito_hotend.scad>
include <../extparts/bltouch.scad>
include <../extparts/orbiter_extruder.scad>
include <mosquito_fan_duct.scad>
include <NopSCADlib/vitamins/tubings.scad>

*translate([-pos_x,-(pos_y-cw/2-mosquito_hotend_size.y/2-mosquito_hotend_offy),-(xrail_z+ch)]) {
	for (i = [0, 1]) {
		loop = loops[i];
		translate([0, 0, loop.x]) {
			*for (p = loop.y) if (is_list(p.z))
				translate([p.x, p.y, 0])
					#pulley_assembly(p.z);
			belt(belt, loop.y, open = true, auto_twist = true, start_twist = i, tooth_colour = [0.35, 0.15, 0.18]);
		}
	}
	translate([extr_d2-xrail_xoff,pos_y,xrail_z]) {
		xrail_assembly(rail_x, pos=pos_x-extr_d2+xrail_xoff);
		translate([xrail_len/2,0,-5]) rotate([0,-90,0]) tubing(CARBONFIBER10, length=xrail_len);
	}

}

carriage_x = xrail_carriage(rail_x);
cl = carriage_length(MGN12H_carriage);
clx = cl + 2;
cw = carriage_width(carriage_x);
ch = carriage_height(carriage_x);

carriage_loopy = mosquito_hotend_size.y/2+mosquito_hotend_offy+cw/2-loops_xoff0-belt_pulley_pr(belt, idler);
carriage_loopz = [ for (l = loops) l[0]-xrail_z-ch ];

mq = mosquito_hotend_size;
mqo = mosquito_hotend_offy;

platet = base_part_thickx;
function carriage_platet() = platet;
legr = 4.5;
lega = 22;
legl = mq.x+platet+7;
leg2w = base_part_thick;
leg2h = base_part_thickx;

screwCarriage = axscrew(M3_cs_cap_screw,material=MaterialBlackSteel);
carriageScrews = [ for(j = [0:3]) let(
	p = carriage_hole_ps(carriage_x)[j],
	pp = [p.x,p.y+cw/2+mq.y/2+mqo,platet]
) axxscrew_setLeng(screwCarriage,t=pp,thick=platet+5,xnut=false,depth=0.2) ];
function carriage_screws() = carriageScrews;

bltouch_holderr = bltouch_size.y/2+bltouch_offy/2;
bltouch_offx = 5.3;
bltouch_offsy = max(cw/2,20);
bltouchScrews = [ for(j = [0:1]) let(
	p = [cl/2+bltouch_offx-j*bltouch_screwp.x*2,mq.y/2+mqo+bltouch_offsy+bltouch_size.y/2+bltouch_offy,platet]
) axxscrew_setLeng(screwCarriage,t=p,thick=platet+bltouch_screw_holdert,depth=0.2) ];
function bltouch_screws() = bltouchScrews;

fanholderd = xxscrew_translate(bltouchScrews[1]).x-screw_head_radius(screwCarriage)*2.2-cl/2+bltouch_holderr;
fanHolderScrews = [ for(j = [0:1]) let(
	p = [-cl/2+bltouch_holderr-j*fanholderd,mq.y/2+mqo+cw+part_assemble_nudge+fan_holderw/2,platet]
) axxscrew_setLeng(screwCarriage,t=p,thick=platet+fan_holdert,depth=0.2) ];
function fan_holder_screws() = fanHolderScrews;

extruderScrews = [ for(p = orbiter_extruder_screwps) axxscrew_setLeng(screwPart,t=p+[0,0,platet],thick=p.z,insert=true) ];
function extruder_screws() = extruderScrews;

screwHotend = axscrew(M2p5_dome_screw,material=MaterialBlackSteel);
hotendScrews = [ for(p = mosquito_hotend_screwps) axxscrew_setLeng(screwHotend,t=p+[0,0,-mosquito_hotend_topt],r=[180,0,0],thick=mosquito_hotend_topt+5) ];
function hotend_screws() = hotendScrews;

loopScrewHoldert = platet-screw_head_height(screwPart)*1.2;
loopScrews = [ for (i = [1,-1]) let(
		t = [carriage_loopd*i,carriage_loopy,loopScrewHoldert]
	) axxscrew_setLengAdjustThick(screwPart, thick=loopScrewHoldert+mq.x, t=t, depth=0, nut_depth=0, twist=30 )];
loopScrewHolderl = xxscrew_thick(loopScrews[0]);
function carriage_loop_screws() = loopScrews;

module carriage_stl() stl("carriage") {

	color(partColor)
		difference() {
			union() {
				difference() {
					union() {
						difference() { // top plate
							translate([-clx/2, -mq.y/2, 0])
								cube([clx, cw+mqo+mq.y, platet]);
							for (i = [0, 1]) mirror([i, 0, 0])
								translate([cl/2-legr, -mq.y/2, 0])
									rotate([lega, 0, 0]) translate([0, -1, -legl+platet]) cube([legr+1, legr+1, legl]);
						}
						for (i = [0, 1]) mirror([i, 0, 0]) { // pillars to hold belds and fan duct
							difference() {
								translate([cl/2-legr*2, -mq.y/2+legr, -mq.x-legr+1])
									cube([legr*2, mq.y+mqo-legr-part_assemble_nudge, mq.x+legr]);
								translate([cl/2-legr, -mq.y/2, 0])
									rotate([lega, 0, 0]) translate([-legr-1, -legr*2, -legl+platet]) cube([legr*2+2, legr*3, legl]);
							}
							translate([cl/2-legr+1, -mq.y/2+1-0.5, 0]) // main pilars
								rotate([lega, 0, 0]) translate([0, legr, -legl+platet]) cylinder(legl, r = legr+0.5);
							difference() { // belt holders
								r = carriage_loopr+belt_thickness(belt)+motor_nudge*2;
								translate([carriage_loopd, carriage_loopy, -loopScrewHolderl+loopScrewHoldert])
									cylinder(loopScrewHolderl, r = r);
								for(z = carriage_loopz) translate([carriage_loopd,carriage_loopy,z])
									cube([r*3,r*3,belt_width(belt)+motor_nudge*2], center = true);
//								h = ch-carriage_clearance(carriage_x)+part_assemble_nudge;
//								#translate([carriage_loopd-r+part_assemble_nudge,mq.y/2+mqo-part_assemble_nudge,-h])
//									cube([r,r,h+part_assemble_nudge]);
							}
						}
						difference() { // beam connection the two pilars
							translate([-clx/2+legr, -mq.y/2, 0])
								rotate([lega, 0, 0]) translate([0, 0, -legl+platet])
									cube([clx-2*legr, legr*2+2, legr*2]);
							translate([-clx/2, -mq.y/2+motor_nudge, -mq.x-1])
								cube([clx, mq.y, mq.y]);
						}
						translate([0, bltouch_offsy+mq.y/2+mqo, 0]) { // bltouch holder
							xb = cl/2+bltouch_offx;
							for (x = [xb, xb-bltouch_screwp.x*2])
								translate([x, bltouch_holderr-0.1, 0])
									cylinder(platet, r = bltouch_holderr);
							translate([xb-bltouch_screwp.x*2, -0.1, 0])
								cube([bltouch_screwp.x*2, bltouch_holderr*2, platet]);
						}
						translate([0, cw+mq.y/2+mqo, 0]) { // fan holder holder
							r = fan_holderw/2+0.5;
							translate([-clx/2+r, r-0.1, 0])
								cylinder(platet, r = r);
							translate([-clx/2+r, -0.1, 0])
								cube([cl+bltouch_offx-r, r*2, platet]);
							translate([-clx/2, 0, 0])
								cube([r+0.1, r+0.1, platet]);
						}
					}

					translate([-cl/2-5, -mq.y/2-5, platet])
						cube([cl+10, cw+mqo+mq.y+10, platet]); // cut on top
					translate([-cl/2-4, -mq.y/2-cw, -1])
						cube([cl+8, cw, platet+10]); // cut on front
					translate([-cl/2-4, 0, -mq.x-mq.y])
						cube([cl+8, mq.y+4, mq.y]); // cut on bottom
					translate([-cl/2-4, mq.y/2+mqo+3+2, -mq.x-1])
						cube([cl+8, mq.y, mq.y]); // cut on inside
					xxside1_hole(carriageScrews);
					xxside1_hole(bltouchScrews);
					xxside1_hole(fanHolderScrews);
					xxside1_hole(hotendScrews);
					xxside2_hole(extruderScrews);
					translate([0, 0, -1]) xhole(4.3/2, platet+2); // hole for ptf tube for filament

				}

				// holder for the fan duct
				for (i = [0, 1]) mirror([i, 0, 0]) difference() {
					dz = cos(lega)*(mq.x-2);
					dy = sin(lega)*(mq.x-2);
					p1 = [-mq.y/2+legr+dy, -dz];
					spz = fan_duct_screwp.z-mosquito_hotend_fanz;
					p2 = [fan_duct_screwp.y-fan_duct_screw_tapsize.y-part_assemble_nudge/2, spz-fan_duct_screw_tapsize.z*0.2];
					leg2a = a2(p2-p1);
					leg2l = len2(p2-p1);
					x = cl/2-legr-0.1;
					union() {
						translate([x, p1.x, p1.y])
							rotate([leg2a, 0, 0])
								translate([0, 0, -leg2h/2])
									cube([leg2w+0.4, leg2l+2, leg2h]);
						translate([0, -fan_duct_screw_tapsize.y-part_assemble_nudge/2, -mosquito_hotend_fanz])
							fan_duct_holder();
					}
					translate([0, 0, -mosquito_hotend_fanz])
						xxfastner_hole(fan_duct_screws[0]);
					translate([x-base_part_thickx+0.1, p2.x, spz-fan_duct_screw_tapsize.z/2-0.1])
						cube([base_part_thickx*2, base_part_thickx, base_part_thickx]);
					translate([x-base_part_thickx, p2.x-base_part_thickx, spz-fan_duct_screw_tapsize.z/2-base_part_thickx+part_assemble_nudge*2])
						cube([base_part_thickx*2, base_part_thickx*2, base_part_thickx]);

				}
//				translate([cl/2-1,mq.y/2+mqo+cw/2+3,0]) {
//					difference() {
//						cylinder(40, d = 13);
//						translate([0,0,platet]) cylinder(42, d = 8);
//						translate([0,-13/2-1,6.5/2+platet]) rotate([-90,0,0]) cylinder(13/2+1,d=6.5);
//						translate([5,-6,-1]) cube([5,12,platet+1]);
//						translate([-10.5,-6,30]) cube([5,12,30]);
//					}
//					color("black")difference() {
//						cylinder(50, d = 7.9);
//						translate([0,0,-1]) cylinder(52, d = 6.5);
//					}
//					translate([-9,0,platet]) screw(M3_cap_screw,4);
//				}

			}

			// holes for the belts and holes for the screw that holds them
			xxside1_hole(loopScrews);
			xxside2_hole(loopScrews);
			for (i = [0, 1]) mirror([i, 0, 0])
				for(z = carriage_loopz) translate([carriage_loopd,carriage_loopy,z]) {
					r = carriage_loopr+belt_thickness(belt)+motor_nudge;
					cylinder(belt_width(belt)+motor_nudge*2, r = r, center = true);
				}
		}
}

module bltouch_at_carriage() {
	translate(xxscrew_translate(bltouchScrews[0])-[bltouch_screwp.x,0,platet])
		bltouch();
}

module fan_holder_at_carriage_stl() stl("fan_holder_at_carriage") {
	translate([0,0,-mosquito_hotend_fanz])
		fan_holder(xxscrew_translate(fanHolderScrews[0])+[0,0,mosquito_hotend_fanz-platet],-fanholderd);
}

carriage_stl();
*bltouch_at_carriage();
mosquito_hotend();
//translate([cl/2-bltouch_screwp.x+bltouch_offx,cw+mq.y/2+mqo+bltouch_offy+bltouch_screwp.y,0])
translate([0,0,-mosquito_hotend_fanz]) {
	mosquito_fan_duct_stl();
	fan_holder(xxscrew_translate(fanHolderScrews[0])+[0,0,mosquito_hotend_fanz-platet],-fanholderd);
}
translate([0,0,carriage_platet()]) orbiter_extruder();
