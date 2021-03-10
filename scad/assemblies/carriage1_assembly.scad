include <../cevo2.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
include <../extparts/mosquito_hotend.scad>
use <../parts/carriage.scad>


module carriage1_assembly() assembly("carriage1") {
    carriage_stl();
    xxside1(hotend_screws());
    explode([0,0,-10],explode_children=true) {
        mosquito_hotend();
        explode([0,0,-3]) xxside2(hotend_screws());
    }
 }

carriage1_assembly();





