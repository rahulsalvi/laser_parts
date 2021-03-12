use <rahulsalvi/rounded_rect.scad>

$fn = 100;

controller_hole_spacing = [93.975, 39.5];

module honeycomb() {
    hexagon_d = 10;
    for (j = [0:2:1]) {
        for (i = [0:8]) {
            translate([i*hexagon_d, j*hexagon_d]) rotate(90) circle(d=hexagon_d-1.5, $fn=6);
        }
        for (i = [0:9]) {
            translate([i*hexagon_d - hexagon_d/2, (j+1)*hexagon_d]) rotate(90) circle(d=hexagon_d-1.5, $fn=6);
        }
    }
}

difference() {
    union() {
        translate([0, 12.5]) difference() {
            rounded_rect([110, 105], 3);
            translate([0, 22.5]) rounded_rect([100, 10], 3);
            translate([-40, 35]) honeycomb();
        }
        translate([0, -(controller_hole_spacing.y/2 + 17.5)]) difference() {
            rounded_rect([110 + 20 + 20, 12.5], 3);
            translate([+controller_hole_spacing.x/2 + 20, 0]) circle(d=6.0);
            translate([-controller_hole_spacing.x/2 - 20, 0]) circle(d=6.0);
        }
    }
    translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) circle(d=4.0);
    translate([+controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) circle(d=4.0);
    translate([-controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) circle(d=4.0);
    translate([-controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) circle(d=4.0);
}
