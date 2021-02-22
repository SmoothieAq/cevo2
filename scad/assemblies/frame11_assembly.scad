include <../cevo2.scad>
include <../defs/base_defs.scad>

use <frame10_assembly.scad>
use <../parts/loops_motor_holder.scad>


module frame11_assembly() pose(a=[ 73.20, 0.00, 121.60 ],t=[ 174.20, 153.85, 598.54 ],d=189.55,exploded=true) assembly("frame11") {
    frame10_assembly();
    explode([extr_d2, extr_d2, 0], explode_children = true) {
        loops_motor_holder_assembly();
        for (i = [0,1])
            xxside1(loops_motor_mount_screws(i));
    }
}

frame11_assembly();



