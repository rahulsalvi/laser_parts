$fn = 100;

screw_hole_d = 4.75; // mm
hole_d_offset = 0.5; // mm (to account for laser machine accuracy)

fan_size = [140, 140]; // mm
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

module honeycomb() {
    hexagon_d = 9;
    for (j = [0:2:15]) {
        for (i = [0:14]) {
            translate([i*hexagon_d, j*hexagon_d]) rotate(90) circle(d=hexagon_d-1.5, $fn=6);
        }
        for (i = [0:15]) {
            translate([i*hexagon_d - hexagon_d/2, (j+1)*hexagon_d]) rotate(90) circle(d=hexagon_d-1.5, $fn=6);
        }
    }
}

union() {
difference() {
    union() {
        translate(fan_size / 2) difference() {
            rounded_rect(fan_size, 3);
            circle(d=128);
        }
        difference() {
            translate(fan_size/2) rounded_rect(fan_size, 3);
            translate([2.5+4.5, 2.5+4.5]) honeycomb();
        }
    }
    translate(fan_size / 2) union() {
        translate([+fan_hole_spacing/2, +fan_hole_spacing/2]) circle(d=screw_hole_d + hole_d_offset);
        translate([+fan_hole_spacing/2, -fan_hole_spacing/2]) circle(d=screw_hole_d + hole_d_offset);
        translate([-fan_hole_spacing/2, +fan_hole_spacing/2]) circle(d=screw_hole_d + hole_d_offset);
        translate([-fan_hole_spacing/2, -fan_hole_spacing/2]) circle(d=screw_hole_d + hole_d_offset);
    }
}
}
