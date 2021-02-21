include <../cevo2.scad>
include <../defs/leads_defs.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
use <leads1_assembly.scad>
use <bed1_assembly.scad>

module leads2_assembly() assembly("leads2") {
	leads1_assembly();
	explode(60) bed1_assembly();
}

leads2_assembly();
