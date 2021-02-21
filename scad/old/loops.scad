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

//ph = pulley_height(idler);
//pod = pulley_od(idler);
//iwt = washer_thickness(idler_washer);
//bt = belt_thickness(belt);
//bw = belt_width(belt);
//bth = bt + 1;
//bwh = ph + 2*iwt; //bw + 3;
//
//zidlerholder = loops[1][0]-ph/2-iwt-base_part_thick;
//hidlerholder = frame_y_z3-extr_d2-zidlerholder;
//hxidlerholder = loops[0][0]+ph/2+iwt+base_part_thick-zidlerholder;
//
//idlerps = [[loopshp(1),loopslp(3)],[loopshp(2),loopslp(4)]];
//
//idler_holderpd = base_part_thick2-7;
//idler_holderps = [ for (i = [0:1]) let (
//	fx = i?frame_p3.x:frame_p2.x,
//	fy = frame_p2.y,
//	fxn = i?-extr_d2-base_part_thick:extr_d2,
//	in = -(i-1)
//) [
//		[[fx,fy-extr_d2-18,frame_y_z3-extr_d2],[180,0,90],[0,i,0],[0,0,-base_part_thick+in*max(0,hxidlerholder-hidlerholder)],[0,0,0]],
//		[[fx,fy-extr_d2,zidlerholder-idler_holderpd/2],[90,180,0],[1,1,0],[0,1*-base_part_thick,0],[0,0,0]],
//		[[fx+fxn+i*base_part_thick,fy,frame_y_z3-extr_d2-idler_holderpd/2],[90,180,(i?-1:1)*90],[i,0,0],[(i?-1:1)*base_part_thick,0,0],[0,0,0]],
//		[[fx+fxn+i*base_part_thick,fy,zidlerholder],[90,180,(i?-1:1)*90],[i,in,0],[(i?-1:1)*base_part_thick,0,0],[0,i,0]]
//	]];
//
//idlerScrews = [ for (i = [0:1])
//	let(
//		screw = axxscrew_setLengAdjustDepth(screwPart,thick=hidlerholder,nut_depth=1.05,nut_plate=0,plate=0,flip=false),
//		pss = [ for (p = idlerps[i]) [p.x,p.y,zidlerholder] ]
//	) [ for (p = pss) axxscrew(screw,t=p,r=[180,0,0]) ]
//];
//
//idlerHolderScrews = [ for (i = [0:1])
//	[ for (p = idler_holderps[i]) axxscrew_setLeng(screwFrameMount,thick=base_part_thick,t=p.x+p[3],r=p.y,horizontal=p.y.x%180!=0,twist=p.y.x%180!=0?90:0,flip=false,plate=0,spacing=0) ]
//];
//
//function idlerHolderScrews(i,onz) = let (ss = idlerHolderScrews[i]) onz ? [ss[1],ss[2],ss[3]] : [ss[0]];

module loops_assembly() assembly("loops") {

	for (loop = loops) {
		translate([0, 0, loop.x]) {
			for (p = loop.y)
			translate([p.x, p.y, 0])
				pulley_assembly(p.z);
			belt(GT2x6, [for (p = loop.y) [p.x, p.y, p[3] * pulley_pr(p[2])]]);
		}
	}
//	idler_holderL1_stl();
//	xxside1(concat(idlerScrews[0], idlerHolderScrews[0]));
//	idler_holderR1_stl();
//	xxside1(concat(idlerScrews[1], idlerHolderScrews[1]));

	for (i = [0,1])
		let(
			loop = loops[i],
			z = loop[0],
			p1 = loop[1][0]
		) translate([p1.x, p1.y, z - pulley_height(p1.z) - motor_nudge]) {
			NEMA(motor);
			if (i == 0) {
				loops_motor_holderL_stl();
				xxside1(motor_screws);
				xxside1(motor_mount_screws);
			} else {
				loops_motor_holderR_stl();
				xxside1(motor_screws);
				mirror([1,0,0]) xxside1(motor_mount_screws);
			}
		}
}

module loops_motor_holderL_stl() {stl("loops_motor_holderL"); loops_motor_holder(); }
module loops_motor_holderR_stl() {stl("loops_motor_holderR"); mirror([1,0,0]) loops_motor_holder(); }
module loops_motor_holder() color([.15,.15,.15]){
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

//module idler_idler(i) {
//	module w() translate([0,0,ph/2]) explode([0,0,ph/4]) xwasher(idler_washer);
//	for (p = idlerps[i])
//		translate(p) {
//			w();
//			pulley_assembly(idler);
//			rotate([180,0,0]) w();
//		}
//}
//module idlerl_assembly() assembly("idlerl") {
//	explode([0,0,base_part_thick2*0.6],explode_children=true) {
//		idler_holderL2_stl();
//		xxside2(idlerScrews[0]);
//	}
//	idler_idler(0);
//	explode([0,0,-base_part_thick2*0.6],explode_children=true) {
//		idler_holderL1_stl();
//		xxside1(idlerScrews[0]);
//	}
//}
//module idlerr_assembly() assembly("yr") {
//	explode([0,0,base_part_thick2*0.6],explode_children=true) {
//		idler_holderR2_stl();
//		xxside2(idlerScrews[1]);
//	}
//	idler_idler(1);
//	explode([0,0,-base_part_thick2*0.6],explode_children=true) {
//		idler_holderR1_stl();
//		xxside1(idlerScrews[1]);
//	}
//}
//idlerr_assembly();
//
//module idler_holderL1_stl() {stl("idler_holderL1"); idler_holder1(0); }
//module idler_holderL2_stl() {stl("idler_holderL2"); idler_holder2(0); }
//module idler_holderR1_stl() {stl("idler_holderR1"); idler_holder1(1); }
//module idler_holderR2_stl() {stl("idler_holderR2"); idler_holder2(1); }
//
//
//module cut(i,zd) {
//	p = idlerps[i][1];
//	translate([p.x-base_part_thick2*2,p.y-base_part_thick2,min(p.z+ph/2+iwt, frame_y_z3-extr_d2-idler_holderpd)-0.5+zd])
//		cube([base_part_thick2*3,base_part_thick2*4,base_part_thick2*2]);
//
//}
//
//module idler_holder1(i) {
//	xxpart1(concat(idlerScrews[i], idlerHolderScrews[i]),partColor,noscrew=true)
//		difference() {
//			idler_holder(i);
//			cut(i,0);
//		}
//}
//module idler_holder2(i) {
//	xxpart2(concat(idlerScrews[i], idlerHolderScrews[i]),partColor,noscrew=true)
//		difference() {
//			idler_holder(i);
//			cut(i,-base_part_thick2*2+part_assemble_line);
//		}
//}
//
//module idler_holder(i) color([0.2,0.2,0.2]) {
//	difference() {
//		union() {
//			for (p = idler_holderps[i])
//				translate(p.x) rotate(p.y) mirror(p.z) mirror(p[4]) {
//					cylinder(base_part_thick, d = idler_holderpd);
//					translate([extr_d2-idler_holderpd/2,0,0]) {
//						cylinder(base_part_thick, d = idler_holderpd);
//						cube([idler_holderpd/2,idler_holderpd/2,base_part_thick]);
//					}
//					translate([0,-idler_holderpd/2,0])
//						cube([extr_d2-idler_holderpd/2,idler_holderpd,base_part_thick]);
//				}
//			for (l = idlerps[i]) {
//				p = l;
//				translate([p.x, p.y, zidlerholder])
//					cylinder(hidlerholder, d = base_part_thick2);
//			}
//		}
//		for (j = [0:1]) {
//			p = idlerps[i][j];
//			translate(p) rotate([0,0,i?-90:0]) {
//				translate([0, 0, - ph / 2 - iwt])
//					cylinder(ph + 2 * iwt, d = max(pulley_flange_dia(idler), pod + bt * 2) + 1);
//				translate([false?-base_part_thick2:0, ((false?- 1:1) * (pod + bt) - bth)/2, - bwh / 2])
//					cube([base_part_thick2*2, bth, bwh]);
//				translate([((false?-1:1)*(-pod - bt) - bth)/2, (false?0:-1)*base_part_thick2, - bwh / 2])
//					cube([bth, base_part_thick2, bwh]);
//			}
//		}
//		p = i?frame_p3:frame_p2;
//		translate([p.x-extr_d2,p.y-extr_d2,loops[1][0]-base_part_thick2])
//			cube([extr_d,extr_d,base_part_thick2*6]);
//	}
//}

//idler_holderL1_stl();
//idler_holderL2_stl();
//idler_holderR1_stl();
//idler_holderR2_stl();
//xxside1(concat(idlerScrews[0], idlerHolderScrews[0]));
//xxside1(concat(idlerScrews[1], idlerHolderScrews[1]));
