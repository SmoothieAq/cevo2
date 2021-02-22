include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame21_assembly.scad>
use <../parts/x_holder.scad>


module frame22_assembly() pose(a=[ 236.30, 0.00, 261.40 ],t=[ 185.05, 57.07, 433.68 ],d=124.81,exploded=true) assembly("frame22") {
    frame21_assembly();
    explode([0,0,-xyholder_thick2],explode_children=true) {
        x_holderL2_stl();
        xxside2(x_holder_idler_screws(0));
        xxside2(x_holder_screws(0));
        x_holderR2_stl();
        xxside2(x_holder_idler_screws(1));
        xxside2(x_holder_screws(1));
    }
    explode([0,0,-xyholder_thick2/2],explode_children=true) {
        idler_idler(0);
        idler_idler(1);
        translate([extr_d2-xrail_xoff,pos_y,xrail_z]) {
            xrail_assembly(rail_x, pos=pos_x-extr_d2+xrail_xoff);
            //		translate([xrail_len/2,0,-5]) rotate([0,-90,0]) tubing(CARBONFIBER10, length=xrail_len);
        }
    }
    xxside1(x_holder_screws(0));
    xxside1(x_holder_screws(1));
}

frame22_assembly();



