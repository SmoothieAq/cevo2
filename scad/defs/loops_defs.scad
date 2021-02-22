
include <../cevo2.scad>
include <base_defs.scad>

include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <../../../xNopSCADlib/xVitamins/xrails.scad>
include <../../../xNopSCADlib/xVitamins/xwashers.scad>

belt = GT2x6;
pulley = GT2x20ob_pulley;
idler = ["GT2_xx","GT2",0,10,GT2x6,6.7,11.5,0,3,11.5,1.0,0,0,false,0];//2 x 623zz flanged + washer 0.7
idler_washer = M3_washer_small_thick;
motor = NEMA17;

rail_y = axrail(MGN12,extr_y_len,MaterialBlackSteel,MGN12H_carriage);
rail_x = axrail(MGN12,xrail_len,MaterialBlackSteel,MGN12H_carriage);

loops_side_off = NEMA_width(motor)/2-extr_d2+base_part_thick/2;
loops_front_off = NEMA_width(motor)/2+extr_d2+motor_nudge;
loops_back_off = pulley_flange_dia(idler)/2+extr_d2+motor_nudge;
loops_xoff0 = 10;
loops_xoff1 = 10;
loops = let (
    lo = pulley_ir(idler)*2 + belt_thickness(belt) // 2*pulley_pr(idler)
) [
        [xrail_z+7/*3*/, [
            [frame_p1.x+loops_side_off, frame_p1.y+loops_front_off, pulley, 1],
            [frame_p2.x+loops_side_off,frame_p2.y-loops_back_off, idler, 1],
            [frame_p3.x-loops_side_off-lo,frame_p3.y-loops_back_off, idler, 1],
            [frame_p4.x-loops_side_off-lo,pos_y-loops_xoff0, idler, 1],
            [frame_p2.x+loops_side_off+lo,pos_y-loops_xoff0-lo, idler, -1]
        ]],
        [xrail_z+7/*3*/-pulley_height(idler)-0.8, [
            [frame_p4.x-loops_side_off, frame_p4.y+loops_front_off, pulley, 1],
            [frame_p4.x-loops_side_off-lo,pos_y-loops_xoff1-lo, idler, -1],
            [frame_p1.x+loops_side_off+lo,pos_y-loops_xoff1, idler, 1],
            [frame_p2.x+loops_side_off+lo,frame_p2.y-loops_back_off, idler, 1],
            [frame_p3.x-loops_side_off,frame_p3.y-loops_back_off, idler, 1]
        ]]
    ];
function loopshp(i) = let ( p = loops[0][1][i] ) [p.x,p.y,loops[0][0]];
function loopslp(i) = let ( p = loops[1][1][i] ) [p.x,p.y,loops[1][0]];

xyholder_thick1 = base_part_thickx;
xyholder_thick2 = base_part_thick2x;
