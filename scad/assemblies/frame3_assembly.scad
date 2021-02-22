include <../cevo2.scad>
include <../defs/base_defs.scad>
include <../defs/leads_defs.scad>

use <frame2_assembly.scad>
use <../parts/bed_holder.scad>


module frame3_assembly() pose(a=[ 55.00, 0.00, 25.00 ],t=[ 199.55, 311.41, 440.28 ],d=1386.15,exploded=true) assembly("frame3") {
    frame2_assembly();
    for (i = [0:2]) {
        bp = holder_bedp(i);
        l = holder_tub1l(i);
        lc = holder_thick2*0.5+0.5;
        a = holder_tub1a(i);
        explode(extr_d2, explode_children = true)
            translate([bp.x,bp.y,pos_z-bed.z-bed_off-holder_thick2/2])
                rotate([0,90,a])
                    translate([0,0,l/2])
                        tubing(holder_tube, length=l-lc*2);
        for_leads(i, pos_z-bed.z-holder_thick1-holder_offz-bed_off)
            rotate([0, 0, holder_a(i)-i*90]) {
                explode(extr_d2+5, explode_children=true) {
                    if (i == 0) {bed_holderL1_stl();}
                    if (i == 1) {bed_holderF1_stl();}
                    if (i == 2) {bed_holderB1_stl();}
                    xxside1(bed_holder_screws(i));
                }
                xxside2(bed_holder_screws(i));
            }
    }
}

frame3_assembly();



