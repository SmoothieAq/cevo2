include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <NopSCADlib/vitamins/tubings.scad>

module leads_assembly() {assembly("leads");

	nudge1 = [bed_off*1,0];
	p12s = [[leads[0][1]-nudge1,leads[1][1]],[leads[1][1],leads[2][1]],[leads[2][1],leads[0][1]-nudge1]];

	for (i = [0:2]) {
		lp = leads[i][0];
		bp = leads[i][1];
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
			translate([0, 0, z]) { echo(x1=p12s[i].x,y1=p12s[i].y,x2=p12s[i].x,y2=p12s[(i+5)%3].x);
				holder(lp - bp,p12s[i].y-p12s[i].x, p12s[(i+5)%3].x-p12s[i].x);
			}
		}
	}
	for (p12 = p12s) {
		rel = p12[1]-p12[0];
		l = sqrt(sqr(rel.x)+sqr(rel.y));
		lc = holder_thick2*0.4;
		a = atan(rel.y/rel.x) - (rel.x < 0 ? 180 : 0);
		translate([p12[0].x,p12[0].y,pos_z-bed.z-bed_off-holder_thick2/2])
			rotate([0,90,a])
				translate([0,0,l/2])
					tubing(CARBONFIBER10, length=l-lc*2);
	}
}

module holder(rbp,rr1,rr2) {
	ld = leadnut_flange_dia(leadnut);
	lh = leadnut_height(leadnut);
	lfh = leadnut_flange_t(leadnut);
	lad = xleadnut_antib_od(leadnut);
	lah = xleadnut_antib_h(leadnut);
	a = atan(rbp.x/rbp.y);
	rl = sqrt(sqr(rbp.x)+sqr(rbp.y));
	ar1 = atan(rr1.y/rr1.x);
	ar2 = atan(rr2.y/rr2.x); echo(r1=rr1,a1=ar1,r2=rr2,a2=ar2,ar2=90+(ar2%90));
	rotate([0,0,a]) {
		color([.15,.15,.15]) {
			difference() {
				union() {
					cylinder(holder_thick1, d = ld);
					ax = rl-lad/2-holder_thick2/2-2+5;
					ay = holder_offz+holder_thick1+lh-holder_thick2;
					a = atan(ay/ax);
					translate([0,lad/2+2,-lh])
						rotate([a-90,0,0])
							translate([0,-lad/2,-2])
								cylinder(60,d=lad);
					rotate([-90,0,0])
						cylinder(ld/2+holder_thick1,d=lad);
					translate([0, rl, - holder_thick2 + holder_thick1 + holder_offz])
						cylinder(holder_thick2, d=holder_thick2);
					translate([0,rl,-holder_thick2/2+holder_thick1+holder_offz]) {
						rotate([0, 90, 90+(ar1%90)])
							cylinder(holder_thick2, d = holder_thick2);
						rotate([0, 90, 180+ar2])
							cylinder(holder_thick2, d = holder_thick2);
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
			}
		}
	}
}

//leads_assembly();
holder([0,34],[0,304]); //leadnut(leadnut);