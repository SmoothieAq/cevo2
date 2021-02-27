include <cevo2.scad>

rw = 0.8;
e = 0.6;

t1 = 2;
t2 = 4;
t3 = 20;

l = 150;
w = 100;
h = 45;
s = t3;

color([0.22,0.22,0.22]) {
	difference() {
		translate([0,0,h-t2])
			cube([w, l, t2]);
		translate([0, 0, h-e])
			linear_extrude(e*2)
				rings(150, 100, 25);
	}
	for (i = [s/4,w-s/4], j = [s/4,l-s/4])
		translate([i,j,0]) {
			cylinder(h+t1, d = t3);
			rotate([]) difference() {
				translate([t3/4, 0, h-8])
					rotate([0, 90, 0])
						cylinder(w-t3/2, d = t3);
				translate([0, -t3/2, h])
					cube([i<s?w:l, t3, t3]);
			}
		}
}

module rings(l,w,s) {
	function sl(l) = [for (i = [s/2:s:l-s/2]) i];
	sl = sl(l);
	sw = sl(w);
	function ij(i, j) = i*len(sw)+j;
	ssn = len(sl)*len(sw);
	rrs = rands(s/3, s*0.7, ssn);
	irs = rands(-s/2, s/2, ssn);
	jrs = rands(-s/2, s/2, ssn);

	for (i = [0:len(sw)-1], j = [0:len(sl)-1])
	translate([sw[i]+irs[ij(i, j)], sl[j]+jrs[ij(i, j)], 0])
		ring(rrs[i*j]);
}

module ring(r) {
	difference() {
		circle(r = r);
		circle(r = r-rw);
	}
}