include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <NopSCADlib/vitamins/tubings.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
use <dotSCAD/ptf/ptf_rotate.scad>
use <dotSCAD/util/flat.scad>

mp = NEMA_hole_pitch(leads_motor);
mw = NEMA_width(leads_motor);
ml = NEMA_length(leads_motor);

lbz = NEMA_shaft_length(leads_motor)[0]-frame_y_z2+frame_y_z1;

motor_screws = [ for (i = [-1,1], j= [-1,1])
	axxscrew(screwPart,thick=base_part_thickx+1,l=base_part_thickx+5,t=[i*mp/2,j*mp/2,base_part_thickx+1],xnut=false)
];

function motor_screws() = motor_screws;

motor_mount_screws = [ for (i = [-1:1]) let(
	t = [i?-mw/2+base_part_thickx:-mw/2-motor_nudge-extr_d2,i*(-mw/2-10),i?-extr_d2:base_part_thickx],
	r = i?[90,0,90]:[0,0,0],
	thick = i?base_part_thickx*2:base_part_thickx,
	horizontal = i != 0
) axxscrew_setLengAdjustDepth(screwFrameMount,thick=thick,t=t,r=r,spacing=20,horizontal=horizontal,twist=i*90+90) ];

function leads_motor_mount_screws() = motor_mount_screws;

module leads_motor_holderL_stl() stl("leads_motor_holderL") leads_motor_holder(true);
module leads_motor_holderB_stl() stl("leads_motor_holderB") leads_motor_holder(false);
module leads_motor_holderF_stl() stl("leads_motor_holderF") leads_motor_holder(false);
module leads_motor_holder(isleft=false,support=true) color(partColor) {
	difference() {
		union() {
			for (r=[1,-1]) {
				translate([-mw/2, r*(-mw/2-10), -extr_d*0.65+5])
					rotate([0,0,r*20])rotate([0, 72, 0])
						translate([0, 0, -holder_thick2]) {
							cylinder(holder_thick2*3.6, d1 = holder_thick2+5, d2 = holder_thick2-3);
							if (support) {
								translate([0, r*1, 0])
									cube([30, 0.4, holder_thick2*2.5]);
								translate([0, r*4, 0])
									cube([30, 0.4, holder_thick2*3.6]);
								translate([0, r*-2, 0])
									cube([30, 0.4, holder_thick2*3.6]);
								translate([0, r*7, 0])
									cube([30, 0.4, holder_thick2*3.6]);
								translate([0, r*-5, 0])
									cube([30, 0.4, holder_thick2*3.6]);
								rotate([0, 18, 0])translate([-20, r*5-10, 52])
									cube([30, 20, 0.4]);
								rotate([0, 18, 0])translate([-20, r*5-10, 62])
									cube([30, 20, 0.4]);
							}
						}
				translate([-mw/2-extr_d-4, r*5, -2])
					rotate([0, 88.5, r*7])
						cylinder(holder_thick2*4, d1 = holder_thick2+6, d2 = holder_thick2-2);
			}
			translate([mw/4,-mw/4,0])
				cube([mw/4,mw/2,2*NEMA_boss_height(leads_motor)]);
			xxside1_plate(motor_screws);
		}
		xxside1_hole(motor_screws);
		xxside1_hole(motor_mount_screws);

		translate([0,0,-ml])
			intersection() {
				cylinder(ml, r = NEMA_radius(leads_motor)+part_assemble_nudge);
				translate([-mw/2,-mw/2,0])
					cube([mw, mw, ml]);
			}
		translate([-mw+10,-mw/2,-ml])
			cube([mw, mw, ml]);
		translate([0,0,-mw/2])
			cylinder(mw,r=NEMA_boss_radius(leads_motor)+part_assemble_nudge);
		translate([-extr_d*2-mw/2-motor_nudge,-extr_d*3,-extr_d*2])
			cube([extr_d*2,extr_d*6,extr_d*2]);
		translate([-extr_d*3-mw/2+1,-extr_d*3,-extr_d*1])
			cube([extr_d*2,extr_d*6,extr_d*2]);
		translate([mw/2-0.1,-mw,-ml])
			cube([mw,mw*2,ml*2]);
		translate([-extr_d*2,-extr_d*2,-extr_d*1.75])
			cube([extr_d*4,extr_d*4,extr_d]);
		if (!isleft)
			translate([-mw/2-motor_nudge-1,-mw/2-10-extr_d*1.25,-extr_d])
				cube([extr_d*2,extr_d,extr_d]);
	}
}


leads_motor_holderB_stl();
