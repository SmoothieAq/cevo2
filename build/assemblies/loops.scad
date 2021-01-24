include <../cevo2.scad>
include <../defs/loops_defs.scad>

module loops_assembly() {assembly("loops");

	for (loop = loops) {
		translate([0, 0, loop.x]) {
			for (p = loop.y)
			translate([p.x, p.y, 0])
				pulley_assembly(p.z);
			belt(GT2x6, [for (p = loop.y) [p.x, p.y, p[3] * pulley_pr(p[2])]]);
		}
	}


	for (loop = loops)
	let(
		z = loop[0],
		p1 = loop[1][0]
	) translate([p1.x, p1.y, z - pulley_height(p1.z) - motor_nudge]) NEMA(motor);
}

loops_assembly();