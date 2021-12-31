include <../cevo2.scad>


module holder_tube(h, d1, d2, dz = 0, rx = 0, ry = 0, sh = 0, sx = 0, sd = 8, nsd = 0, st = 0) {
	rotate([rx, ry, 0])
		translate([0, 0, - dz])
			cylinder(h, d1 = d1, d2 = d2);
	if (nsd && show_supports()) let (
		se = 0.4,
		sr = - atan(sin(rx) / (sin(ry) * cos(rx))),
		cr = acos(cos(ry) * cos(rx)),
		ca = (cos(ry) * cos(rx))/sin(cr),
		coa = ca + (d1 - d2) / h * (st?-1:1),
		x = -sin(cr)*(dz-(st?h:0)) + cos(cr)*(st?-d2:d1)/2,
		y = -cos(cr)*(dz-(st?h:0)) - sin(cr)*(st?-d2:d1)/2,
		shy = (st?-1:1)*(sh-y),
		sw = shy / coa
	) {
		echo(h = h, sh = sh, ca = ca, coa = coa, cr = cr, x=x, y=y, sw = sw);
		for (ssd = [(nsd-1)/2*-sd:sd:(nsd-1)/2*sd]) {
			difference() {
				union() {
					rotate([0, 0, sr])
						translate([x-(st?sw:0), -se/2-0.15+ssd, y-(st?shy:0)])
							cube([sw, se+0.3, shy]);
					difference() {
						rotate([0, 0, sr])
							translate([x-(st?sw:0), -se*2.5+ssd, y-(st?shy:0)])
								cube([sw, se*5, shy]);
						rotate([rx, ry, 0])
							translate([0, 0, - dz])
								cylinder(h, d1 = d1+se*2, d2 = d2+se*2);
					}
				}
				rotate([0, 0, sr]) {
					translate([x+(st?0:sw)-sx, -se*5+ssd, y-(st?shy:0)])
						cube([sx, se*10, shy]);
					if (st)
						translate([0, 0, 0])
							rotate([0, cr, 0])
								translate([0, -se*3+ssd, y-h])
									cube([sw, se*6, h]);
					else
						translate([x, 0, 0])
							rotate([0, cr, 0])
								translate([-sw, -se*3+ssd, y])
									cube([sw, se*6, h]);
				}
			}
		}
	}
}

//$preview=0;
*translate([0, 0, 0])
	holder_tube( h = 20 * 3, d1 = 20, d2 = 20 - 3, dz = 20,
		ry = 45, sh = 0, nsd = 1, st = 1);
