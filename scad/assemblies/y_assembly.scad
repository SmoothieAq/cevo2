include <../cevo2.scad>
include <../defs/loops_defs.scad>

carriage_y = rail_carriage(rail_y);
ch = carriage_height(carriage_y);
chc = ch-carriage_clearance(carriage_y);
cw = carriage_width(carriage_y);
cl = carriage_length(carriage_y);
cpx = carriage_pitch_x(carriage_y);
rh2 = rail_height(rail_y)/2;
h2byxholder = frame_y_z3-loops[1][0]+pulley_height(idler)/2+-cw/2+base_part_thick;


module y_assembly() assembly("y") {

	translate([extr_d2,extr_d2,frame_y_z3])
		rotate([90,0,90])
			xrail_assembly(rail_y,pos=pos_y-extr_d2-cpx/2);

	y1xb = [extr_d2,pos_y,frame_y_z3];
	translate(y1xb)
		yxholder(y1xb);
//	translate(loopslp(2)-[0,0,10]) cube([10,10,10]);

	translate([extr_x_len+extr_d2,extr_d2,frame_y_z3])
		rotate([-90,0,90])
			xrail_assembly(rail_y,pos=pos_y-extr_d2);
}

module yxholder(y1xb) color(grey(24)){
	difference() {
		union() {
			translate([ch+part_assemble_nudge,0,-xrail_zoff+rh2])
				rotate([0,90,0])
					translate([0,0,-chc])
						cylinder(xyholder_thick2+chc,d=xyholder_thick2);
			difference() {
				union() {
					x = ch+part_assemble_nudge-3;
					yo = 3;
					z = -xrail_zoff+rh2+1;
					h = xrail_zoff-rh2+cw/2;
					d1 = xyholder_thick2+4;
					d2 = xyholder_thick2*0.6;
					translate([x,-yo,z])
						rotate([-5,1,0])
							cylinder(h,d1=d1,d2=d2);
					translate([x,-cpx+yo,z])
						rotate([5,1,0])
							cylinder(h,d1=d1,d2=d2);
				}
				translate([0,-cl/2-cpx/2-3,cw/2-part_assemble_nudge])
					cube([xyholder_thick2*2,cl,xyholder_thick2]);
				translate([0,-cl/2-cpx/2-3,-xyholder_thick2-frame_y_z3+loops[0][0]+pulley_height(idler)/2])
					cube([xyholder_thick2*2,cl,xyholder_thick2]);
				translate([-xyholder_thick2*2+part_assemble_nudge+ch,-cl/2-cpx/2-3,-cw/2-part_assemble_nudge])
					cube([xyholder_thick2*2,cl,cw+2]);
				translate([-xyholder_thick2*2+part_assemble_nudge+carriage_clearance(carriage_y),-cl/2-cpx/2-3,-cw])
					cube([xyholder_thick2*2,cl,cw+2]);
			}
			for (l = [loopshp(4),loopslp(2)]) {
				p = l - y1xb;
				difference() {
					translate([p.x, p.y, -h2byxholder-cw/2-part_assemble_nudge])
						#cylinder(h2byxholder, d = xyholder_thick2);
				}
			}
		}
		translate([xyholder_thick2/2-0.1,-cpx/2,])
			rotate([0,90,0])
				linear_extrude(xyholder_thick2)
					carriage_hole_positions(carriage_y)
						circle(screw_pilot_hole(carriage_screw_depth(carriage_y)));
	}
}

y_assembly();