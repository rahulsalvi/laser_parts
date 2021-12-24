$fn = 100;

use <rahulsalvi/rounded_rect.scad>

difference() {
    rounded_rect([16, 19], 1);
    rounded_rect([8, 10], 2.5);
    translate([0, 11]) square([4, 10], center=true);
    translate([0, -11]) square([4, 10], center=true);
}
