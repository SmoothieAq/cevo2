
include <../cevo2.scad>
include <base_defs.scad>

include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <../../../xNopSCADlib/xVitamins/xrails.scad>
include <../../../xNopSCADlib/xVitamins/xwashers.scad>

//            GT2x6 = ["GT", 2.0,  6, 1.38, 0.75, 0.254];
belt = ["GT_gates", 2.0,  6, 1.55, 0.75, 0.254];// GT2x6; // folded 2.55
pulley = GT2x20ob_pulley;
idler = ["GT2_xx","GT2 (2 x F623ZZ flanged + washer 0.8)",0,10,GT2x6,6.8,11.5,0,3,11.5,1.0,0,0,false,0];//2 x 623zz flanged + washer 0.8
idler_washer = M3_washer_small_thick;
motor = NEMA17;

rail_y = axrail(MGN12,extr_y_len,MaterialBlackSteel,MGN12H_carriage);
rail_x = axrail(MGN12,xrail_len,MaterialBlackSteel,MGN12H_carriage);

idler_tubehd = max(pulley_flange_dia(idler), pulley_od(idler) + belt_thickness(belt) * 2) + 3;
idler_tubed = idler_tubehd + 6;
idler_tubebth = belt_thickness(belt) + 2;
idler_tubebwh = pulley_height(idler) + 2*washer_thickness(idler_washer);

loops_side_off = NEMA_width(motor)/2-extr_d2+base_part_thick/2;
loops_front_off = NEMA_width(motor)/2+extr_d2+motor_nudge;
loops_back_off = idler_tubehd/2 + extr_d2;//pulley_flange_dia(idler)/2+extr_d2+motor_nudge;
loops_xoff0 = 11.7;//11;
loops_xoff1 = 11.7;//11;

carriage_loopr = 1.5;
carriage_loopd = carriage_length(xrail_carriage(rail_x))/2 + 0.4;
carriage_loopdx = carriage_loopd + 7;
carriage_loopdxx = carriage_loopdx + 9;

loops = let (
    lox = belt_pulley_pr(belt, pulley) + belt_pulley_pr(belt, idler),
    loy = belt_pulley_pr(belt, idler),
    loyx = belt_pitch_height(belt) * 2 - belt_tooth_height(belt),
    hr = 2
) [
        [xrail_z+7, [
            [pos_x-carriage_loopdxx,pos_y-loops_xoff0-loy+loyx, 0],
            [pos_x-carriage_loopdx,pos_y-loops_xoff0-loy+loyx+hr, -hr],
            [pos_x-carriage_loopd,pos_y-loops_xoff0-loy, carriage_loopr + belt_pitch_height(belt)],
            [pos_x-carriage_loopdx,pos_y-loops_xoff0-loy-hr, -hr],
            [frame_p2.x+loops_side_off+lox,pos_y-loops_xoff0-2*belt_pulley_pr(belt, idler), idler],
            [frame_p1.x+loops_side_off, frame_p1.y+loops_front_off, pulley],
            [frame_p2.x+loops_side_off,frame_p2.y-loops_back_off, idler],
            [frame_p3.x-loops_side_off-lox,frame_p3.y-loops_back_off, idler],
            [frame_p4.x-loops_side_off-lox,pos_y-loops_xoff0, idler],
            [pos_x+carriage_loopdx,pos_y-loops_xoff0-loy+hr, hr],
            [pos_x+carriage_loopd,pos_y-loops_xoff0-loy, -carriage_loopr - belt_pitch_height(belt)],
            [pos_x+carriage_loopdx,pos_y-loops_xoff0-loy-loyx-hr, hr],
            [pos_x+carriage_loopdxx,pos_y-loops_xoff0-loy-loyx, 0],
        ], false],
        [xrail_z+7-pulley_height(idler)-0.8, [
            [pos_x+carriage_loopdxx,pos_y-loops_xoff0-loy+loyx, 0],
            [pos_x+carriage_loopdx,pos_y-loops_xoff0-loy+loyx+hr, hr],
            [pos_x+carriage_loopd,pos_y-loops_xoff0-loy, -carriage_loopr - belt_pitch_height(belt)],
            [pos_x+carriage_loopdx,pos_y-loops_xoff0-loy-hr, hr],
            [frame_p3.x-loops_side_off-lox,pos_y-loops_xoff0-2*belt_pulley_pr(belt, idler), idler],
            [frame_p4.x-loops_side_off, frame_p4.y+loops_front_off, pulley],
            [frame_p3.x-loops_side_off,frame_p3.y-loops_back_off, idler],
            [frame_p2.x+loops_side_off+lox,frame_p2.y-loops_back_off, idler],
            [frame_p1.x+loops_side_off+lox,pos_y-loops_xoff0, idler],
            [pos_x-carriage_loopdx,pos_y-loops_xoff0-loy+hr, -hr],
            [pos_x-carriage_loopd,pos_y-loops_xoff0-loy, carriage_loopr + belt_pitch_height(belt)],
            [pos_x-carriage_loopdx,pos_y-loops_xoff0-loy-loyx-hr, -hr],
            [pos_x-carriage_loopdxx,pos_y-loops_xoff0-loy-loyx, 0],
        ], true]
    ];
//loops = let (
//    lo = pulley_ir(idler)*2 + belt_thickness(belt) // 2*pulley_pr(idler)
//) [
//        [xrail_z+7/*3*/, [
//            [frame_p1.x+loops_side_off, frame_p1.y+loops_front_off, pulley, 1],
//            [frame_p2.x+loops_side_off,frame_p2.y-loops_back_off, idler, 1],
//            [frame_p3.x-loops_side_off-lo,frame_p3.y-loops_back_off, idler, 1],
//            [frame_p4.x-loops_side_off-lo,pos_y-loops_xoff0, idler, 1],
//            [frame_p2.x+loops_side_off+lo,pos_y-loops_xoff0-lo, idler, -1]
//        ]],
//        [xrail_z+7/*3*/-pulley_height(idler)-0.8, [
//            [frame_p4.x-loops_side_off, frame_p4.y+loops_front_off, pulley, 1],
//            [frame_p4.x-loops_side_off-lo,pos_y-loops_xoff1-lo, idler, -1],
//            [frame_p1.x+loops_side_off+lo,pos_y-loops_xoff1, idler, 1],
//            [frame_p2.x+loops_side_off+lo,frame_p2.y-loops_back_off, idler, 1],
//            [frame_p3.x-loops_side_off,frame_p3.y-loops_back_off, idler, 1]
//        ]]
//    ];
function loopshp(i) = let ( p = loops[0][1][i] ) [p.x,p.y,loops[0][0]];
function loopslp(i) = let ( p = loops[1][1][i] ) [p.x,p.y,loops[1][0]];



xyholder_thick1 = base_part_thickx;
xyholder_thick2 = base_part_thick2x;
