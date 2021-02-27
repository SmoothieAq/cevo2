include <../cevo2.scad>
include <../defs/base_defs.scad>

include <../../../xNopSCADlib/xVitamins/xnuts.scad>
include <NopSCADlib/vitamins/blowers.scad>

//	blower = BL40x10;
blower = RB5015;
blowert = [0,37.4,3.5];
blowerr = [45,0,0];

fan_capd = 3.8;
fan_capt = 1.2;

fan_duct_screw_tapsize = [base_part_thickx-1,base_part_thick*0.6,base_part_thickx-1];
fan_duct_screwp = [15.4, 24.9, 12.8];
fan_duct_screw = axscrew(M2p5_cap_screw,material=MaterialBlackSteel);
fan_duct_screws = [ for (p=[fan_duct_screwp,[-fan_duct_screwp.x,fan_duct_screwp.y,fan_duct_screwp.z]])
	axxscrew_setLeng(fan_duct_screw,thick=fan_duct_screw_tapsize.y*2,t=p,r=[90,0,180],twist=30,depth=0,nut_depth=0,nut_spacing=1,horizontal=true)
];
fan_duct_holderp = fan_duct_screwp-[fan_duct_screw_tapsize.x/2, fan_duct_screw_tapsize.y, fan_duct_screw_tapsize.z/2];
fan_holdert = base_part_thick;
fan_holderw = base_part_thickx;

module mosquito_fan_duct_stl() {
	// Remix of https://www.thingiverse.com/thing:4217188
	// widened 2*widen to allow more room for having the hoten turned 90 degrees
	// remove orignal holder and add two new ones
	
	module fanslice(x1,x2) {
		difference() {
			translate([125.0, 123, 0]) rotate([0, 0, 180])
				import("../extparts/RHD_BMG_Mosquito_Fan_Shroud.stl", convexity = 10);
			translate([x1-50,-50,-5]) cube([50,100,40]);
			translate([x2,-50,-5]) cube([50,100,40]);
		}
	}
	
	widen = 1;

	stl("mosquito_fan_duct");
	color(partColor) {
		difference() {
			// expand two thin slices
			union() {
				widen = 1;
				x2 = 10.2;
				x3 = 11;
				f = (1+x3-x2)/(x3-x2);
				fanslice(-x2, x2);
				translate([x3*f-x3-widen+0.01, 0, 0]) scale([f, 1, 1]) fanslice(-x3, -x2);
				translate([-widen+0.02, 0, 0]) fanslice(-30, -x3);
				translate([-x3*f+x3+widen-0.01, 0, 0]) scale([f, 1, 1]) fanslice(x2, x3);
				translate([widen-0.02, 0, 0]) fanslice(x3, 30);
			}
			// remove old holder
			difference() {
				translate([10, 17, 10.001]) cube([15, 10, 10]);
				translate([14.6, 18, 2.45])
					rotate([0, -60, 0])
						cube([base_part_thickx, base_part_thickx*2, base_part_thickx]);
				translate([5.1, 25.9, 5.01])
					rotate([45, 0, 0])
						cube([base_part_thickx, base_part_thickx*2, base_part_thickx]);
				translate([5.05, 20.315, 5]) cube([base_part_thickx, base_part_thickx, base_part_thickx]);
			}
			*translate([-50,-50,9]) cube([100,100,50]); // to look inside
		}
		// new holders
		for (i = [0, 1])
			mirror([i, 0, 0])
				_fan_duct_holder();
		// correct inner flow
		translate([6.5, 20.25, 0])
			rotate([0, 0, -35])
				cube([6, 1, 9.5]);
		// cover text at bottom
		translate([-14,20,0]) cube([28,11,0.5]);
		translate([-10,30,0]) cube([20,5,0.5]);
	}
}

module _fan_duct_holder(zd=0) {
	difference() {
		translate(fan_duct_holderp)
			difference() {
				cube(fan_duct_screw_tapsize+[0,0,zd]);
				translate([-0.1, -1, -0.2])
					cube([1, base_part_thickx+2, 1]);
			}
		xxscrew_hole(fan_duct_screws[0]);
	}
}

module fan_duct_holder(zd=0) {
	difference() {
		_fan_duct_holder(zd);
		translate(fan_duct_holderp) {
			translate([-7.802,-1,-5+part_assemble_nudge])
				rotate([0, 30, 0])
					cube([10, 10, 10]);
			translate([-0.1,-0.1,-fan_duct_screw_tapsize.z+part_assemble_nudge*2])
				cube(fan_duct_screw_tapsize+[0.2,0.2,0]);
		}
	}
}

module _blower_at_base() {
	translate([blower_exit(blower)/2,0,blower_depth(blower)])
		rotate([0,180,0])
			blower(blower);
}
module blower_at_duct() {
	translate(blowert)
		rotate(blowerr)
			_blower_at_base();
}

module fan_holder() {
	sp = blower_screw_holes(blower)[0];
	x = blower_exit(blower)/2-sp.x-fan_holderw/2;
	x2 = fan_duct_screwp.x+fan_duct_screw_tapsize.x/2;
	hy = fan_duct_screw_tapsize.y+part_assemble_nudge/2;
	difference() {
		union() {
			translate(blowert)
				rotate(blowerr)
					translate([x, 0, blower_depth(blower)])
						difference() {
							union() {
								cube([fan_holderw, sp.y, fan_holdert]);
								translate([fan_holderw/2, sp.y, 0])
									cylinder(fan_holdert, d = fan_holderw);
								translate([-x2-x, -fan_capd, fan_capt])
									cube([x2*2, fan_capd*2.5, fan_holdert-fan_capt]);
							}
							translate([-1, -1, -1])
								cube([fan_holderw+2, fan_capd+part_assemble_nudge*2+1, fan_capt+1]);
						}
			for (i = [0, 1])
				mirror([i, 0, 0])
					translate([0,hy,0])
						fan_duct_holder(0.5);
		}
		translate([-x2-1, fan_duct_holderp.y+hy-fan_duct_screw_tapsize.y*2, fan_duct_screw_tapsize.z-1])
			cube([x2*2+2, fan_duct_screw_tapsize.y*2, fan_duct_screw_tapsize.z*3]);
	}
}

fan_holder();
*translate([0,fan_duct_screw_tapsize.y-part_assemble_nudge/2,0]) fan_duct_holder(1);
blower_at_duct();
translate(blowert)rotate(blowerr)cube([1,3.5,1]);
mosquito_fan_duct_stl();


