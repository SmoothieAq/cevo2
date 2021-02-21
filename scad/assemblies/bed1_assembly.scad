include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <NopSCADlib/vitamins/tubings.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
use <../parts/bed_holder.scad>

module bed1_assembly() assembly("bed1") {

	for (i = [0:2])
		for_leads(i, pos_z-bed.z-holder_thick1-holder_offz-bed_off) {
			rotate([0, 0, holder_a(i)-i*90]) explode(5, explode_children=true) {
				if (i == 0) {bed_holderL2_stl();}
				if (i == 1) {bed_holderF2_stl();}
				if (i == 2) {bed_holderB2_stl();}
				xxside2(bed_holder_lead_screws(i));
				xxside1(bed_holder_lead_screws(i));
				holder_pins(i);
			}
			translate([0,0,-leadnut_flange_t(leadnut)])
				xleadnut(leadnut);
		}
}

bed1_assembly();