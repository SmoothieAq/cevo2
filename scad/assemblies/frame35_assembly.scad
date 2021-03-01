include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame34_assembly.scad>
include <../extparts/mosquito_hotend.scad>
include <../extparts/orbiter_extruder.scad>
//use <../parts/mosquito_fan_duct.scad>
use <../parts/carriage.scad>

carriage_x = xrail_carriage(rail_x);
cl = carriage_length(carriage_x);
cw = carriage_width(carriage_x);
ch = carriage_height(carriage_x);


module frame35_assembly() assembly("frame35") {
    frame34_assembly();
    translate([pos_x,pos_y-cw/2-mosquito_hotend_size.y/2-mosquito_hotend_offy,xrail_z+ch]) {
        xxside2(extruder_screws());
        explode([0,0,30],explode_children=true) {
            translate([0,0,carriage_platet()]) orbiter_extruder();
            xxside1(extruder_screws());
        }
    }
 }

frame35_assembly();



