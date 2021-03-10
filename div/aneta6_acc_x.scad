
difference() {
	cube([26,10,4]);
	for (x= [5.5,20.5])
		translate([x,2.5,-1]) {
			cylinder(6,d=3.5,$fn=12);
			cylinder(3.5,d=7,$fn=6);
		}
}
translate([-2,-1,0]) cube([4,1.1,6]);
translate([-10,-1,0]) cube([4,1.1,6]);
translate([0,0,0]) cube([2,1,8]);
translate([-10,0,0]) cube([2,1,8]);
translate([-10,-1,5.9]) cube([12,1.1,2.2]);
translate([-10,-1,7.9]) cube([12,2,2.1]);
