include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
use <leads1_assembly.scad>
use <bed1_assembly.scad>

module leads2_assembly() pose(a=[ 55.00, 0.00, 25.00 ],t=[ 49.90, 298.34, 356.04 ],d=932.74,exploded=true) assembly("leads2") {
	leads1_assembly();
	explode(60) bed1_assembly();
}

leads2_assembly();
