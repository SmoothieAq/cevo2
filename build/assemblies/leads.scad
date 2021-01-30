include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <NopSCADlib/vitamins/tubings.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
use <dotSCAD/ptf/ptf_rotate.scad>
use <dotSCAD/util/flat.scad>

function holder_tub1l(i)    = len2(holder_bedp((i+1)%3)-holder_bedp(i));
function holder_tub1a(i)    = a2(holder_bedp((i+1)%3)-holder_bedp(i));
function holder_tub2a(i)    = a2(holder_bedp((i+5)%3)-holder_bedp(i));
function holder_l(i)        = len2(holder_bedp(i)-holder_leadp(i));
function holder_a(i)        = a2(holder_bedp(i)-holder_leadp(i))-90;
function holder_tubp(i) 	= [0,holder_l(i),-holder_thick2/2+holder_thick1+holder_offz];
function holder_pina(i)		= let ( bed_center = [bed_x_off+bed.x/2,bed_y_off+bed.y/2] ) a2(bed_center-holder_bedp(i))-holder_a(i)-90;

holderScrews = [ for (i = [0:2]) let(
	screw = axxscrew_setLengAdjustThick(screwPart,thick=holder_thick2/3*2,plate=3,nut_plate=3),
	of = xxscrew_thick(screw)/2,
	pd = tubing_od(holder_tube)/2+screw_radius(screwPart),
	rl = holder_l(i),
	ah = holder_a(i),
	as = [holder_tub1a(i),holder_tub2a(i)],
	ps = [ for (x = [pd,-pd]) [x,holder_thick2,of] ],
	pss = [ for (a = as, p = ps) ptf_rotate(p,[0, 0, a-ah-90])+holder_tubp(i) ],
	psss = [pss[0],(pss[1]+pss[2])/2,pss[3]]
) [ for (p = psss) axxscrew(screw,t=p) ] ];

leadScrews = [ for (i = [0:2]) let(
	screw = axxscrew_setLeng(screwPart,thick=holder_thick1+leadnut_flange_t(leadnut),nut_depth=0,nut_spacing=0),
	pss = [ for (p = leadnut_screw_poss(leadnut)) ptf_rotate(p,[0,0,45])+[0,0,holder_thick1-leadnut_flange_t(leadnut)] ]
) [ for (p = pss) axxscrew(screw,t=p) ] ];

module leads_assembly() {assembly("leads");

	for (i = [0:2]) {
		lp = leads[i][1];
		bp = leads[i][2];
		bp_p = leads[(i+1)%3][2];
		bp_m = leads[(i+5)%3][2];
		translate([lp.x, lp.y, 0]) {
			translate([0, 0, frame_y_z1 + extr_d2]) {
				l = NEMA_shaft_length(leads_motor)[0];
				NEMA(leads_motor);
				translate([0, 0, l - bb_width(lead_bearing) / 2]) ball_bearing(lead_bearing);
			}
			z = pos_z - bed.z - holder_thick1 - holder_offz - bed_off;
			translate([0, 0, z - leadnut_flange_t(leadnut)]) {
				xleadnut(leadnut);
			}
			translate([0, 0, z]) rotate([0,0,holder_a(i)]) {
				if (i == 0) {part_holderL2(); part_holderL1();}
				if (i == 1) {part_holderF2(); part_holderF1();}
				if (i == 2) {part_holderB2(); part_holderB1();}
				xxside2(holderScrews[i]);
				xxside1(holderScrews[i]);
				xxside2(leadScrews[i]);
				xxside1(leadScrews[i]);
				echo(pina=holder_pina(i));
				holder_pins(i);
			}
		}
	}
	for (i = [0:2]) {
		bp = holder_bedp(i);
		l = holder_tub1l(i);
		lc = holder_thick2*0.5+0.5;
		a = holder_tub1a(i);
		translate([bp.x,bp.y,pos_z-bed.z-bed_off-holder_thick2/2])
			rotate([0,90,a])
				translate([0,0,l/2])
					tubing(holder_tube, length=l-lc*2);
	}
}

module part_holderL2() {stl("holderL2"); holder2(0); }
module part_holderF2() {stl("holderF2"); holder2(1); }
module part_holderB2() {stl("holderB2"); holder2(2); }
module part_holderL1() {stl("holderL1"); holder1(0); }
module part_holderF1() {stl("holderF1"); holder1(1); }
module part_holderB1() {stl("holderB1"); holder1(2); }

module holder2(i,color=[.15,.15,.15]) {
	ld = leadnut_flange_dia(leadnut);
	lh = leadnut_height(leadnut);
	lfh = leadnut_flange_t(leadnut);
	lad = xleadnut_antib_od(leadnut);
	lah = xleadnut_antib_h(leadnut);
	rl = holder_l(i);
	a = holder_a(i);
	a1 = holder_tub1a(i)-a;
	a2 = holder_tub2a(i)-a;
	color(color) {
		difference() {
			union() {
				c = i == 1 ? [8,0] : [6.5,5]; // hack :-(
				cylinder(holder_thick1, d = ld); // plate on lead-nut
				hax = rl-lad/2-holder_thick2/2-6+c[0];
				hay = holder_offz+holder_thick1+lh-holder_thick2;
				ha = atan(hay/hax);
				translate([0,lad/2+6,-lh])
					rotate([ha-90,0,0])
						translate([0,-lad/2,-4])
							cylinder(54,d2=holder_thick2,d1=lad); // support
				difference() {
					rotate([-90, 0, 0])
						cylinder(ld/2+holder_thick1+c[1], d1 = holder_thick2,d2=holder_thick2-(holder_thick2-lad)/2); // from plate to support
					translate([-holder_thick2/2-1,-1,holder_thick1])
						cube([holder_thick2+2,ld/2+holder_thick1+2,holder_thick1]); // upper cut
					translate([-holder_thick2/2-1,-1,-holder_thick1-lfh])
						cube([holder_thick2+2,ld/2+holder_thick1+2,holder_thick1]); // lower cut
				}
				translate([0, rl, - holder_thick2 + holder_thick1 + holder_offz])
					cylinder(holder_thick2, d=holder_thick2); // bed support
				holder_tub(i,a1,a2,90)
					cylinder(holder_thick2*1.5, d = holder_thick2); // tube holder
				let (s = holderScrews[i][1], t = xxscrew_thick(s))
					translate(xxscrew_translate(s)-[0,0,t])
						cylinder(t/2, r= screw_radius(s)*3);
				xxside2_plate(holderScrews[i]);
			}
			translate([0,0,-lfh-0.1])
				cylinder(lfh+0.1,d=ld+0.2); // cut for leadnut top
			translate([0,0,-lh+lah])
				cylinder(lh-lfh-lah,d2=ld+0.2,d1=lad+0.1); // cut for support
			translate([0,0,-lh-0.1])
				cylinder(lah+0.2,d=lad+0.1); // cut for leadnut bot
			translate([0,0,-lh*2])
				cylinder(lh,d=lad*2); // cut of bot
			translate([0,0,-0.1])
				cylinder(holder_thick1+0.2,d=leadnut_bore(leadnut)+0.6); // cut for leadnut bore
			translate([0, rl, holder_thick1 + holder_offz]) {
				cylinder(holder_thick2 * 2, d = holder_thick2 * 2); // cut of top
				d = xshaft_diameter(holder_pin);
				l = xshaft_length(holder_pin);
				o = (holder_ball-d)/1.5;
				wd = washer_diameter(holder_washer);
				wt = washer_thickness(holder_washer);
				rotate([0,0,holder_pina(i)]) translate([0,l/2,0])
					rotate([90,0,0]) {
						cylinder(l, d = d);
						translate([o,0,0]) cylinder(l, d = d);
						translate([-o,0,0]) cylinder(l, d = d);
						translate([0,-wd/6,-wt]) cylinder(wt, d = wd);
						translate([-wd/2,-wd/6-wd/2,-wt]) cube([wd,wd,wt]);
						translate([0,-wd/6,l]) cylinder(wt, d = wd);
						translate([-wd/2,-wd/6-wd/2,l]) cube([wd,wd,wt]);
					}
				translate([-holder_thick2/3,-holder_thick2/3,-0.5])
					linear_extrude(1)
						text(holder_name(i),size=5);
			}
			holder_tubcut(i,a1,a2);
			holder_tub(i,a1,a2)
				translate([holder_thick2/2,-holder_thick2,0])
					cube([holder_thick2*2,holder_thick2*2,holder_thick2]); // cut for side1
			xxside2_hole(holderScrews[i]);
			xxside2_hole(leadScrews[i]);
		}
	}
}
module holder_pins(i) {
	rl = holder_l(i);
	d = xshaft_diameter(holder_pin);
	l = xshaft_length(holder_pin);
	o = (holder_ball-d)/1.5;
	wd = washer_diameter(holder_washer);
	wt = washer_thickness(holder_washer);
	translate([0, rl, holder_thick1 + holder_offz])
		rotate([0,0,holder_pina(i)]) translate([0,l/2,0])
			rotate([90,0,0]) {
				translate([o,0,0]) xshaft(holder_pin);
				translate([-o,0,0]) xshaft(holder_pin);
				translate([0,-wd/6,-wt]) washer(holder_washer);
				translate([0,-wd/6,l]) washer(holder_washer);
			}
}
module holder1(i,color=[.15,.15,.15]) {
	ld = leadnut_flange_dia(leadnut);
	lh = leadnut_height(leadnut);
	lfh = leadnut_flange_t(leadnut);
	lad = xleadnut_antib_od(leadnut);
	lah = xleadnut_antib_h(leadnut);
	rl = holder_l(i);
	a = holder_a(i);
	a1 = holder_tub1a(i)-a;
	a2 = holder_tub2a(i)-a;
	color(color) {
		difference() {
			union() {
				holder_tub(i,a1,a2,90)
				difference() {
					cylinder(holder_thick2*1.5, d = holder_thick2); // tube holder
					translate([-0.1, - holder_thick2, holder_thick2/2])
						cube([holder_thick2 / 2 +part_assemble_nudge, holder_thick2 * 2, holder_thick2+2]); // end cut for side2
					translate([-holder_thick2 / 2, - holder_thick2, -holder_thick2/2+part_assemble_nudge])
						cube([holder_thick2 * 2, holder_thick2 * 2, holder_thick2]); // bot cut for side2
				}
				let (s = holderScrews[i][1], t = xxscrew_thick(s))
					translate(xxscrew_translate(s)+[0,0,-t/2+part_assemble_nudge])
						cylinder(t/2-part_assemble_nudge, r= screw_radius(s)*3);
				xxside1_plate(holderScrews[i]);
			}
			holder_tubcut(i,a1,a2);
			xxside1_hole(holderScrews[i]);
		}
	}
}

//module holder_tubholder(i,a1,a2) {
//	holder_tub(i,a1,a2,90)
//		cylinder(holder_thick2*1.5, d = holder_thick2); // tube holder
//}
module holder_tubcut(i,a1,a2) {
	holder_tub(i,a1,a2,90)
		translate([0,0,holder_thick2*0.5])
			cylinder(holder_thick2*1.1+0.6, d = tubing_od(holder_tube)); // cut for tube
}
module holder_tub(i,a1,a2,r=0) {
	translate(holder_tubp(i)) {
		rotate([0, r, a1])
			children();
		rotate([0, r, a2])
			children();
	}
}

//leads_assembly();
part_holderL2();
//holder_pins(2);
//part_holderL1();
//xxside2(holderScrews[0]);
//xxside1(holderScrews[0]);
//xxside2(leadScrews[0]);
//xxside1(leadScrews[0]);

//xxpart1fasten(holderScrews[0]); echo(holderScrews[0]);
//for (s = holderScrews[0]) echo(xxscrew_descr(s));