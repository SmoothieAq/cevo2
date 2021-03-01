include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame32_assembly.scad>
include <../extparts/mosquito_hotend.scad>
use <../parts/mosquito_fan_duct.scad>
use <../parts/carriage.scad>

carriage_x = xrail_carriage(rail_x);
cl = carriage_length(carriage_x);
cw = carriage_width(carriage_x);
ch = carriage_height(carriage_x);


module frame33_assembly() assembly("frame33") {
    frame32_assembly();
    translate([pos_x,pos_y-cw/2-mosquito_hotend_size.y/2-mosquito_hotend_offy,xrail_z+ch]) translate([0,0,-mosquito_hotend_fanz]) {
        xxside1(fan_screws());
        explode([0,10,0],explode_children=true) {
            blower_at_duct();
            xxside2(fan_screws());
        }
    }
 }

frame33_assembly();



