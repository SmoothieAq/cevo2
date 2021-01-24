include <../../../xNopSCADlib/xVitamins/xextrusions.scad>

posx = 0.4;
posy = 0.5;

extr_x_len = 420;
extr_y_len = 410;
extr_z_len = 600;
extr_type = E3030;

extr_d = extrusion_width(extr_type);
extr_d2 = extr_d/2;

// printable area
area_x_offl = 65;
area_x_offr = 65;
area_x = extr_x_len+extr_d-area_x_offl-area_x_offr;
area_y_offf = 70;
area_y_offb = 40;
area_y = extr_y_len+extr_d-area_y_offf-area_y_offb;

pos_x = area_x_offl+posx*area_x;
pos_y = area_y_offf+posy*area_y;

frame_y_z1 = 164-extr_d2;
frame_y_z3 = extr_z_len-extr_d2;
frame_y_z2 = frame_y_z3-112;
echo(d=350-(frame_y_z2-frame_y_z1));

xrail_xoff = -12;
xrail_zoff = 28;
xrail_z = frame_y_z3-xrail_zoff;
xrail_len = extr_x_len+2*xrail_xoff;

pos_z = xrail_z-29;

frame_p1 = [0,0];
frame_p2 = [0,extr_y_len+extr_d];
frame_p3 = [extr_x_len+extr_d,extr_y_len+extr_d];
frame_p4 = [extr_x_len+extr_d,0];

bed = [320,320,6];
bed_fast_off = 8;
bed_y_off = 60;
bed_x_off = (frame_p4.x-bed.x)/2;

base_part_thick = 5;
motor_nudge = 0.5;
