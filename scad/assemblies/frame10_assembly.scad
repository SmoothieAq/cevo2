include <../cevo2.scad>
include <../defs/base_defs.scad>

use <frame3_assembly.scad>
use <../parts/idler_holder.scad>


module frame10_assembly() pose(a=[ 106.10, 0.00, 46.70 ],t=[ 58.97, 377.36, 545.58 ],d=169.15,exploded=true) assembly("frame10") {
    frame3_assembly();
    explode([extr_d2, -extr_d2, -extr_d2/2], explode_children = true) {
        idler_assembly();
        xxside1(concat(idlerHolderScrews(0, true), idlerHolderScrews(0, false)));
        xxside1(concat(idlerHolderScrews(1, true), idlerHolderScrews(1, false)));
    }
}

frame10_assembly();



