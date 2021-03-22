include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame35_assembly.scad>
use <../parts/x_holder.scad>


module frame40_assembly() assembly("frame40") {
    frame35_assembly();
    for (i = [0,1]) {
        loop = loops[i];
        translate([0, 0, loop.x])
            belt(belt, loop.y, open=true, start_twist = i, tooth_colour = [0.35,0.15,0.18]);
    }
}

frame40_assembly();



