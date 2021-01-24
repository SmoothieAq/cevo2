include <../cevo2.scad>
include <../defs/loops_defs.scad>

include <../../../xNopSCADlib/xVitamins/xrails.scad>

module y_assembly() {assembly("y");


	rail_y = axrail(MGN12H,extr_y_len,MaterialBlackSteel);

	translate([extr_d2,extr_d2,frame_y_z3])
		rotate([90,0,90])
			xrail_assembly(rail_y,pos=pos_y-extr_d2);

	translate([extr_x_len+extr_d2,extr_d2,frame_y_z3])
		rotate([-90,0,90])
			xrail_assembly(rail_y,pos=pos_y-extr_d2);
}

y_assembly();