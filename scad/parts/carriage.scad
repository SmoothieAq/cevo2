include <../cevo2.scad>
include <../defs/loops_defs.scad>

include <../../../xNopSCADlib/xVitamins/xnuts.scad>
include <../extparts/mosquito_hotend.scad>
include <../extparts/bltouch.scad>
include <../extparts/orbiter_extruder.scad>
include <mosquito_fan_duct.scad>

*translate([-pos_x,-(pos_y-cw/2-mosquito_hotend_size.y/2-mosquito_hotend_offy),-(xrail_z+ch)])
for (loop = loops) translate([0, 0, loop.x]) belt(GT2x6, [for (p = loop.y) [p.x, p.y, p[3] * pulley_pr(p[2])]]);


carriage_x = xrail_carriage(rail_x);
cl = carriage_length(carriage_x);
cw = carriage_width(carriage_x);
ch = carriage_height(carriage_x);

carriage_belty = mosquito_hotend_size.y/2+mosquito_hotend_offy+cw/2-loops_xoff0-pulley_ir(idler)-belt_thickness(belt)/2;
carriage_beltz = [ for (l = loops) l[0]-xrail_z-ch ];
carriage_beltr = mosquito_hotend_size.y/2-carriage_belty;
carriage_beltrr = carriage_beltr+belt_thickness(belt)+0.7;
carriage_beltx = cl/2-carriage_beltr/2;

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
) axxscrew_setLeng(screwCarriage,t=pp,thick=platet+5,xnut=false) ];
function carriage_screws() = carriageScrews;

bltouch_offx = 4;
bltouch_holderr = bltouch_size.y/2+bltouch_offy/2;
bltouchScrews = [ for(j = [0:1]) let(
	p = [cl/2+bltouch_offx-j*bltouch_screwp.x*2,mq.y/2+mqo+cw+bltouch_size.y/2+bltouch_offy,platet]
) axxscrew_setLeng(screwCarriage,t=p,thick=platet+bltouch_screw_holdert) ];
function bltouch_screws() = bltouchScrews;

fanholderd = xxscrew_translate(bltouchScrews[1]).x-screw_head_radius(screwCarriage)*2.2-cl/2+bltouch_holderr;
fanHolderScrews = [ for(j = [0:1]) let(
	p = [-cl/2+bltouch_holderr-j*fanholderd,mq.y/2+mqo+cw+part_assemble_nudge+fan_holderw/2,platet]
) axxscrew_setLeng(screwCarriage,t=p,thick=platet+fan_holdert) ];
function fan_holder_screws() = fanHolderScrews;

extruderScrews = [ for(p = orbiter_extruder_screwps) axxscrew_setLeng(screwPart,t=p+[0,0,platet],thick=p.z,insert=true) ];
function extruder_screws() = extruderScrews;

screwHotend = axscrew(M2p5_dome_screw,material=MaterialBlackSteel);
hotendScrews = [ for(p = mosquito_hotend_screwps) axxscrew_setLeng(screwHotend,t=p+[0,0,-mosquito_hotend_topt],r=[180,0,0],thick=mosquito_hotend_topt+5) ];
function hotend_screws() = hotendScrews;

module carriage_stl() {
	stl("carriage");

	*#translate([-30,carriage_belty,carriage_beltz[0]-belt_width(belt)/2]) cube([60,belt_thickness(belt),belt_width(belt)]);
	color(partColor)
		union() {
			difference() {
				union() {
					difference() {
						translate([-cl/2, -mq.y/2, 0])
							cube([cl, cw+mqo+mq.y, platet]);
						for (i = [0, 1]) mirror([i, 0, 0])
							translate([cl/2-legr, -mq.y/2, 0])
								rotate([lega, 0, 0]) translate([0, -1, -legl+platet]) cube([legr+1, legr+1, legl]);
					}
					for (i = [0, 1]) mirror([i, 0, 0]) {
						difference() {
							translate([cl/2-legr*2, -mq.y/2+legr, -mq.x-legr+1])
								cube([legr*2, mq.y+mqo-legr-part_assemble_nudge, mq.x+legr]);
							translate([cl/2-legr, -mq.y/2, 0])
								rotate([lega, 0, 0]) translate([-legr-1, -legr*2, -legl+platet]) cube([legr*2+2, legr*3, legl]);
						}
						translate([cl/2-legr, -mq.y/2, 0])
							rotate([lega, 0, 0]) translate([0, legr, -legl+platet]) cylinder(legl, r = legr);
					}
					difference() {
						translate([-cl/2+legr, -mq.y/2, 0])
							rotate([lega, 0, 0]) translate([0, 0, -legl+platet])
								cube([cl-2*legr, legr*2, legr*2]);
						translate([-cl/2-1, -mq.y/2+motor_nudge, -mq.x-1])
							cube([cl+2, mq.y, mq.y]);
					}
					translate([0, cw+mq.y/2+mqo, 0]) {
						for (x = [cl/2+bltouch_offx, -cl/2+bltouch_holderr])
							translate([x, bltouch_holderr-0.1, 0])
								cylinder(platet, r = bltouch_holderr);
						translate([-cl/2+bltouch_holderr, -0.1, 0])
							cube([cl-bltouch_holderr+bltouch_offx, bltouch_holderr*2, platet]);
						translate([-cl/2, 0, 0])
							cube([bltouch_holderr+0.1, bltouch_holderr+0.1, platet]);
					}
				}
				translate([-cl/2-5, -mq.y/2-5, platet])
					cube([cl+10, cw+mqo+mq.y+10, platet]);
				translate([-cl/2-1, -mq.y/2-cw, -1])
					cube([cl+2, cw, platet+10]);
				translate([-cl/2-1, 2, -mq.x-mq.y])
					cube([cl+2, mq.y, mq.y]);
				translate([-cl/2-1, mq.y/2+mqo+3, -mq.x-1])
					cube([cl+2, mq.y, mq.y]);
				xxside1_hole(carriageScrews);
				xxside1_hole(bltouchScrews);
				xxside1_hole(fanHolderScrews);
				xxside1_hole(hotendScrews);
				xxside2_hole(extruderScrews);
				translate([0,0,-1]) xhole(4.1/2,platet+2);
			}
			for (i = [0, 1]) mirror([i, 0, 0]) difference() {
				dz = cos(lega)*(mq.x-2);
				dy = sin(lega)*(mq.x-2);
				p1 = [-mq.y/2+legr+dy,-dz];
				spz = fan_duct_screwp.z-mosquito_hotend_fanz;
				p2 = [fan_duct_screwp.y-fan_duct_screw_tapsize.y-part_assemble_nudge/2,spz-fan_duct_screw_tapsize.z*0.2];
				leg2a = a2(p2-p1);
				leg2l = len2(p2-p1);
				x = cl/2-legr-1;
				echo("¤¤¤",dy=dy,dz=dz,p1=p1,p2=p2,leg2a=leg2a,leg2l=leg2l);
				union() {
					translate([x,p1.x,p1.y])
						rotate([leg2a, 0, 0])
							translate([0,0,-leg2h/2])
								cube([leg2w,leg2l+2,leg2h]);
					translate([0,-fan_duct_screw_tapsize.y-part_assemble_nudge/2,-mosquito_hotend_fanz])
						fan_duct_holder();
				}
				translate([0,0,-mosquito_hotend_fanz])
					xxfastner_hole(fan_duct_screws[0]);
				translate([x-base_part_thickx+0.1, p2.x, spz-fan_duct_screw_tapsize.z/2-0.1])
					cube([base_part_thickx*2,base_part_thickx,base_part_thickx]);
				translate([x-base_part_thickx,p2.x-base_part_thickx,spz-fan_duct_screw_tapsize.z/2-base_part_thickx+part_assemble_nudge*2])
					cube([base_part_thickx*2,base_part_thickx*2,base_part_thickx]);
			}
		}
}

module bltouch_at_carriage() {
	translate(xxscrew_translate(bltouchScrews[0])-[bltouch_screwp.x,0,platet])
		bltouch();
}

module fan_holder_at_carriage() {
	translate([0,0,-mosquito_hotend_fanz])
		fan_holder(xxscrew_translate(fanHolderScrews[0])+[0,0,mosquito_hotend_fanz-platet],-fanholderd);
}

carriage_stl();
*bltouch_at_carriage();
*mosquito_hotend();
//translate([cl/2-bltouch_screwp.x+bltouch_offx,cw+mq.y/2+mqo+bltouch_offy+bltouch_screwp.y,0])
translate([0,0,-mosquito_hotend_fanz]) {
	*mosquito_fan_duct_stl();
	*fan_holder(xxscrew_translate(fanHolderScrews[0])+[0,0,mosquito_hotend_fanz-platet],-fanholderd);
}
