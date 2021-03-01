include <NopSCADlib/core.scad>

bltouch_offy = 0.4;
bltouch_size = [26,11.6,43]; // without wires
bltouch_screw_holdert = 2.3;
bltouch_screwp = [9,5.8,0];

module bltouch(extracted=false) {
	vitamin("bltouch(): BLTouch");
	// stl from https://www.thingiverse.com/thing:1229934
	rotate([180,0,0])
		color([0.9,0.88,0.91]) import(extracted ? "../extparts/BLTouch_extracted.stl" : "../extparts/BLTouch_contracted.stl");
}

