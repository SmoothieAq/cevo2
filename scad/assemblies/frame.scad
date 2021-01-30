include <../cevo2.scad>
include <../defs/base_defs.scad>


module frame_assembly() assembly("frame") {

    extr_x = axextrusion(extr_type,extr_x_len,MaterialBlackSteel);
    extr_y = axextrusion(extr_type,extr_y_len,MaterialBlackSteel);
    extr_z = axextrusion(extr_type,extr_z_len,MaterialBlackSteel);

    for (p = [frame_p1,frame_p2,frame_p3,frame_p4])
        translate([p.x,p.y,0])
            xextrusion(extr_z);

    for (z = [frame_y_z1,frame_y_z2])
        translate([extr_d2,0,z])
            rotate([0,90,0])
                xextrusion(extr_x);

    for (z = [frame_y_z1,frame_y_z3])
        translate([extr_d2,frame_p2.y,z])
            rotate([0,90,0])
                xextrusion(extr_x);

    for (x = [frame_p1.x,frame_p3.x])
        for (z = [frame_y_z1,frame_y_z2,frame_y_z3])
            translate([x,extr_d2,z])
                rotate([-90,0,0])
                    xextrusion(extr_y);
}

frame_assembly();
