include <../cevo2.scad>
include <../defs/loops_defs.scad>

difference() {
	cube([extr_d*2+rail_height(rail_y), extr_d*1.5, 15]);
	translate([2,extr_d2/2+4,-1]) cube([extr_d,extr_d-8,17]);
	translate([extr_d-0.2,extr_d2/2,-1]) cube([extr_d+0.4,extr_d,17]);
	translate([extr_d*2-1,extr_d*1.5/2-rail_width(rail_y)/2,-1]) cube([rail_height(rail_y)+2,rail_width(rail_y),17]);
}

