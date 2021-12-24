$fn = 100;

bolt_hole_d = 4.75; // mm

fan_size = [165, 165]; // mm
fan_hole_spacing = 124.5; // mm

gasket_width = 2; // mm

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

linear_extrude(gasket_width) {
    translate(fan_size / 2) difference() {
        rounded_rect(fan_size, 40);
        circle(d=145);
        translate([+fan_hole_spacing/2, +fan_hole_spacing/2]) circle(d=bolt_hole_d);
        translate([+fan_hole_spacing/2, -fan_hole_spacing/2]) circle(d=bolt_hole_d);
        translate([-fan_hole_spacing/2, +fan_hole_spacing/2]) circle(d=bolt_hole_d);
        translate([-fan_hole_spacing/2, -fan_hole_spacing/2]) circle(d=bolt_hole_d);
    }
}
