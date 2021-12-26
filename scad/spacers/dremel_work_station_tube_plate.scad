include <../cevo2.scad>
include <../defs/loops_defs.scad>

h=28;
d=10.08;
s=axscrew(M3_cap_screw,30);

module dremel_work_station_tupe_plate1() {
	rotate([90,0,0]) difference() {
		cube([50, 15, h+d/2]);
		translate([25, -1, h+d/2]) rotate([-90, 0, 0]) cylinder(20, d = d);
		translate([5, -1, 5]) cube([40, 20, h-10]);
		translate([15,15/2,h+d+12]) xscrew_hole(s, horizontal = true);
		translate([50-15,15/2,h+d+12]) xscrew_hole(s, horizontal = true);
	}
}
*dremel_work_station_tupe_plate1();

module dremel_work_station_tupe_plate2() {
	difference() {
		dremel_work_station_tupe_plate1();
		translate([-1,-25,-1]) cube([52,46,17]);
	}
}
dremel_work_station_tupe_plate2();
