include <NopSCADlib/core.scad>

mosquito_hotend_offy = 3;
mosquito_hotend_size = [25,13,41]; // clone [25,14,41,6]
mosquito_hotend_topt = 3.8;
mosquito_hotend_fanz = 44;
mosquito_hotend_screwps = [[-6,0,0],[6,0,0]];
mosquito_hotend_fan_screwps = [[-10,-6.5,-2.5],[10,-6.5,-2.5]];

module mosquito_hotend() {
	vitamin("mosquito_hotend(): Mosquito hotend");
	// stl from https://www.thingiverse.com/thing:3002858
	translate([0, 0, -mosquito_hotend_size.z])
		color([0.3, 0.28, 0.31])
			rotate([90, 0, 180]) import("../extparts/Mosquito_Hotend_Std.STL");
}

//mosquito_hotend();