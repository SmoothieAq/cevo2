include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/leads_defs.scad>

use <frame_assembly.scad>
use <../parts/leads_motor_holder.scad>
use <leads2_assembly.scad>


module frame1_assembly() pose(a=[ 57.10, 0.00, 53.70 ],t=[ 147.86, 141.88, 259.86 ],d=169.02,exploded=true) assembly("frame1") {
    frame_assembly();
    explode([extr_d2, 0, extr_d2/2], explode_children = true) {
        leads2_assembly();
        for (i = [0:2])
            for_leads(i,frame_y_z1+extr_d2)
                xxside1(leads_motor_mount_screws());
    }
}

frame1_assembly();



