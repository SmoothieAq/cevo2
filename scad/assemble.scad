include <cevo2.scad>
include <defs/base_defs.scad>

use <assemblies/frame22_assembly.scad>
//use <assemblies/x_holder.scad>
//use <assemblies/x_assembly.scad>
//use <assemblies/bed.scad>
//use <assemblies/loops.scad>
//use <assemblies/leads.scad>

module main_assembly() assembly("main") {
    frame22_assembly();
//    frame_y_assembly();
//    y_assembly();
//    x_assembly();
//    loops_assembly();
//    leads_assembly();
//    bed_assembly();
}

//module frame_y_assembly() assembly("frame_y") {
//    frame3_assembly();
////    explode([extr_d2,0,0]) yl_assembly();
////    explode([-extr_d2,0,0]) yr_assembly();
//}


//module clip_pose(xmin = -inf, ymin = -inf, zmin = -inf, xmax = inf, ymax = inf, zmax = inf) {
//    echo($pose=$pose,$posed=$posed);
//    if (!is_undef($pose) && is_undef($posed))
////        clip(xmin=xmin,ymin=ymin,zmin=zmin,xmax=xmax,ymax=ymax,zmax=zmax)
//        difference() {
//            children();
//            translate([-50,-50,-50]) cube([extr_x_len+100,extr_y_len-extr_d*2,extr_z_len+100]);
//            translate([extr_d*3,-50,-50]) cube([extr_x_len+100,extr_y_len+100,extr_z_len+100]);
//            translate([-50,-50,-50]) cube([extr_x_len+100,extr_y_len+100,extr_z_len-extr_d*3]);
//        }
//    else
//        children();
//}
//module assem(x) {echo(x=x);
//}
//module frame3_assembly() clip_pose(xmin=frame_p2.x-extr_d*2,ymin=frame_p2.y-extr_d,zmin=frame_y_z2-extr_d2,xmax=frame_p2.x+extr_d,ymax=frame_p2.y-extr_d*2,zmax=frame_y_z3+extr_d2)/*pose(a=[ 113.80, 0.00, 54.40 ],t=[ 401.51, -317.09, 441.93 ])*/ assembly("frame3") {
//    frame_assembly();
//    explode([extr_d2, -extr_d2, -extr_d2/2], explode_children = true) {
//        idlerl_assembly();
//        xxside1(concat(idlerHolderScrews(0, true), idlerHolderScrews(0, false)));
//    }
//    explode([-extr_d2, -extr_d2, -extr_d2/2], explode_children = true) {
//        idlerr_assembly();
//        xxside1(concat(idlerHolderScrews(1, true), idlerHolderScrews(1, false)));
//    }
//}

main_assembly();



