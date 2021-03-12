$fn = 100;

use <rahulsalvi/rounded_rect.scad>

// for shorter y axis bracket
hole_to_cutout_spacing = 25; // mm

// for longer x axis bracket
// hole_to_cutout_spacing = 47.5; // mm

total_length = hole_to_cutout_spacing + 12.5;

hole_to_hole_spacing = 20; // mm
total_width = hole_to_hole_spacing + 12.5;

difference() {
    rounded_rect([total_width, total_length], 3);
    translate([0, hole_to_cutout_spacing / 2]) rounded_rect([total_width - 6, 5], 1);
    translate([hole_to_hole_spacing / 2, -hole_to_cutout_spacing / 2]) circle(d=6);
    translate([-hole_to_hole_spacing / 2, -hole_to_cutout_spacing / 2]) circle(d=6);
}
