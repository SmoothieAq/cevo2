include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/leads_defs.scad>

use <frame2_assembly.scad>
use <leads_holder.scad>


module frame3_assembly() pose(a=[ 48.70, 0.00, 56.50 ],t=[ 17.32, 255.04, 481.30 ],d=316.42) assembly("frame3") {
    frame2_assembly();
    explode([0, 0, extr_d2], explode_children = true) {
        for (i = [0:2])
            for_leads(i,frame_y_z2+extr_d2) {
                leads_holder_stl();
                xxside1(lead_bearing_holder_screws());
                translate([0, 0, NEMA_shaft_length(leads_motor)[0]-frame_y_z2+frame_y_z1-bb_width(lead_bearing)/2])
                    explode(10) ball_bearing(lead_bearing);
            }
    }
}

frame3_assembly();



