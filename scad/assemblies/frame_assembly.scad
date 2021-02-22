include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <../../../xNopSCADlib/xVitamins/xextrusion_bracket3.scad>
include <../../../xNopSCADlib/xVitamins/xextrusions.scad>
include <../../../xNopSCADlib/xVitamins/xnuts.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
use <../parts/idler_holder.scad>
use <../parts/loops_motor_holder.scad>
use <../parts/leads_motor_holder.scad>

extr_x = axextrusion(extr_type,extr_x_len,MaterialBlackSteel);
extr_y = axextrusion(extr_type,extr_y_len,MaterialBlackSteel);
extr_z = axextrusion(extr_type,extr_z_len,MaterialBlackSteel);

E30_corner_bracket = [ "E20_corner_bracket", [38, 38, 30], 2, 3, 28]; // TODO
frame_corner_bracket = E30_corner_bracket;

module frame_assembly() assembly("frame") {
    explode([-extr_d,0,0])
    frame_sideL_assembly();
    explode([extr_d,0,0])
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
    for_leads(1,frame_y_z1+extr_d2)
        xxside2(leads_motor_mount_screws());
}

module frame_sideL_assembly() assembly("frame_sideL") {
    frame_side_assembly(0);
}
module frame_sideR_assembly() assembly("frame_sideR") {
    frame_side_assembly(1);
}

corners = [[frame_p1,frame_p2],[frame_p4,frame_p3]];

module frame_side_assembly(i) {
    for (p = corners[i])
        explode([0,p.y ? extr_d : -extr_d,0],explode_children=true) {
            translate([p.x, p.y, 0])
                xextrusion(extr_z);
            if (p.y)
                xxside2(idlerHolderScrews(i,true));
            else
                xxside2(loops_motor_mount_screws(i));
        }

    x = corners[i][0].x;
    for (z = [frame_y_z1,frame_y_z2,frame_y_z3])
        translate([x,extr_d2,z]) {
            rotate([0, 90, 90])
                if (z == frame_y_z3) {
                    explode([-extr_d,0,0],explode_children=true) {
                        xextrusion(extr_y);
                        rotate([0,-90,i?90:-90])
                            for (p = rail_hole_nps(rail_y))
                                translate([p,0,-extr_d2])
                                    xnut(xextrusion_nut(extr_y,screwd=screw_radius(rail_screw(rail_y))*2));
                    }
                } else {
                    xextrusion_assembly(extr_y);
                }
        }
    explode([0,0,extr_d],explode_children=true)
        xxside2(idlerHolderScrews(i,false));
    for_leads(i?2:0,frame_y_z1+extr_d2)
        xxside2(leads_motor_mount_screws());
    translate([x, corners[i][0].y, extr_z_len]) explode([0, -extr_d, extr_d], explode_children = true)
    mirror([i,0,0])xextrusion_bracket3(cut = 0);
    translate([x, corners[i][1].y, extr_z_len]) explode([0, extr_d, extr_d], explode_children = true)
    mirror([i,0,0])rotate([0, 0, -90])
            xextrusion_bracket3();
}

frame_assembly();
