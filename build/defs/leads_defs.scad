
include <../cevo2.scad>
include <base_defs.scad>

include <NopSCADlib/vitamins/stepper_motors.scad>
include <../../../xNopSCADlib/xVitamins/xleadnuts.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>

leads_motor = ["NEMA17l",42.3,47,53.6/2,25,11,2,8,[350,4,2],31,[11.5,9]];;
leadnut     = axleadnut(["LSN8x2","Leadscrew nut 8 x 2",8,10.2,26.9,22,4.0,0,4,3.5,8,M3_cap_screw,4,2],undef,"dimgrey",[14,4]);
lead_bearing= BB608;

leads_side_off = NEMA_width(leads_motor)/2+extr_d2+motor_nudge;
leads = [
        [[leads_side_off,extr_y_len/2+extr_d2],[bed_x_off+bed_fast_off,extr_y_len/2+extr_d2]],
        [[bed.x+bed_x_off-bed_fast_off,leads_side_off],[bed_x_off+bed.x-bed_fast_off,bed_y_off+bed_fast_off]],
        [[extr_x_len+extr_d-leads_side_off,bed_y_off+bed.y-bed_fast_off],[bed_x_off+bed.x-bed_fast_off,bed_y_off+bed.y-bed_fast_off]]
    ];

holder_thick1 = 7;
holder_thick2 = 20;
holder_offz = 15;
