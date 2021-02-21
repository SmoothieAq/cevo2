include <../cevo2.scad>
include <../defs/base_defs.scad>

use <frame2_assembly.scad>
use <../parts/idler_holder.scad>


module frame10_assembly() assembly("frame10") {
    frame2_assembly();
    explode([extr_d2, -extr_d2, -extr_d2/2], explode_children = true) {
        idler_assembly();
        xxside1(concat(idlerHolderScrews(0, true), idlerHolderScrews(0, false)));
        xxside1(concat(idlerHolderScrews(1, true), idlerHolderScrews(1, false)));
    }
}

frame10_assembly();



