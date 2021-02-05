include <../cevo2.scad>
include <../defs/base_defs.scad>

use <../../../xNopSCADlib/xVitamins/xextrusion_bracket3.scad>

extr_x = axextrusion(extr_type,extr_x_len,MaterialBlackSteel);
extr_y = axextrusion(extr_type,extr_y_len,MaterialBlackSteel);
extr_z = axextrusion(extr_type,extr_z_len,MaterialBlackSteel);

E30_corner_bracket = [ "E20_corner_bracket", [38, 38, 30], 2, 3, 28]; // TODO
frame_corner_bracket = E30_corner_bracket;

module frame_assembly() assembly("frame") {
    frame_sideL_assembly();
    translate([frame_p4.x,0,0])
        frame_sideR_assembly();

    for (z = [frame_y_z1,frame_y_z2])
        translate([extr_d2,0,z])
            rotate([0,90,0])
                xextrusion_assembly(extr_x);
    translate([extr_d2,frame_p2.y,frame_y_z1])
        rotate([0,90,0])
            xextrusion_assembly(extr_x);
    translate([extr_d2,frame_p2.y,frame_y_z3])
        rotate([0,90,0])
            xextrusion(extr_x);
//    for (p = [frame_p1,frame_p2,frame_p3,frame_p4])
//        translate([p.x,p.y,0])
//            xextrusion(extr_z);
//
//
//    for (z = [frame_y_z1,frame_y_z3])
//        translate([extr_d2,frame_p2.y,z])
//            rotate([0,90,0])
//                xextrusion(extr_x);
//
//    for (x = [frame_p1.x,frame_p3.x])
//        for (z = [frame_y_z1,frame_y_z2,frame_y_z3])
//            translate([x,extr_d2,z])
//                rotate([-90,0,0])
//                    xextrusion(extr_y);
}

module frame_sideL_assembly() assembly("frame_sideL") {
    frame_side_assembly();
}
module frame_sideR_assembly() assembly("frame_sideL") {
    mirror([1,0,0])
        frame_side_assembly();
}

module frame_side_assembly() {
    for (p = [frame_p1,frame_p2])
        translate([p.x,p.y,0])
            explode([0,p.y ? extr_d : -extr_d,0]) xextrusion(extr_z);

    for (x = [frame_p1.x])
        for (z = [frame_y_z1,frame_y_z2,frame_y_z3])
            translate([x,extr_d2,z]) {
                rotate([0, 90, 90])
                    if (z == frame_y_z3) {
                        explode([-extr_d,0,],explode_children=true) xextrusion(extr_y);
                    } else {
                        xextrusion_assembly(extr_y);
                    }
            }
    translate([0,0,extr_z_len]) explode([0,-extr_d,extr_d],explode_children=true)
        xextrusion_bracket3(cut=0);
    translate([0,frame_p2.y,extr_z_len]) explode([0,extr_d,extr_d],explode_children=true)
        rotate([0,0,-90])
            xextrusion_bracket3();
}

frame_assembly();
