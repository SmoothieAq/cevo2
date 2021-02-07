include <../cevo2.scad>
include <../defs/loops_defs.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>

carriage_y = rail_carriage(rail_y);
ch = carriage_height(carriage_y);
chc = ch-carriage_clearance(carriage_y);
cw = carriage_width(carriage_y);
cl = carriage_length(carriage_y);
cpx = carriage_pitch_x(carriage_y);
rh2 = rail_height(rail_y)/2;

ph = pulley_height(idler);
pod = pulley_od(idler);
iwt = washer_thickness(idler_washer);
bt = belt_thickness(belt);
bw = belt_width(belt);
bth = bt + 1;
bwh = ph + 2*iwt; //bw + 3;

h2byxholder = frame_y_z3-loops[1][0]+ph/2+-cw/2+base_part_thick;
echo(h2byxholder=h2byxholder);

yxbs = [ for (x = [extr_d2,extr_x_len+extr_d2]) [x,pos_y,frame_y_z3] ];

idlerps = [[loopshp(4),loopslp(2)],[loopslp(1),loopshp(3)]];

yxholderScrews = [ for (i = [0:1]) let (

	idlerScrews = let(
		screw = axxscrew_setLengAdjustDepth(screwPart,thick=h2byxholder,nut_depth=1.1),
		pss = [ for (p = idlerps[i]) [p.x,p.y,frame_y_z3-h2byxholder-cw/2] ]
	) [ for (p = pss) axxscrew(screw,t=p,r=[180,0,0]) ],

	carriageScrews = let(
		t1 = 5,
		t2 = 7.5,
		cps = carriage_hole_ps(carriage_y),
		pss = [ for(j = [0:3])  let (p = cps[j]) [(i?-1:1)*(p.z+((j%2)?t1:t2-1)),p.x-cpx/2,p.y]+yxbs[i] ],
		r = [90,0,90+i*180]
	) [ for (j = [0:3]) axxscrew_setLeng(screwPart,t=pss[j],r=r,thick=((j%2)?t1:t2-1)+5,xnut=false,horizontal=true) ],

	xholderScrews = let(
		thick = rh2*2+10-0.5,
		t = yxbs[i]+[(i?-1:1)*(-xrail_xoff+rail_hole_ps(rail_x)[0]),0,- xrail_zoff + rh2 - thick/2]
	) [axxscrew_setLengAdjustDepth(screwPart,thick=thick,t=t,r=[180,0,33])]

) concat( idlerScrews, carriageScrews, xholderScrews) ]; echo("***!!",rps=rail_hole_ps(rail_x));

module y_assembly() assembly("y") {

	translate([extr_d2,extr_d2,frame_y_z3])
		rotate([90,0,90])
			xrail_assembly(rail_y,pos=pos_y-extr_d2-cpx/2);

	yxholderL1_stl();
	yxholderL2_stl();
	xxsides(yxholderScrews[0]);

	translate([extr_x_len+extr_d2,extr_d2,frame_y_z3])
		rotate([-90,0,90])
			xrail_assembly(rail_y,pos=pos_y-extr_d2);
	yxholderR1_stl();
	yxholderR2_stl();
	xxsides(yxholderScrews[1]);
}

module yxholderL1_stl() {stl("yxholderL1"); yxholder1(0); }
module yxholderL2_stl() {stl("yxholderL2"); yxholder2(0); }
module yxholderR1_stl() {stl("yxholderR1"); yxholder1(1); }
module yxholderR2_stl() {stl("yxholderR2"); yxholder2(1); }

function cut(i,zd) = [ch + part_assemble_nudge-xyholder_thick2,-cl/2-cpx/2-3,(idlerps[i][(i+1)%2]-yxbs[i]).z+ph/2+iwt+zd];

module yxholder1(i) {
	xxpart1(yxholderScrews[i],partColor,noscrew=true)
	tr(yxbs[i]) difference() {
		yxholder(i);
		translate(cut(i,-xyholder_thick2))
			cube([xyholder_thick2*3,cl*1.5,xyholder_thick2]);
	}
}
module yxholder2(i) {
	xxpart2(yxholderScrews[i],partColor,noscrew=true)
	tr(yxbs[i]) difference() {
		yxholder(i);
		translate(cut(i,-part_assemble_line))
			cube([xyholder_thick2*3,cl*1.5,xyholder_thick2*4]);
	}
}


module yxholder(i) {
	y1xb = yxbs[i];
	difference() {
		union() {
			mirror([i,0,0]) {
				translate([ch + part_assemble_nudge, 0, - xrail_zoff + rh2])
					difference() {
						rotate([0, 90, 0])
							translate([0, 0, - chc])
								cylinder(xyholder_thick2 + chc, d = rail_width(rail_x) + 10);
						translate([-1-chc,-xyholder_thick2,rh2+5])
							cube([xyholder_thick2*2, xyholder_thick2*2, xyholder_thick2]);
						translate([-1-chc,-xyholder_thick2,-xyholder_thick2-rh2-5])
							cube([xyholder_thick2*2, xyholder_thick2*2, xyholder_thick2]);
					}
				difference() {
					union() {
						x = ch + part_assemble_nudge - 3;
						yo = 3;
						z = - xrail_zoff + rh2 + 1;
						h = xrail_zoff - rh2 + cw / 2;
						d1 = xyholder_thick2 + 4;
						d2 = xyholder_thick2 * 0.5;
						translate([x, - yo, z])
							rotate([- 5, 5, 0])
								cylinder(h, d1 = d1, d2 = d2);
						translate([x, - cpx + yo, z])
							rotate([5, 5, 0])
								cylinder(h, d1 = d1, d2 = d2);
					}
					translate([0, - cl / 2 - cpx / 2 - 3, cw / 2 - part_assemble_nudge])
						cube([xyholder_thick2 * 2, cl, xyholder_thick2]);
					translate([0, - cl / 2 - cpx / 2 - 3, - xyholder_thick2 - frame_y_z3 + loops[0][0] + bwh/2])
						cube([xyholder_thick2 * 2, cl, xyholder_thick2]);
					translate([- xyholder_thick2 * 2 + part_assemble_nudge + ch, - cl / 2 - cpx / 2 - 3, - cw / 2 -
						part_assemble_nudge])
						cube([xyholder_thick2 * 2, cl, cw + 2]);
					translate([- xyholder_thick2 * 2 + part_assemble_nudge + carriage_clearance(carriage_y), - cl / 2 -
							cpx / 2 - 3, - cw])
						cube([xyholder_thick2 * 2, cl, cw + 2]);
				}
			}
			for (l = idlerps[i]) {
				p = l - y1xb;
				translate([p.x, p.y, -h2byxholder-cw/2])
					cylinder(h2byxholder-part_assemble_nudge, d = xyholder_thick2);
			}
		}
		mirror([i,0,0])
			translate([ch-part_assemble_nudge,-rail_width(rail_x)/2-part_assemble_nudge/2,part_assemble_nudge/2- xrail_zoff])
				cube([xyholder_thick2*2,rail_width(rail_x)+part_assemble_nudge,rh2*2-part_assemble_nudge]);
		for (j = [0:1]) {
			p = idlerps[i][j] - y1xb;
			translate(p) {
				translate([0, 0, - ph / 2 - iwt])
					cylinder(ph + 2 * iwt, d = max(pulley_flange_dia(idler), pod + bt * 2) + 1);
				translate([i?-xyholder_thick2:0, ((j?- 1:1) * (pod + bt) - bth)/2, - bwh / 2])
					cube([xyholder_thick2, bth, bwh]);
				translate([((i?-1:1)*(-pod - bt) - bth)/2, (j?0:-1)*xyholder_thick2, - bwh / 2])
					cube([bth, xyholder_thick2, bwh]);
			}
		}
	}
}

yxholderL1_stl();