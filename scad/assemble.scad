include <cevo2.scad>
include <defs/base_defs.scad>

use <assemblies/frame.scad>
use <assemblies/y_assembly.scad>
use <assemblies/x_assembly.scad>
use <assemblies/bed.scad>
use <assemblies/loops.scad>
use <assemblies/leads.scad>

module main_assembly() assembly("main") {
    frame_y_assembly();
//    y_assembly();
//    x_assembly();
    loops_assembly();
    leads_assembly();
    bed_assembly();
}

module frame_y_assembly() assembly("frame_y") {
    frame_assembly();
    explode([extr_d2,0,0]) yl_assembly();
    explode([-extr_d2,0,0]) yr_assembly();
}

main_assembly();



