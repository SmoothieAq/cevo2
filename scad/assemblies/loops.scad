include <../cevo2.scad>
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

ph = pulley_height(idler);
pod = pulley_od(idler);
iwt = washer_thickness(idler_washer);
bt = belt_thickness(belt);
bw = belt_width(belt);
bth = bt + 1;
bwh = ph + 2*iwt; //bw + 3;

zidlerholder = loops[1][0]-ph/2-iwt-base_part_thick;
hidlerholder = frame_y_z3-extr_d2-zidlerholder;
hxidlerholder = loops[0][0]+ph/2+iwt+base_part_thick-zidlerholder;

//yxbs = [ for (x = [extr_d2,extr_x_len+extr_d2]) [x,pos_y,frame_y_z3] ];

idlerps = [[loopshp(1),loopslp(3)],[loopshp(2),loopslp(4)]];

idler_holderpd = base_part_thick2-7;
idler_holderps = [ for (i = [0:1]) let (
	fx = i?frame_p3.x:frame_p2.x,
	fy = frame_p2.y,
	fxn = i?-extr_d2-base_part_thick:extr_d2,
	in = -(i-1)
) [
		[[fx,fy-extr_d2-18,frame_y_z3-extr_d2],[180,0,90],[0,i,0],[0,0,-base_part_thick+in*max(0,hxidlerholder-hidlerholder)]],
		[[fx,fy-extr_d2-0*base_part_thick,zidlerholder-4],[90,-90,0],[0,in,0],[0,-base_part_thick,0]],
		[[fx+fxn+i*base_part_thick,fy,frame_y_z3-extr_d2-idler_holderpd/2],[(i?-1:1)*90,0,90],[1,0,0],[(i?-1:1)*base_part_thick,0,0]],
		[[fx+fxn+i*base_part_thick,fy,zidlerholder],[(i?-1:1)*90,i*180,90],[in,0,0],[(i?-1:1)*base_part_thick,0,0]]
	]];
idler_holder_screws = [ for (i = [0:1])
	[ for (p = idler_holderps[i]) axxscrew_setLeng(screwFrameMount,thick=base_part_thick,t=p.x+p[3],r=p.y,xnut=xextrusion_nut(extr_type),horizontal=p.y.x%180!=0,flip=false,plate=0) ]
];

idler_holderScrews = [ for (i = [0:1]) let (

	idlerScrews = let(
		screw = axxscrew_setLengAdjustDepth(screwPart,thick=hidlerholder,nut_depth=1.1),
		pss = [ for (p = idlerps[i]) [p.x,p.y,zidlerholder] ]
	) [ for (p = pss) axxscrew(screw,t=p,r=[180,0,0]) ]

	//	carriageScrews = let(
	//		t1 = 5,
	//		t2 = 7.5,
	//		cps = carriage_hole_ps(carriage_y),
	//		pss = [ for(j = [0:3])  let (p = cps[j]) [(i?-1:1)*(p.z+((j%2)?t1:t2-1)),p.x-cpx/2,p.y]+yxbs[i] ],
	//		r = [90,0,90+i*180]
	//	) [ for (j = [0:3]) axxscrew_setLeng(screwPart,t=pss[j],r=r,thick=((j%2)?t1:t2-1)+5,xnut=false,horizontal=true) ],

	//	xholderScrews = let(
	//		thick = rh2*2+10-0.5,
	//		t = yxbs[i]+[(i?-1:1)*(-xrail_xoff+rail_hole_ps(rail_x)[0]),0,- xrail_zoff + rh2 - thick/2]
	//	) [axxscrew_setLengAdjustDepth(screwPart,thick=thick,t=t,r=[180,0,33])]

) concat( idlerScrews) ];

module loops_assembly() assembly("loops") {

	for (loop = loops) {
		translate([0, 0, loop.x]) {
			for (p = loop.y)
			translate([p.x, p.y, 0])
				pulley_assembly(p.z);
			belt(GT2x6, [for (p = loop.y) [p.x, p.y, p[3] * pulley_pr(p[2])]]);
		}
	}
	idler_holderL1_stl();
	xxside1(idler_holder_screws[0]);
	idler_holderR1_stl();
	xxside1(idler_holder_screws[1]);

	for (i = [0,1])
		let(
			loop = loops[i],
			z = loop[0],
			p1 = loop[1][0]
		) translate([p1.x, p1.y, z - pulley_height(p1.z) - motor_nudge]) {
			NEMA(motor);
			if (i == 0) {
				loopss_motor_holderL_stl();
				xxside1(motor_screws);
				xxside1(motor_mount_screws);
			} else {
				loopss_motor_holderR_stl();
				xxside1(motor_screws);
				mirror([1,0,0]) xxside1(motor_mount_screws);
			}
		}
}

//loops_assembly();

module loopss_motor_holderL_stl() {stl("loops_motor_holderL"); loops_motor_holder(); }
module loopss_motor_holderR_stl() {stl("loops_motor_holderR"); mirror([1,0,0]) loops_motor_holder(); }
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



module idlerl_assembly() assembly("idlerl") {

	explode([xyholder_thick2,0,0],explode_children=true) {
		idler_holderL1_stl();
		xxside1(idler_holderScrews[0]);
	}
}
module idlerl_assembly() assembly("yr") {

	explode([-xyholder_thick2,0,0],explode_children=true) {
		idler_holderR1_stl();
		xxside1(idler_holderScrews[1]);
	}
}

module idler_holderL1_stl() {stl("idler_holderL1"); idler_holder1(0); }
module idler_holderL2_stl() {stl("idler_holderL2"); idler_holder2(0); }
module idler_holderR1_stl() {stl("idler_holderR1"); idler_holder1(1); }
module idler_holderR2_stl() {stl("idler_holderR2"); idler_holder2(1); }


module cut(i,zd) {
	p = idlerps[i];
	#translate([p[0].x-base_part_thick2,p[0].y-base_part_thick2,p[(i+1)%2].z+ph/2+iwt-base_part_thick2])
		cube([base_part_thick2*3,base_part_thick2*4,base_part_thick2]);

}
function cut(i,zd) = [idlerps[i][1][0].x-base_part_thick2,-cl/2-cpx/2-3,(idlerps[i][(i+1)%2]-yxbs[i]).z+ph/2+iwt+zd];

module idler_holder1(i) {
	xxpart1(idler_holder_screws[i],partColor,noscrew=true)
	/*tr(yxbs[i])*/ difference() {
		idler_holder(i);
		cut(i,-base_part_thick2);
//		translate(cut(i,-base_part_thick2))
//			cube([base_part_thick2*3,base_part_thick2*6,base_part_thick2*4]);
	}
}
module idler_holder2(i) {
	xxpart2(idler_holder_screws[i],partColor,noscrew=true)
	/*tr(yxbs[i])*/difference() {
		idler_holder(i);
		cut(i,-part_assemble_line);
//		translate(cut(i,-part_assemble_line))
//			cube([base_part_thick2*3,base_part_thick2*6,base_part_thick2*4]);
	}
}

module idler_holder(i) color([0.2,0.2,0.2]) {
//	y1xb = yxbs[i];
	difference() {
		union() {
			for (p = idler_holderps[i])
				translate(p.x) rotate(p.y) mirror(p.z) {
					cylinder(base_part_thick, d = idler_holderpd);
					translate([extr_d2-idler_holderpd/2,0,0]) {
						cylinder(base_part_thick, d = idler_holderpd);
						cube([idler_holderpd/2,idler_holderpd/2,base_part_thick]);
					}
					translate([0,-idler_holderpd/2,0])
						cube([extr_d2-idler_holderpd/2,idler_holderpd,base_part_thick]);
				}
			for (l = idlerps[i]) {
				p = l;
				translate([p.x, p.y, zidlerholder])
					cylinder(hidlerholder, d = base_part_thick2);
			}
		}
		for (j = [0:1]) {
			p = idlerps[i][j];
			translate(p) rotate([0,0,i?-90:0]) {
				translate([0, 0, - ph / 2 - iwt])
					cylinder(ph + 2 * iwt, d = max(pulley_flange_dia(idler), pod + bt * 2) + 1);
				translate([false?-base_part_thick2:0, ((false?- 1:1) * (pod + bt) - bth)/2, - bwh / 2])
					cube([base_part_thick2*2, bth, bwh]);
				translate([((false?-1:1)*(-pod - bt) - bth)/2, (false?0:-1)*base_part_thick2, - bwh / 2])
					cube([bth, base_part_thick2, bwh]);
			}
		}
	}
}

idler_holderL1_stl();