include <../defs/loops_defs.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>

mp = NEMA_hole_pitch(motor);
mw = NEMA_width(motor);
ml = NEMA_length(motor);

tzd = 11;
mzd = 16;

motor_screws = [ for (i = [-1,1], j= [-1,1]) let (
	thick = base_part_thickx + (j > 0?0:3)
) axxscrew(screwPart,thick=thick,l=thick+4,t=[i*mp/2,j*mp/2,thick],xnut=false) ];

motor_mount_screws = [ for (i = [0,1]) let(
	t = i?[-loops_side_off+extr_d2+base_part_thickx,-mw/2-motor_nudge-extr_d2,base_part_thick2/2+tzd-3]:[-loops_side_off,-mw/2-motor_nudge+base_part_thickx,mzd+2],
	r = [90,0,i?90:180]
) axxscrew_setLengAdjustDepth(screwFrameMount,thick=base_part_thickx,t=t,r=r,xnut=xextrusion_nut(extr_type),horizontal=true) ];

function loops_motor_mount_screws(i) = [ for (s = motor_mount_screws) let (
	loop = loops[i],
	p =  loop[1][0],
	z = loop[0] - pulley_height(p.z) - motor_nudge
) axxscrew(s,t=xxscrew_translate(s)+[p.x,p.y,z],twist=90) ];

module loops_motor_holder_assembly() pose(a=[ 48.70, 0.00, 108.30 ],t=[ 72.78, 52.48, 609.26 ],d=197.34) assembly("loops_motor_holder") {
	loops_motor_holderi_assembly(0);
	loops_motor_holderi_assembly(1);
}

module loops_motor_holderi_assembly(i) {
	loop = loops[i];
	z = loop[0];
	p1 = loop[1][0];
	translate([p1.x, p1.y, z - pulley_height(p1.z) - motor_nudge]) {
		NEMA(motor);
		translate([0,0,pulley_height(p1.z) + motor_nudge])
			explode([0,0,pulley_height(p1.z)*2],explode_children=true)
				pulley_assembly(pulley);
		if (i == 0) {
			loops_motor_holderL_stl();
			xxside1(motor_screws);
		} else {
			loops_motor_holderR_stl();
			xxside1(motor_screws);
		}
	}
}

module loops_motor_holderL_stl() {stl("loops_motor_holderL"); loops_motor_holder(); }
module loops_motor_holderR_stl() {stl("loops_motor_holderR"); mirror([1,0,0]) loops_motor_holder(); }
module loops_motor_holder() color(partColor) {
	difference() {
		union() {
			translate([3,-mw/2-extr_d-2,base_part_thick2/2+tzd])
				rotate([-107,0,-11])
					cylinder(base_part_thick2*4, d1 = base_part_thick2+5, d2 = base_part_thick2-3);
			translate([-4,-mw/2-extr_d-2,base_part_thick2/2+tzd])
				rotate([-107,0,10])
					cylinder(base_part_thick2*4, d1 = base_part_thick2+5, d2 = base_part_thick2-3);
			translate([-loops_side_off,-mw/2-motor_nudge,mzd])
				rotate([-90,0,0])
					cylinder(base_part_thickx,d=base_part_thick2-5);
			translate([-base_part_thick2/2,-mw/2-motor_nudge,0])
					cube([base_part_thick2,base_part_thickx*2,base_part_thick2/2]);
			translate([-mw/4-3,mw/4-8,0])
				cube([mw/2+6,mw/4+8,2*NEMA_boss_height(motor)]);
			xxside1_plate(motor_screws);
		}
		xxside1_hole(motor_screws);
		xxside1_hole(motor_mount_screws);
		translate([0,0,-ml+30])
			difference() {
				translate([-mw/2,0,1])
					cube([mw, mw, ml]);
				cylinder(ml+2, r = NEMA_radius(motor)+part_assemble_nudge);
			}
		translate([-mw/2-1,-mw/2-motor_nudge,-ml])
			cube([mw+2, mw+2, ml]);
		translate([0,0,-mw/2])
			cylinder(mw,r=NEMA_boss_radius(motor)+part_assemble_nudge);
		translate([-extr_d*2-mw/2+0.1,-extr_d*3,-extr_d])
			cube([extr_d*2,extr_d*6,extr_d*2]);
		translate([-extr_d,mw/2-0.1,-extr_d*1])
			cube([extr_d*2,extr_d*2,extr_d*2]);
		translate([mw/2-0.1,-mw,-ml])
			cube([mw,mw*2,ml*2]);
		translate([-loops_side_off-extr_d2,-mw/2-motor_nudge-extr_d,-extr_d])
			cube([extr_d,extr_d+0.1,extr_d*4]);
		translate([-loops_side_off-extr_d,-mw/2-motor_nudge-extr_d*2+1.5,-extr_d])
			cube([extr_d*2,extr_d,extr_d*4]);
	}
}

loops_motor_holder_assembly();