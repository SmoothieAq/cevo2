
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
leads = [
        ["L",[leads_side_off,extr_y_len/2+extr_d2],                             [bed_x_off+bed_fast_off,extr_y_len/2+extr_d2]],
        ["F",[bed.x+bed_x_off-bed_fast_off,leads_side_off],                     [bed_x_off+bed.x-bed_fast_off,bed_y_off+bed_fast_off]],
        ["B",[extr_x_len+extr_d-leads_side_off,bed_y_off+bed.y-bed_fast_off],   [bed_x_off+bed.x-bed_fast_off,bed_y_off+bed.y-bed_fast_off]]
    ];

function holder_name(i)     = leads[i][0];
function holder_leadp(i)    = leads[i][1];
function holder_bedp(i)     = leads[i][2];
