include <cevo2.scad>
include <defs/base_defs.scad>
include <defs/loops_defs.scad>
use <../../xNopSCADlib/xVitamins/xbelt.scad>


	*for (loop = loops) {
		translate([0, 0, loop.x]) {
			belt(GT2x6, [for (p = loop.y) [p.x, p.y, p[3] * pulley_pr(p[2])]]);
		}
	}

loop = loops[0];
*translate([0, 0, loop.x]) {
	belt(belt, [for (p = loop.y) [p.x, p.y, p[3] * pulley_pr(p[2])]]);
}
*translate([0, 0, loop.x-15]) {
	xbelt(belt, [for (p = loop.y) [p.x, p.y, p[3] * pulley_pr(p[2])]]);
}
for (ps = pullies) {
translate([0, 0, ps.x-30]) {
	xbelt(belt, ps.y, open = true, start_twist = ps.z, tooth_colour = [0.35,0.15,0.18]);
	for (p = ps.y)
		if (is_list(p.z)) translate([p.x, p.y, pulley_offset(p.z)]) pulley(p.z);
		//else if (p.z) translate([p.x, p.y, -belt_width(belt)/2]) #cylinder(belt_width(belt),r=abs(p.z));
}}

*translate([0, 0, loop.x+15]) {
	ps = loop.y;
	belt(belt, [for (i = [0:1]) let(p = ps[i]) [p.x, p.y, p[3] * pulley_pr(p[2])]], gap=90,gap_pos=[frame_p2.x+loops_side_off+pulley_ir(idler) + belt_pitch_height(belt),150,90],belt_colour = grey(20), tooth_colour = "red");
}

