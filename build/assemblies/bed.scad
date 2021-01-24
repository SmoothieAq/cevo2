include <../cevo2.scad>
include <../defs/base_defs.scad>

module bed_assembly() {assembly("bed");

	translate([bed_x_off,bed_y_off,pos_z-bed.z])
		color([0.8,0.8,0.8,0.3])
			cube(bed);
}

bed_assembly();