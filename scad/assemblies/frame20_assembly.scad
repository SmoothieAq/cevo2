include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame11_assembly.scad>
use <../parts/x_holder.scad>
//use <frame_assembly.scad>

carriage_y = xrail_carriage(rail_y);
cpx = carriage_pitch_x(carriage_y);

module frame20_assembly() pose(a=[ 55.00, 0.00, 25.00 ],t=[ -6.95, 270.65, 513.40 ],d=818.74,exploded=true) assembly("frame20") {
    frame11_assembly();
//    frame_assembly();
    for (i = [0,1]) translate([extr_d2+i*extr_x_len, 0, frame_y_z3]) {
        translate([0, yrail_yoff, 0]) {
            rotate([i?-90:90, 0, 90]) {
                xrail_assembly(rail_y, pos = pos_y-yrail_yoff-cpx/2);
                ps = rail_hole_nps(rail_y);
                for (i = [1:len(ps)-2])
                    translate([ps[i], 0, rail_height(rail_y)-rail_bore_depth(rail_y)])
                        xscrew(axscrew(rail_screw(rail_y), l = 12, material = MaterialBlackSteel));
            }
        }
        translate([0, extr_d2+extr_y_len, 0])
            rotate([0,i?-90:90,0])
                explode([0,0,10],explode_children=true) {
                    rotate([-90,0,0]) rail_y_back_stop_stl();
                    xxside1(rail_y_back_stop_screws());
                }
        translate([0, extr_d2, 0])
            rotate([0,i?-90:90,0])
                explode([0,0,10],explode_children=true) {
                    rotate([-90,0,0]) rail_y_front_stop_stl();
                    xxside1(rail_y_front_stop_screws());
                }
    }
}

include <../defs/leads_defs.scad>
frame20_assembly();



