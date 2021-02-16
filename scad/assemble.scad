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
//    leads_assembly();
//    bed_assembly();
}

module frame_y_assembly() assembly("frame_y") {
    frame3_assembly();
//    explode([extr_d2,0,0]) yl_assembly();
//    explode([-extr_d2,0,0]) yr_assembly();
}

module frame3_assembly() assembly("frame2") {//}pose(a=[-5,-5,45],t=[frame_p4.x/2,frame_p4.y/2,frame_y_z2+50]){
    frame_assembly();
    explode([extr_d2,-extr_d2,-extr_d2/2],explode_children=true) {
        idlerl_assembly();
        xxside1(concat(idlerHolderScrews(0,true),idlerHolderScrews(0,false)));
    }
    explode([-extr_d2,-extr_d2,-extr_d2/2],explode_children=true) {
        idlerr_assembly();
        xxside1(concat(idlerHolderScrews(1,true),idlerHolderScrews(1,false)));
    }
}

main_assembly();



