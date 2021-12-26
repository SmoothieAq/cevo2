include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <NopSCADlib/vitamins/tubings.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
use <dotSCAD/ptf/ptf_rotate.scad>
use <dotSCAD/util/flat.scad>


mw = NEMA_width(leads_motor);
lbz = NEMA_shaft_length(leads_motor)[0]-frame_y_z2+frame_y_z1;

lead_bearing_holder_screws = [ for (i = [-1:1]) let(
	t = [i?-mw/2+base_part_thickx-1:-mw/2-extr_d2,i*(-mw/2-10),i?-extr_d2:base_part_thickx],
	r = i?[90,0,90]:[0,0,0],
	thick = i?base_part_thickx*2:base_part_thickx,
	horizontal = i != 0
) axxscrew_setLengAdjustDepth(screwFrameMount,thick=thick,t=t,r=r,spacing=20,horizontal=horizontal) ];

function lead_bearing_holder_screws() = lead_bearing_holder_screws;

module leads_holder_stl() stl("leads_holder") leads_holder();
module leads_holder() color(partColor) {
	difference() {
		union() {
			for (r = [1, -1]) {
				translate([-mw/2-3, r*(-mw/2-10), -extr_d2-3])
					let (
						h = holder_thick2 * 4.5,
						d1 = holder_thick2,
						d2 = holder_thick2 - 3,
						dz = holder_thick2,
						rx = r * -20,
						ry = 30,
						sh = lbz-bb_width(lead_bearing) + extr_d2-3
					) {
						rotate([rx, ry, 0])
							translate([0, 0, - dz])
								#cylinder(h, d1 = d1, d2 = d2);
						let (
							st = 0.7,
							sr = - atan(sin(rx) / (sin(ry) * cos(rx))),
							ca = cos(ry) * cos(rx),
							coa = ca ,//- h / (d1 - d2),
							cr = acos(ca),
							//y = - sin(cr) * d1 - dz*cos(cr),
							//x = cos(cr) * d1 - dz/ca,
							//cob = y - coa * x,
							x = -sin(cr)*dz + cos(cr)*d1,
							y = -cos(cr)*dz - sin(cr)*d1,
							sw = (sh-y) / coa

						) {
							echo(h = h, sh = sh, ca = ca, coa = coa, cr = cr, x=x, y=y, sw = sw);
							rotate([0, 0, sr])
								translate([x, - st / 2, y])
									cube([sw, st, h]);
							rotate([0,0,sr])rotate([0,cr,0])translate([-0.5+x,-0.5,y])cube([1,1,h]);
						}
					}
			}
			translate([-mw/2-extr_d2, 0, 0])
				rotate([0, 45, 0])
					translate([0, 0, -holder_thick2])
						cylinder(holder_thick2*3, d1 = holder_thick2, d2 = holder_thick2-3);
			translate([0,0,lbz-bb_width(lead_bearing)])
				cylinder(holder_thick1+10,d=bb_diameter(lead_bearing)+15);
			xxside1_plate(lead_bearing_holder_screws);
		}
		xxside1_hole(lead_bearing_holder_screws);
		*translate([-extr_d-mw/2, -extr_d*4, -extr_d])
			cube([extr_d, extr_d*8, extr_d]);
		*translate([-extr_d*2-mw/2+1, -extr_d*4, -extr_d])
			cube([extr_d, extr_d*8, extr_d]);
		*translate([-extr_d*2, -extr_d*4, -extr_d*2+1])
			cube([extr_d*2, extr_d*8, extr_d]);
		*translate([0,0,lbz-bb_width(lead_bearing)-1])
			cylinder(holder_thick1*2,d=bb_diameter(lead_bearing)+part_assemble_nudge);
		*translate([0,0,lbz-bb_width(lead_bearing)+holder_thick1])
			cylinder(holder_thick1*4,d=bb_diameter(lead_bearing)*3);
		lnw = leadnut_flange_dia(leadnut)+motor_nudge*4;
		translate([0,0,lbz-bb_width(lead_bearing)-extr_d])
			cylinder(extr_d,d=lnw);
		translate([0,-lnw/2,lbz-bb_width(lead_bearing)-extr_d])
			cube([lnw,lnw,extr_d]);
	}
}

leads_holder_stl();
/*
h = 50;
dz = 20;
rx = 20;
ry = 40;
sr = - atan(sin(rx) / (sin(ry) * cos(rx)));
ca = cos(ry) * cos(rx);
//coa = ca + (d1 - d2) / h;
cr = acos(ca); echo(sr=sr,ca=ca,cr=cr);
//y = - sin(cr) * d1;
//x = cos(cr) * d1;
//cob = y - coa * x;
//sw = (sh - cob) / coa;

rotate([rx,ry,0])translate([-0.5,-0.5,-dz])cube([1,1,h]);
#rotate([0,0,sr])rotate([0,cr,0])translate([-0.5,-0.5,-dz])cube([1,1,h]);

 */