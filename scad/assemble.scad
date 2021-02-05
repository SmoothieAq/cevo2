include <cevo2.scad>
include <defs/base_defs.scad>

use <assemblies/frame.scad>
use <assemblies/y_assembly.scad>
use <assemblies/x_assembly.scad>
use <assemblies/bed.scad>
use <assemblies/loops.scad>
use <assemblies/leads.scad>

module main_assembly() assembly("main") {
//    frame_assembly();
    y_assembly();
    x_assembly();
//    loops_assembly();
//    leads_assembly();
//    bed_assembly();
}

main_assembly();



