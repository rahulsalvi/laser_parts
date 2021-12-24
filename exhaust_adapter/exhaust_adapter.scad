$fn = 100;

bolt_hole_d = 4.75; // mm

fan_size = [165, 165]; // mm
fan_hole_spacing = 124.5; // mm

module rounded_rect(dim, fillet_r) {
    x = dim.x / 2 - fillet_r;
    y = dim.y / 2 - fillet_r;
    hull() {
        translate([ x,  y]) circle(r = fillet_r);
        translate([ x, -y]) circle(r = fillet_r);
        translate([-x,  y]) circle(r = fillet_r);
        translate([-x, -y]) circle(r = fillet_r);
    }
}

// TODO set slope angle to 30 degrees to make it easier to print
// TODO parameterize everything
// TODO measure true OD to fit into HVAC tube
// TODO check fitment against gasket
// TODO convert cylinder radii to diameters (for ease of reading)
// TODO turn bolt holes into hexagon to fit a nut instead

difference() {
    union() {
        intersection() {
            linear_extrude(100) rounded_rect(fan_size, 40);
            cylinder(70, 165*sqrt(2)/2, 101.6/2);
        }
        cylinder(100, r=101.6/2);
    }
    cylinder(70, 145/2, (101.6/2)-10);
    cylinder(100, r=(101.6/2)-10);
    translate([+fan_hole_spacing/2, +fan_hole_spacing/2]) cylinder(70, d=bolt_hole_d);
    translate([+fan_hole_spacing/2, -fan_hole_spacing/2]) cylinder(70, d=bolt_hole_d);
    translate([-fan_hole_spacing/2, +fan_hole_spacing/2]) cylinder(70, d=bolt_hole_d);
    translate([-fan_hole_spacing/2, -fan_hole_spacing/2]) cylinder(70, d=bolt_hole_d);
    translate([0, 0, 2]) {
        translate([+fan_hole_spacing/2, +fan_hole_spacing/2]) cylinder(70, d=bolt_hole_d+10);
        translate([+fan_hole_spacing/2, -fan_hole_spacing/2]) cylinder(70, d=bolt_hole_d+10);
        translate([-fan_hole_spacing/2, +fan_hole_spacing/2]) cylinder(70, d=bolt_hole_d+10);
        translate([-fan_hole_spacing/2, -fan_hole_spacing/2]) cylinder(70, d=bolt_hole_d+10);
    }
}
