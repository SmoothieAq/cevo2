include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame33_assembly.scad>
use <hotend_assembly.scad>
include <../extparts/mosquito_hotend.scad>
use <../parts/carriage.scad>

carriage_x = xrail_carriage(rail_x);
cl = carriage_length(carriage_x);
cw = carriage_width(carriage_x);
ch = carriage_height(carriage_x);


module frame34_assembly() assembly("frame34") {
    frame33_assembly();
    translate([pos_x,pos_y-cw/2-mosquito_hotend_size.y/2-mosquito_hotend_offy,xrail_z+ch]) {
        explode([0,0,-15],explode_children=true)
            hotend_assembly();
        xxside1(hotend_screws());
    }
 }

frame34_assembly();



