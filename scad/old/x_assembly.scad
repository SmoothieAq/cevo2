include <../cevo2.scad>
include <../defs/loops_defs.scad>

include <../../../xNopSCADlib/xVitamins/xrails.scad>
include <../../../xNopSCADlib/xVitamins/xnuts.scad>
include <NopSCADlib/vitamins/tubings.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/fans.scad>
use <../parts/x_holder.scad>

//	blower = BL40x10;
blower = RB5015;
fan = fan25x10;

dhotend = 2;
tr = 4.5;
hotend = [25,13,41];
carriage_x = xrail_carriage(rail_x);
cl = carriage_length(carriage_x);
cw = carriage_width(carriage_x);
ch = carriage_height(carriage_x);
blr = 6.1;
a = 22;

module x_assembly() assembly("x") {


	*translate([extr_d2-xrail_xoff,pos_y,xrail_z]) {
		xrail_assembly(rail_x, pos=pos_x-extr_d2+xrail_xoff);
		translate([xrail_len/2,0,-5]) rotate([0,-90,0]) tubing(CARBONFIBER10, length=xrail_len);
	}
	x_holderL1_stl();
	x_holderR1_stl();
	x_holderL2_stl();
	x_holderR2_stl();

//	translate([pos_x,pos_y-cw/2-hotend.y/2-dhotend,xrail_z+ch]) {
//		color([0.2, 0.2, 0.2, 1])
//			union() {
//				difference() {
//					union() {
//						difference() {
//							translate([-cl/2, -hotend.y/2, 0])
//								cube([cl, cw+dhotend+hotend.y, base_part_thickx]);
//							for (i = [0, 1]) mirror([i, 0, 0])
//								translate([cl/2-tr, hotend.y/2+dhotend-tr*2-1+7.5, -hotend.x-tr-7])
//									rotate([20, 0, 0]) cube([tr+1, tr+1, hotend.x+tr+19]);
//						}
//						for (i = [0, 1]) mirror([i, 0, 0]) {
//							difference() {
//								translate([cl/2-tr*2, -hotend.y/2+tr, -hotend.x-tr+1])
//									cube([tr*2, hotend.y+dhotend-tr-part_assemble_nudge, hotend.x+tr]);
//								translate([cl/2-tr*2-1, hotend.y/2+dhotend-tr*4+7.5, -hotend.x-tr-7])
//									rotate([a, 0, 0]) cube([tr*2+2, tr*3, hotend.x+tr+19]);
//							}
//							//						translate([cl/2-tr, hotend.y/2+dhotend-tr+7.5, -hotend.x-tr-7])
//							translate([cl/2-tr, -hotend.y/2, 0])
//								rotate([a, 0, 0]) translate([0, tr, -hotend.x-7])cylinder(hotend.x+base_part_thickx+7, r = tr);
//						}
//						difference() {
//							translate([-cl/2+tr, -hotend.y/2, 0])
//								rotate([a, 0, 0])translate([0, 0, -hotend.x-7])
//									cube([cl-2*tr, tr*2, tr*2]);
//							translate([-cl/2-1, -hotend.y/2+motor_nudge, -hotend.x-1])
//								cube([cl+2, hotend.y, hotend.y]);
//						}
//						translate([0, cw+hotend.y/2+dhotend, 0]) {
//							for (x = [cl/2+3, -cl/2+blr])
//								translate([x, blr-0.1, 0])
//									cylinder(base_part_thickx, r = blr);
//							translate([-cl/2+blr, 0, 0])
//								cube([cl-blr+3, blr*2, base_part_thickx]);
//							translate([-cl/2, 0, 0])
//								cube([blr+0.1, blr+0.1, base_part_thickx]);
//						}
//					}
//					translate([-cl/2-5, -hotend.y/2-5, base_part_thickx])
//						cube([cl+10, cw+dhotend+hotend.y+10, base_part_thickx]);
//					translate([-cl/2-1, -hotend.y/2-cw, -1])
//						cube([cl+2, cw, base_part_thickx+10]);
//					translate([-cl/2-1, 2, -hotend.x-hotend.y])
//						cube([cl+2, hotend.y, hotend.y]);
//					translate([-cl/2-1, hotend.y/2+dhotend+3, -hotend.x-1])
//						cube([cl+2, hotend.y, hotend.y]);
//				}
//				for (i = [0, 1]) mirror([i, 0, 0]) difference() {
//					union() {
//						translate([cl/2-tr-1, hotend.y/2-1, -hotend.x])
//							rotate([-35, 0, 0])
//								cube([base_part_thick,20,base_part_thickx]);
//						translate([cl/2-tr-5.8, 20.05, -40.9+base_part_thickx])
//							cube([8.8, base_part_thick*0.6, base_part_thickx]);
//
//					}
//					translate([cl/2-tr-5.8, 20.05, -40.9+base_part_thickx])
//						translate([base_part_thickx/2-0.5, 0, base_part_thickx/2]) rotate([90, 0, 0]) {
//							xscrew_hole(screwPart,l = base_part_thick, depth = 0, horizontal = true,spacing=-9);
//							xnut_hole(xscrew_nut(screwPart), depth = 0, spacing = 1, twist = 30);
//						}
//					translate([cl/2-tr-5.7, 20.05+base_part_thick*0.6, -40.9+base_part_thickx-0.1])
//						cube([8.8,base_part_thick*2,base_part_thickx+1]);
//					translate([cl/2-tr-base_part_thickx,15,-40.9])
//						cube([base_part_thickx*2,base_part_thickx*2,base_part_thickx]);
//				}
//			}
//
//		*translate([0,0,-hotend.z])
//			color([0.3,0.28,0.31])
//				rotate([90, 0, 180]) import("../extparts/Mosquito_Hotend_Std.STL",convexity=10);
//
//		*translate([0,-hotend.y/2-fan_depth(fan)/2,-fan_width(fan)/2])rotate([90,0,0])fan(fan);
//
//		*translate([0,0,base_part_thickx]) color([0.3, 0.28, 0.31]) {
//			translate([-6.7, 22, 18]) rotate([0, 67.785, 180]) import("../extparts/Orbiter_Housing_1.5.stl");
//			translate([-6.5,-10.5, 18.5]) rotate([180, 0, 0]) import("../extparts/Latch_v1.5.stl");
//			translate([-6,22.1,18]) rotate([90,0,180]) {
//				cylinder(2,d=36.2);
//				cylinder(17.5,d=30);
//			}
//
//		}

//		#color([0.2, 0.2, 0.2, 1])
//			difference() {
//				union() {
//					translate([-cl/2+3,hotend.y/2+dhotend+cw,-base_part_thick])
//						cube([24,base_part_thickx,base_part_thick]);
//					translate([-hotend.x/2+22.5-base_part_thickx/2-4.3,26,-30])
//						rotate([45,0,0]) {
//							translate([0,base_part_thickx-0.1,0])cube([base_part_thickx, 45.4-base_part_thickx+0.1, base_part_thick]);
//							translate([base_part_thickx/2,45.4,0]) cylinder(base_part_thick,d=base_part_thickx);
//							translate([-20.6,0,1])cube([36.8, base_part_thickx, base_part_thick-1]);
//						}
//					translate([-9,hotend.y/2+dhotend+cw+6,-base_part_thick+0])
//						rotate([0,0,-40])
//							cube([base_part_thickx,20,base_part_thick]);
//					for (i = [0, 1]) mirror([i, 0, 0])
//						translate([cl/2-tr-5.8, 19+6, -40.9+base_part_thickx])  difference() {
//							cube([base_part_thickx-1, base_part_thick*0.6, base_part_thickx]);
//							translate([base_part_thickx/2-0.5, 0, base_part_thickx/2]) rotate([90, 0, 0])
//								xscrew_hole(screwPart, l = base_part_thick, depth = 0, horizontal = true);
//						}
//				}
//				translate([-hotend.x/2+22.5-base_part_thickx-4.3,26+sqrt(sqr(base_part_thick)*2),-30])
//					rotate([45,0,0])
//						cube([base_part_thickx*2,45.4,base_part_thick]);
//				for (i = [0, 1]) mirror([i, 0, 0])
//					translate([-cl/2+9, 26-2, -40.9])
//						rotate([0,-30,0])
//							cube([base_part_thickx,base_part_thick,base_part_thickx]);
//				translate([-cl/2+3, 19+6-base_part_thick, -40.9+base_part_thickx-0.1])
//					cube([38.8+3,base_part_thick,base_part_thickx+10]);
//			}

// mount: [-16.5,-1],[18,6]

		translate([cl/2-5,cw+hotend.y/2+dhotend+blr,0]) rotate([180,0,0])
			color([0.9,0.88,0.91]) import("../extparts/BLTouch_contracted.stl");

		*translate([-hotend.x/2+22.5,26,-hotend.z+11])
			rotate([135,0,180])blower(blower);
		translate([0,0,-44]) mosquito_fan_duct_stl();
		*translate([125.0,123,-44]) rotate([0,0,180])
			color([0.2, 0.2, 0.2, 1])import("../extparts/RHD_BMG_Mosquito_Fan_Shroud.stl");

	}
	*for (loop = loops) {
		translate([0, 0, loop.x]) {
			for (p = loop.y)
			translate([p.x, p.y, 0])
				pulley_assembly(p.z);
			belt(GT2x6, [for (p = loop.y) [p.x, p.y, p[3] * pulley_pr(p[2])]]);
		}
	}
}

module fanslice(x1,x2) {
	difference() {
		translate([125.0, 123, 0]) rotate([0, 0, 180])
			import("../extparts/RHD_BMG_Mosquito_Fan_Shroud.stl", convexity = 10);
		translate([x1-50,-50,-5]) cube([50,100,40]);
		translate([x2,-50,-5]) cube([50,100,40]);
	}
}
module mosquito_fan_duct_stl() stl("mosquito_fan_duct") {
	color(partColor) {
		difference() {
			union() {
				d = 1;
				x2 = 10.2;
				x3 = 11;
				f = (1+x3-x2)/(x3-x2);
				fanslice(-x2, x2);
				translate([x3*f-x3-d+0.01, 0, 0]) scale([f, 1, 1]) fanslice(-x3, -x2);
				translate([-d+0.02, 0, 0]) fanslice(-30, -x3);
				translate([-x3*f+x3+d-0.01, 0, 0]) scale([f, 1, 1]) fanslice(x2, x3);
				translate([d-0.02, 0, 0]) fanslice(x3, 30);
			}
			translate([-50, -50, -45]) cube([100, 100, 40]);
			difference() {
				translate([10, 17, 10.001]) cube([15, 10, 10]);
				translate([cl/2-8.1, 18, 2.45])
					rotate([0, -60, 0])
						cube([base_part_thickx, base_part_thickx*2, base_part_thickx]);
				translate([cl/2-10.6-base_part_thickx, 25.9, 5.01])
					rotate([45, 0, 0])
						cube([base_part_thickx, base_part_thickx*2, base_part_thickx]);
				translate([5.05, 20.315, 5]) cube([base_part_thickx, base_part_thickx, base_part_thickx]);
			}
			*translate([-50,-50,5]) cube([100,100,50]);
		}
		for (i = [0, 1]) mirror([i, 0, 0]) {
			translate([cl/2-tr-5.8, 19+6-base_part_thick*0.6-part_assemble_nudge/2, 2.8+base_part_thickx]) difference() {
				cube([base_part_thickx-1, base_part_thick*0.6, base_part_thickx]);
				translate([base_part_thickx/2-0.5, 0, base_part_thickx/2]) rotate([90, 0, 0])
					xscrew_hole(screwPart, l = base_part_thick, depth = 0, horizontal = true);
			}
			translate([6.5, 20.25, 0])
				rotate([0, 0, -35])
					cube([6, 1, 9.5]);
		}
		translate([-14,20,0]) cube([28,11,0.5]);
		translate([-10,30,0]) cube([20,5,0.5]);
	}
}


//mosquito_fan_duct_stl();
x_assembly();