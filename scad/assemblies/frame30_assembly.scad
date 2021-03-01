include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame22_assembly.scad>
include <../extparts/mosquito_hotend.scad>
use <../parts/carriage.scad>

carriage_x = xrail_carriage(rail_x);
cl = carriage_length(carriage_x);
cw = carriage_width(carriage_x);
ch = carriage_height(carriage_x);


module frame30_assembly() assembly("frame30") {
    frame22_assembly();
    translate([pos_x,pos_y-cw/2-mosquito_hotend_size.y/2-mosquito_hotend_offy,xrail_z+ch]) {
        carriage_stl();
        xxside1(carriage_screws());
    }
 }

frame30_assembly();



