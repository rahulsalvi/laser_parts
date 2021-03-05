$fn = 100;

frame_hole_d = 5.10; // mm
rpi_hole_d   = 2.75; // mm
rpi_len = 85.0; // mm
rpi_wid = 56.0; // mm
hole_d_offset = 1; // mm (to account for laser machine accuracy)

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

module rpi_hole_pattern() {
    union() {
        hole_d = rpi_hole_d + hole_d_offset;
        translate([3.5, 3.5]) circle(d=hole_d);
        translate([3.5, 3.5+49]) circle(d=hole_d);
        translate([3.5+58, 3.5]) circle(d=hole_d);
        translate([3.5+58, 3.5+49]) circle(d=hole_d);
    }
}

module frame_mounts() {
    difference() {
        hull() {
            circle(d=frame_hole_d*3);
            translate([rpi_len + frame_hole_d*2, 0]) circle(d=frame_hole_d*3);
        }
        circle(d=frame_hole_d+hole_d_offset);
        translate([rpi_len + frame_hole_d*2, 0]) circle(d=frame_hole_d+hole_d_offset);
    }
}

translate([frame_hole_d*3, 5]) difference() {
    union() {
        translate([rpi_len/2, rpi_wid/2]) rounded_rect([rpi_len+4, rpi_wid+4], 3.0);
        translate([-frame_hole_d, 3.5]) frame_mounts();
    }
    rpi_hole_pattern();
}
