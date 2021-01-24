include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <NopSCADlib/vitamins/tubings.scad>

module leads_assembly() {assembly("leads");

	for (lead = leads) {
		lp = lead[0];
		bp = lead[1];
		translate([lp.x, lp.y, 0]) {
			translate([0, 0, frame_y_z1 + extr_d2]) {
				l = NEMA_shaft_length(leads_motor)[0];
				NEMA(leads_motor);
				translate([0, 0, l - bb_width(lead_bearing) / 2]) ball_bearing(lead_bearing);
			}
			z = pos_z - bed.z - holder_thick1 - holder_offz - bed_off;
			translate([0, 0, z - leadnut_flange_t(leadnut)]) {
				leadnut(leadnut);
			}
			translate([0, 0, z]) {
				holder(lp - bp);
			}
		}
	}
	for (p12 = [[leads[0][1]-[bed_off*3,0],leads[1][1]],[leads[1][1],leads[2][1]],[leads[2][1],leads[0][1]-[bed_off*3,0]]]) {
		rel = p12[1]-p12[0];
		l = sqrt(sqr(rel.x)+sqr(rel.y));
		a = atan(rel.y/rel.x) - (rel.x < 0 ? 180 : 0);
		translate([p12[0].x,p12[0].y,pos_z-bed.z-bed_off-holder_thick2/2])
			rotate([0,90,a])
				translate([0,0,l/2])
					tubing(CARBONFIBER10, length=l);
	}
}

module holder(rbp) {
	rotate([0,0,atan(rbp.x/rbp.y)]) {
		ld = leadnut_flange_dia(leadnut);
		lh = leadnut_height(leadnut);
		color("darkgrey") {
			cylinder(holder_thick1, d = ld);
			translate([- holder_thick2 / 2, 0, 0])
				cube([holder_thick2, ld / 2 + 0.1, holder_thick1]);
			translate([- holder_thick2 / 2, ld / 2 + holder_thick1 - 0.1, holder_thick1])
				rotate([50, 0, 0]) translate([0, - holder_thick1 * 1.5, - holder_thick1])
					cube([holder_thick2, holder_off * 4, holder_thick1]);
			translate([- holder_thick2 / 2, ld / 2, - lh])
				cube([holder_thick2, holder_thick1, holder_thick1 + lh]);
			translate([- holder_thick2 / 2, ld / 2 + holder_thick1 + holder_off, - holder_thick2 + holder_thick1 +
				holder_offz])
				cube([holder_thick2, holder_thick2, holder_thick2]);
		}
	}
}

//leads_assembly();
holder(); //leadnut(leadnut);