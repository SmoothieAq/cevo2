include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
use <../parts/leads_motor_holder.scad>

module leads1_assembly() pose(a=[ 55.00, 0.00, 25.00 ],t=[ 92.63, 102.34, 274.30 ],d=194.49,exploded=true) assembly("leads1") {

	for (i = [0:2])
		for_leads(i,frame_y_z1+extr_d2){
			NEMA(leads_motor);
			explode(extr_d2,explode_children=true) {
				leads_motor_holder_stl();
				xxside1(motor_screws());
			}
		}
}



leads1_assembly();
