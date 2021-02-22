include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/leads_defs.scad>

use <frame1_assembly.scad>
use <../parts/leads_holder.scad>
use <leads2_assembly.scad>


module frame2_assembly() pose(a=[ 45.20, 0.00, 55.10 ],t=[ -0.20, 236.75, 462.01 ],d=390.64,exploded=true) assembly("frame2") {
    frame1_assembly();
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

frame2_assembly();



