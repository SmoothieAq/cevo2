include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <NopSCADlib/vitamins/tubings.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
include <dotSCAD/ptf/ptf_rotate.scad>
include <dotSCAD/util/flat.scad>

function holder_tub1l(i)    = len2(holder_bedp((i+1)%3)-holder_bedp(i));
function holder_tub1a(i)    = a2(holder_bedp((i+1)%3)-holder_bedp(i));
function holder_tub2a(i)    = a2(holder_bedp((i+5)%3)-holder_bedp(i));
function holder_l(i)        = len2(holder_bedp(i)-holder_leadp(i));
function holder_a(i)        = a2(holder_bedp(i)-holder_leadp(i))-90;

function holderScrews(i) = let(
	of = holder_thick2/3,
	pd = tubing_od(holder_tube)/2+screw_radius(screwPart),
	rl = holder_l(i),
	as = [holder_tub1a(i),holder_tub2a(i)],
	ps = [ for (x = [pd,-pd]) [x,holder_thick2,of] ],
	pss = [ for (a = as, p = ps) ptf_rotate(p,[0, 0, a])+[0,rl,-holder_thick2/2+holder_thick1+holder_offz] ],
	screw = axxscrew_setLeng(screwPart,thick=of*2)
) [ for (p = pss) axxscrew(screw,t=p) ];

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
				if (i == 0) part_holderL();
				if (i == 1) part_holderF();
				if (i == 2) part_holderB();
			}
		}
	}
	for (i = [0:2]) {
		bp = holder_bedp(i);
		l = holder_tub1l(i);
		lc = holder_thick2*0.4;
		a = holder_tub1a(i);
		translate([bp.x,bp.y,pos_z-bed.z-bed_off-holder_thick2/2])
			rotate([0,90,a])
				translate([0,0,l/2])
					tubing(holder_tube, length=l-lc*2);
	}
}

module part_holderL() {stl("holderL");
	holder(0);
	xxpart1fasten(holderScrews(0));
}
module part_holderF() {stl("holderL");
	holder(1);
}
module part_holderB() {stl("holderL");
	holder(2);
}

module holder(i) {
	ld = leadnut_flange_dia(leadnut);
	lh = leadnut_height(leadnut);
	lfh = leadnut_flange_t(leadnut);
	lad = xleadnut_antib_od(leadnut);
	lah = xleadnut_antib_h(leadnut);
	a = holder_a(i);
	rl = holder_l(i);
	ar1 = holder_tub1a(i);
	ar2 = holder_tub2a(i);
//	rotate([0,0,a]) {
		color([.15,.15,.15]) {
			difference() {
				union() {
					cylinder(holder_thick1, d = ld);
					hax = rl-lad/2-holder_thick2/2-4+5;
					hay = holder_offz+holder_thick1+lh-holder_thick2;
					ha = atan(hay/hax);
					translate([0,lad/2+2,-lh])
						rotate([ha-90,0,0])
							translate([0,-lad/2,-4])
								cylinder(59,d2=holder_thick2,d1=lad);
					difference() {
						rotate([-90, 0, 0])
							cylinder(ld/2+holder_thick1, d1 = holder_thick2,d2=holder_thick2-(holder_thick2-lad)/2);
						translate([-holder_thick2/2-1,-1,holder_thick1])
							cube([holder_thick2+2,ld/2+holder_thick1+2,holder_thick1]);
						translate([-holder_thick2/2-1,-1,-holder_thick1-lfh])
							cube([holder_thick2+2,ld/2+holder_thick1+2,holder_thick1]);
					}
					translate([0, rl, - holder_thick2 + holder_thick1 + holder_offz])
						cylinder(holder_thick2, d=holder_thick2);
					translate([0,rl,-holder_thick2/2+holder_thick1+holder_offz]) {
						rotate([0, 90, ar1-a])
							cylinder(holder_thick2*1.5, d = holder_thick2);
						rotate([0, 90, ar2-a])
							cylinder(holder_thick2*1.5, d = holder_thick2);
					}
				}
				translate([0,0,-lfh-0.1])
					cylinder(lfh+0.1,d=ld+0.2);
				translate([0,0,-lh+lah])
					cylinder(lh-lfh-lah,d2=ld+0.2,d1=lad+0.1);
				translate([0,0,-lh-0.1])
					cylinder(lah+0.2,d=lad+0.1);
				translate([0,0,-lh*2])
					cylinder(lh,d=lad*2);
				translate([0,0,-0.1])
					cylinder(holder_thick1+0.2,d=leadnut_bore(leadnut)+0.6);
				translate([0, rl, holder_thick1 + holder_offz])
					cylinder(holder_thick2*2, d=holder_thick2*2);
				translate([0,rl,-holder_thick2/2+holder_thick1+holder_offz]) {
					rotate([0, 90, ar1-a]) //rotate([0, 90, 90+(ar1%90)])
						translate([0,0,holder_thick2*0.4-0.4])
							cylinder(holder_thick2*1.1+0.6, d = tubing_od(holder_tube));
					rotate([0, 90, ar2-a]) //rotate([0, 90, 180+ar2])
						translate([0,0,holder_thick2*0.4-0.4])
							cylinder(holder_thick2*1.1+0.6, d = tubing_od(holder_tube));
				}
			}
		}
//	}
}

//leads_assembly();
part_holderL();
//xxpart1fasten(holderScrews(0)); echo(holderScrews(0));
for (s = holderScrews(0)) echo(xxscrew_descr(s));