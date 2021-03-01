include <NopSCADlib/core.scad>

orbiter_extruder_screwps = [[-16.5,1,4.5],[18,6,4.5]];

module orbiter_extruder() {
	vitamin("orbiter_extruder(): Orbiter Extruder and motor");
	// stl from https://www.thingiverse.com/thing:4725897
	color([0.3, 0.28, 0.31]) {
		translate([-6.7, 22, 18]) rotate([0, 67.785, 180]) import("../extparts/Orbiter_Housing_1.5.stl");
		translate([-6.5, -10.5, 18.5]) rotate([180, 0, 0]) import("../extparts/Latch_v1.5.stl");
		translate([-6.5,21.6,18.0]) rotate([0, 0, 0]) import("../extparts/Gear_Housing_65_teeth.stl");
		translate([-6, 29.2, 18]) rotate([90, 0, 180]) cylinder(20, d = 36.5);
	}
}

//orbiter_extruder();