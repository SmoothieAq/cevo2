
include <../cevo2.scad>
include <base_defs.scad>

include <NopSCADlib/vitamins/stepper_motors.scad>
include <../../../xNopSCADlib/xVitamins/xleadnuts.scad>
include <../../../xNopSCADlib/xVitamins/xshafts.scad>
include <../../../xNopSCADlib/xVitamins/xwashers.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>
include <NopSCADlib/vitamins/tubings.scad>

leads_motor = ["NEMA17l",42.3,47,53.6/2,25,11,2,8,[350,4,2],31,[11.5,9]];;
leadnut     = axleadnut(["LSN8x2","Leadscrew nut 8 x 2",8,10.2,26.9,22,4.0,0,4,3.5,8,M3_cap_screw,4,2],undef,"dimgrey",[14,4]);
lead_bearing= BB608;
holder_tube = CARBONFIBER10;
holder_pin  = axSteelRod(2, 10);
holder_washer = M2_washer;
holder_ball = 5;

holder_thick1 = base_part_thickx;
holder_thick2 = base_part_thick2;
holder_offz = 15;


//---

leads_side_off = NEMA_width(leads_motor)/2+extr_d2+motor_nudge;
csp = 79;
f_x = min(bed.x+bed_x_off-bed_fast_off,frame_p4.x-extr_d2-csp);
b_y = min(bed_y_off+bed.y-bed_fast_off,frame_p3.y-extr_d2-csp);
l_y = let(
    d = bed_fast_off,
    w = bed.x,
    s1 = bed_y_off + bed.y - b_y,
    s2 = bed_x_off + bed.x - f_x,
    t = (2*d^2 + s1^2 - 2*d*s2 - (s2 - w)^2)/(2 *(d + s1 - w))
) bed_y_off + bed.y - t;
leads = [
        ["L",[leads_side_off,l_y],                     [bed_x_off+bed_fast_off,l_y]],
        ["F",[f_x,leads_side_off],                     [f_x,bed_y_off+bed_fast_off]],
        ["B",[extr_x_len+extr_d-leads_side_off,b_y],   [bed_x_off+bed.x-bed_fast_off,b_y]]
    ];
//leads = [
//["L",[leads_side_off,extr_y_len/2+extr_d2],                             [bed_x_off+bed_fast_off,extr_y_len/2+extr_d2]],
//["F",[bed.x+bed_x_off-bed_fast_off,leads_side_off],                     [bed_x_off+bed.x-bed_fast_off,bed_y_off+bed_fast_off]],
//["B",[extr_x_len+extr_d-leads_side_off,bed_y_off+bed.y-bed_fast_off],   [bed_x_off+bed.x-bed_fast_off,bed_y_off+bed.y-bed_fast_off]]
//];

function holder_name(i)     = leads[i][0];
function holder_leadp(i)    = leads[i][1];
function holder_bedp(i)     = leads[i][2];

module for_leads(i,z) {
    lp = leads[i][1];
    translate([lp.x,lp.y,z])
        rotate([0,0,i*90])
            children();
}
