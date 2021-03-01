include <../cevo2.scad>
include <../../../xNopSCADlib/xxVitamins/xxscrews.scad>
include <NopSCADlib/vitamins/fans.scad>
include <../extparts/mosquito_hotend.scad>

fan = fan25x10;

fanscrew = axscrew(M2p5_cap_screw,material=MaterialBlackSteel);
fanHolderScrews = [ for(p = mosquito_hotend_fan_screwps)
    axxscrew_setLeng(fanscrew,t=p+[0,-fan_depth(fan),0],r=[90,0,0],thick=fan_depth(fan)+mosquito_hotend_size.y,depth=0,nut_depth=0) ];

module hotend_assembly() assembly("hotend") {
    mosquito_hotend();
    explode([0,-10,0],explode_children=true) {
        translate([0, -fan_depth(fan)/2-mosquito_hotend_size.y/2, -fan_width(fan)/2])rotate([90, 0, 0]) fan(fan);
        xxside1(fanHolderScrews);
    }
    xxside2(fanHolderScrews);
 }

hotend_assembly();





