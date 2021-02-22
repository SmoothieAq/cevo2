include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame22_assembly.scad>
use <../parts/x_holder.scad>


module frame40_assembly() assembly("frame40") {
    frame22_assembly();
    for (loop = loops) {
        translate([0, 0, loop.x]) {
            for (p = loop.y)
            translate([p.x, p.y, 0])
                pulley_assembly(p.z);
            belt(GT2x6, [for (p = loop.y) [p.x, p.y, p[3] * pulley_pr(p[2])]]);
        }
    }
}

frame40_assembly();



