include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/loops_defs.scad>

use <frame30_assembly.scad>
include <../extparts/mosquito_hotend.scad>
use <../parts/mosquito_fan_duct.scad>
use <../parts/carriage.scad>

carriage_x = xrail_carriage(rail_x);
cl = carriage_length(carriage_x);
cw = carriage_width(carriage_x);
ch = carriage_height(carriage_x);


module frame31_assembly() assembly("frame31") {
    frame30_assembly();
    translate([pos_x,pos_y-cw/2-mosquito_hotend_size.y/2-mosquito_hotend_offy,xrail_z+ch]) {
        explode([0,3,-15],explode_children=true) translate([0,0,-mosquito_hotend_fanz]) {
            mosquito_fan_duct_stl();
            xxside1(fan_duct_screws());
            xxside2(fan_duct_screws());
        }
        explode([0,15,-3])
            fan_holder_at_carriage();
        xxside1(fan_holder_screws());
        xxside2(fan_holder_screws());

    }
 }

frame31_assembly();



