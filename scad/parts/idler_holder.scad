include <../defs/loops_defs.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>


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

idlerps = [[loopshp(1),loopslp(3)],[loopshp(2),loopslp(4)]];

idler_holderpd = base_part_thick2-7;
idler_holderps = [ for (i = [0:1]) let (
	fx = i?frame_p3.x:frame_p2.x,
	fy = frame_p2.y,
	fxn = i?-extr_d2-base_part_thick:extr_d2,
	in = -(i-1)
) [
		[[fx,fy-extr_d2-18,frame_y_z3-extr_d2],[180,0,90],[0,i,0],[0,0,-base_part_thick+in*max(0,hxidlerholder-hidlerholder)],[0,0,0]],
		[[fx,fy-extr_d2,zidlerholder-idler_holderpd/2],[90,180,0],[1,1,0],[0,1*-base_part_thick,0],[0,0,0]],
		[[fx+fxn+i*base_part_thick,fy,frame_y_z3-extr_d2-idler_holderpd/2],[90,180,(i?-1:1)*90],[i,0,0],[(i?-1:1)*base_part_thick,0,0],[0,0,0]],
		[[fx+fxn+i*base_part_thick,fy,zidlerholder],[90,180,(i?-1:1)*90],[i,in,0],[(i?-1:1)*base_part_thick,0,0],[0,i,0]]
	]];

idlerScrews = [ for (i = [0:1])
	let(
		screw = axxscrew_setLengAdjustDepth(screwPart,thick=hidlerholder,nut_depth=1.05,nut_plate=0,plate=0,flip=false),
		pss = [ for (p = idlerps[i]) [p.x,p.y,zidlerholder] ]
	) [ for (p = pss) axxscrew(screw,t=p,r=[180,0,0]) ]
];

idlerHolderScrews = [ for (i = [0:1])
	[ for (p = idler_holderps[i]) axxscrew_setLeng(screwFrameMount,thick=base_part_thick,t=p.x+p[3],r=p.y,horizontal=p.y.x%180!=0,twist=p.y.x%180!=0?90:0,flip=false,plate=0,spacing=0) ]
];

function idlerHolderScrews(i,onz) = let (ss = idlerHolderScrews[i]) onz ? [ss[1],ss[2],ss[3]] : [ss[0]];


module idler_idler(i) {
	module w() translate([0,0,ph/2]) explode([0,0,ph/4]) xwasher(idler_washer);
	for (p = idlerps[i])
		translate(p) {
			w();
			pulley_assembly(idler);
			rotate([180,0,0]) w();
		}
}
module idler_assembly() pose(a=[ 66.20, 0.00, 315.70 ],t=[ -6.72, 393.36, 565.37 ],d=246.51) assembly("idler", big=false) {
	explode([0,0,base_part_thick2*0.6],explode_children=true) {
		idler_holderL2_stl();
		xxside2(idlerScrews[0]);
	}
	idler_idler(0);
	explode([0,0,-base_part_thick2*0.6],explode_children=true) {
		idler_holderL1_stl();
		xxside1(idlerScrews[0]);
	}
	explode([0,0,base_part_thick2*0.6],explode_children=true) {
		idler_holderR2_stl();
		xxside2(idlerScrews[1]);
	}
	idler_idler(1);
	explode([0,0,-base_part_thick2*0.6],explode_children=true) {
		idler_holderR1_stl();
		xxside1(idlerScrews[1]);
	}
}
idler_assembly();

module idler_holderL1_stl() {stl("idler_holderL1"); idler_holder1(0); }
module idler_holderL2_stl() {stl("idler_holderL2"); idler_holder2(0); }
module idler_holderR1_stl() {stl("idler_holderR1"); idler_holder1(1); }
module idler_holderR2_stl() {stl("idler_holderR2"); idler_holder2(1); }
//idler_holderL1_stl();

module idler_holder_cut(i,zd) {
	p = idlerps[i][1];
	translate([p.x-base_part_thick2*2,p.y-base_part_thick2,min(p.z+ph/2+iwt, frame_y_z3-extr_d2-idler_holderpd)-0.5+zd])
		cube([base_part_thick2*3,base_part_thick2*4,base_part_thick2*2]);

}

module idler_holder1(i) color(partColor) {
	xxpart1(concat(idlerScrews[i], idlerHolderScrews[i]),partColor,noscrew=true)
		difference() {
			idler_holder(i);
			idler_holder_cut(i,0);
		}
}
module idler_holder2(i) color(partColor) {
	xxpart2(concat(idlerScrews[i], idlerHolderScrews[i]),partColor,noscrew=true)
		difference() {
			idler_holder(i);
			idler_holder_cut(i,-base_part_thick2*2+part_assemble_line);
		}
}

module idler_holder(i) {
	difference() {
		union() {
			for (p = idler_holderps[i])
				translate(p.x) rotate(p.y) mirror(p.z) mirror(p[4]) {
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
		p = i?frame_p3:frame_p2;
		translate([p.x-extr_d2,p.y-extr_d2,loops[1][0]-base_part_thick2])
			cube([extr_d,extr_d,base_part_thick2*6]);
	}
}
