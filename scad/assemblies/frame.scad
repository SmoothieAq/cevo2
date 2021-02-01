include <../cevo2.scad>
include <../defs/base_defs.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>

extr_x = axextrusion(extr_type,extr_x_len,MaterialBlackSteel);
extr_y = axextrusion(extr_type,extr_y_len,MaterialBlackSteel);
extr_z = axextrusion(extr_type,extr_z_len,MaterialBlackSteel);

E30_corner_bracket = [ "E20_corner_bracket", [38, 38, 30], 2, 3, 28]; // TODO
frame_corner_bracket = E30_corner_bracket;

module frame_assembly() assembly("frame") {


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

module frame_side_assembly() assembly("frame_side") {
    for (p = [frame_p1,frame_p2])
        translate([p.x,p.y,0])
            explode([0,p.y ? extr_d : -extr_d,0]) xextrusion(extr_z);

    for (x = [frame_p1.x])
        for (z = [frame_y_z1,frame_y_z2,frame_y_z3])
            translate([x,extr_d2,z]) {
                rotate([- 90, 0, 0]) {
                    xextrusion(extr_y);
                    translate([0,extr_d2,0])
                        rotate([0,-90,0])
                            explode([0,extr_d2,0],explode_children = true) extrusion_corner_bracket_assembly(frame_corner_bracket);
                    translate([0,extr_d2,xextrusion_length(extr_y)])
                        rotate([0,90,0])
                            explode([0,extr_d2,0],explode_children = true) extrusion_corner_bracket_assembly(frame_corner_bracket);
                }
            }
}

frame_side_assembly();
