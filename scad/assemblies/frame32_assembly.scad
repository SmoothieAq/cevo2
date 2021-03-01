include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame31_assembly.scad>
include <../extparts/mosquito_hotend.scad>
use <../parts/mosquito_fan_duct.scad>
use <../parts/carriage.scad>

carriage_x = xrail_carriage(rail_x);
cl = carriage_length(carriage_x);
cw = carriage_width(carriage_x);
ch = carriage_height(carriage_x);


module frame32_assembly() assembly("frame32") {
    frame31_assembly();
    translate([pos_x,pos_y-cw/2-mosquito_hotend_size.y/2-mosquito_hotend_offy,xrail_z+ch]) {
        xxside1(bltouch_screws());
        explode([5,5,-5],explode_children=true) {
            bltouch_at_carriage();
            xxside2(bltouch_screws());
        }
    }
 }

frame32_assembly();



