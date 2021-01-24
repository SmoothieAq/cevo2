
include <../cevo2.scad>
include <base_defs.scad>

include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

belt = GT2x6;
pulley = GT2x20ob_pulley;
idler = GT2x16_plain_idler;
motor = NEMA17;

loops_side_off = NEMA_width(motor)/2-extr_d2+base_part_thick;
loops_front_off = NEMA_width(motor)/2+extr_d2+motor_nudge;
loops_back_off = pulley_flange_dia(idler)/2+extr_d2+motor_nudge;
loops_xoff0 = 10;
loops_xoff1 = 10;
loops = let (
    lo = 2*pulley_pr(GT2x16_plain_idler)
) [
        [xrail_z+4, [
            [frame_p1.x+loops_side_off, frame_p1.y+loops_front_off, pulley, 1],
            [frame_p2.x+loops_side_off,frame_p2.y-loops_back_off, idler, 1],
            [frame_p3.x-loops_side_off-lo,frame_p3.y-loops_back_off, idler, 1],
            [frame_p4.x-loops_side_off-lo,pos_y-loops_xoff0, idler, 1],
            [frame_p2.x+loops_side_off+lo,pos_y-loops_xoff0-lo, idler, -1]
        ]],
        [xrail_z+4-pulley_height(idler)-0.8, [
            [frame_p4.x-loops_side_off, frame_p4.y+loops_front_off, pulley, 1],
            [frame_p4.x-loops_side_off-lo,pos_y-loops_xoff1-lo, idler, -1],
            [frame_p1.x+loops_side_off+lo,pos_y-loops_xoff1, idler, 1],
            [frame_p2.x+loops_side_off+lo,frame_p2.y-loops_back_off, idler, 1],
            [frame_p3.x-loops_side_off,frame_p3.y-loops_back_off, idler, 1]
        ]]
    ];
