include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame11_assembly.scad>
//use <frame_assembly.scad>

carriage_y = xrail_carriage(rail_y);
cpx = carriage_pitch_x(carriage_y);

module frame20_assembly() pose(a=[ 55.00, 0.00, 25.00 ],t=[ -6.95, 270.65, 513.40 ],d=818.74,exploded=true) assembly("frame20") {
    frame11_assembly();
//    frame_assembly();
    for (i = [0,1])
        translate([extr_d2+i*extr_x_len,extr_d2,frame_y_z3])
            rotate([i?-90:90,0,90]) {
                xrail_assembly(rail_y, pos = pos_y-extr_d2-cpx/2);
                for (p = rail_hole_nps(rail_y))
                    translate([p,0,rail_height(rail_y)-rail_bore_depth(rail_y)])
                        xscrew(axscrew(rail_screw(rail_y),l=5,material=MaterialBlackSteel));
            }
}

frame20_assembly();



