
include <../cevo2.scad>
include <base_defs.scad>

include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <../../../xNopSCADlib/xVitamins/xrails.scad>
include <../../../xNopSCADlib/xVitamins/xwashers.scad>

belt = ["GT_gates", 2.0,  6, 1.55, 0.75, 0.254];// GT2x6; // folded 2.55
pulley = GT2x20ob_pulley;
idler = ["GT2_xx","GT2",0,10,GT2x6,6.7,11.5,0,3,11.5,1.0,0,0,false,0];//2 x 623zz flanged + washer 0.7
idler_washer = M3_washer_small_thick;
motor = NEMA17;

rail_y = axrail(MGN12,extr_y_len,MaterialBlackSteel,MGN12H_carriage);
rail_x = axrail(MGN12,xrail_len,MaterialBlackSteel,MGN12H_carriage);

loops_side_off = NEMA_width(motor)/2-extr_d2+base_part_thick/2;
loops_front_off = NEMA_width(motor)/2+extr_d2+motor_nudge;
loops_back_off = pulley_flange_dia(idler)/2+extr_d2+motor_nudge;
loops_xoff0 = 11;
loops_xoff1 = 11;
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


carriage_loopd = 15;
carriage_loopdx = 22;
carriage_loopdxx = 29;
carriage_loopr = 2;

pullies = let (
        lox = pulley_pr(pulley) + belt_thickness(belt) - belt_tooth_height(belt) + pulley_ir(idler),
        loy = belt_thickness(belt) + pulley_ir(idler) * 2 - pulley_ir(idler),
        loyx = belt_pitch_height(belt) * 2 - belt_tooth_height(belt)
    ) [
        [xrail_z+7, [
            [pos_x-carriage_loopdxx,pos_y-loops_xoff0-loy+loyx, 0],
            [pos_x-carriage_loopdx,pos_y-loops_xoff0-loy+loyx+1, -1],
            [pos_x-carriage_loopd,pos_y-loops_xoff0-loy, carriage_loopr + belt_pitch_height(belt)],
            [pos_x-carriage_loopdx,pos_y-loops_xoff0-loy-1, -1],
            [frame_p2.x+loops_side_off+lox,pos_y-loops_xoff0-loy-pulley_ir(idler), idler],
            [frame_p1.x+loops_side_off, frame_p1.y+loops_front_off, pulley],
            [frame_p2.x+loops_side_off,frame_p2.y-loops_back_off, idler],
            [frame_p3.x-loops_side_off-lox,frame_p3.y-loops_back_off, idler],
            [frame_p4.x-loops_side_off-lox,pos_y-loops_xoff0, idler],
            [pos_x+carriage_loopdx,pos_y-loops_xoff0-loy+1, 1],
            [pos_x+carriage_loopd,pos_y-loops_xoff0-loy, -carriage_loopr - belt_pitch_height(belt)],
            [pos_x+carriage_loopdx,pos_y-loops_xoff0-loy-loyx-1, 1],
            [pos_x+carriage_loopdxx,pos_y-loops_xoff0-loy-loyx, 0],
        ], false],
        [xrail_z+7-pulley_height(idler)-0.8, [
            [pos_x+carriage_loopdxx,pos_y-loops_xoff0-loy+loyx, 0],
            [pos_x+carriage_loopdx,pos_y-loops_xoff0-loy+loyx+1, 1],
            [pos_x+carriage_loopd,pos_y-loops_xoff0-loy, -carriage_loopr - belt_pitch_height(belt)],
            [pos_x+carriage_loopdx,pos_y-loops_xoff0-loy-1, 1],
            [frame_p3.x-loops_side_off-lox,pos_y-loops_xoff0-loy-pulley_ir(idler), idler],
            [frame_p4.x-loops_side_off, frame_p1.y+loops_front_off, pulley],
            [frame_p3.x-loops_side_off,frame_p2.y-loops_back_off, idler],
            [frame_p1.x+loops_side_off+lox,frame_p3.y-loops_back_off, idler],
            [frame_p1.x+loops_side_off+lox,pos_y-loops_xoff0, idler],
            [pos_x-carriage_loopdx,pos_y-loops_xoff0-loy+1, -1],
            [pos_x-carriage_loopd,pos_y-loops_xoff0-loy, carriage_loopr + belt_pitch_height(belt)],
            [pos_x-carriage_loopdx,pos_y-loops_xoff0-loy-loyx-1, -1],
            [pos_x-carriage_loopdxx,pos_y-loops_xoff0-loy-loyx, 0],
        ], true]
    ];

xyholder_thick1 = base_part_thickx;
xyholder_thick2 = base_part_thick2x;
