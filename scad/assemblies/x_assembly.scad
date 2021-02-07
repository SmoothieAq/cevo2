include <../cevo2.scad>
include <../defs/loops_defs.scad>

include <../../../xNopSCADlib/xVitamins/xrails.scad>
include <NopSCADlib/vitamins/tubings.scad>

module x_assembly() assembly("x") {


	translate([extr_d2-xrail_xoff,pos_y,xrail_z]) {
		xrail_assembly(rail_x, pos=pos_x-extr_d2+xrail_xoff);
//		translate([xrail_len/2,0,-5]) rotate([0,-90,0]) tubing(CARBONFIBER10, length=xrail_len);
	}

//	translate([pos_x,pos_y-26,xrail_z-26]) rotate([90,0,180]) import("C:/Users/jespe/Downloads/Mosquito_Hotend_Std.STL");
//	translate([pos_x-57,pos_y-6,xrail_z+38]) translate([50,0,0]) import("C:/Users/jespe/Downloads/HubHousing_V5.stl");
}

x_assembly();