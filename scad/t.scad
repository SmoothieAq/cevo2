include <nopSCADlib/vitamins/extrusions.scad>

difference() {
	union() {
		extrusion(E3030, length = 100, center = false);
		translate([60, -15, 0]) cube([30, 30, 100]);
	}
	translate([-20,-20,50]) cube([120,100,60]);
}