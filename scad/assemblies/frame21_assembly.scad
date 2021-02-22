include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame20_assembly.scad>
use <../parts/x_holder.scad>


module frame21_assembly() pose(a=[ 51.50, 0.00, 49.50 ],t=[ -66.53, 180.60, 464.09 ],d=435.58,exploded=true) assembly("frame21") {
    frame20_assembly();
    explode([xyholder_thick2,0,0],explode_children=true) {
        x_holderL1_stl();
        xxside1(x_holder_idler_screws(0));
        xxside1(x_holder_carriage_screws(0));
    }
    explode([-xyholder_thick2,0,0],explode_children=true) {
        x_holderR1_stl();
        xxside1(x_holder_idler_screws(1));
        xxside1(x_holder_carriage_screws(1));
    }
}

frame21_assembly();



