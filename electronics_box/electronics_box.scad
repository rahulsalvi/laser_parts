$fn = 100;

use <rahulsalvi/rounded_rect.scad>

controller_hole_spacing = [95, 40]; // mm
rpi_hole_spacing = [49, 58]; // mm
controller_size = [105, 50]; // mm
breadboard_size = [54.5, 82]; // mm

center_gap = 30; // mm
rpi_outer_gap = [15, 20]; // mm

plate_thickness = 3; // mm

total_size = [
    controller_hole_spacing.x + 25,
    breadboard_size.y + 40,
    plate_thickness
    ];

controller_offset = [(total_size.x-controller_size.x)/2, 12]; // mm
breadboard_offset = [total_size.x-breadboard_size.x-20, total_size.y-breadboard_size.y-5]; // mm

standoff_hole_d = 2.7; // mm

echo(total_size / 25.4);

outer_standoff_hole_offset = 5; // mm

// TODO m5 mounting holes
// TODO rough idea of outer cage
// TODO speed holes

module quarter_ring(id, od) {
    intersection() {
        difference() {
            circle(d=od);
            circle(d=id);
        }
        square([od,od]);
    }
}

module rpi3() {
    import("Raspberry Pi 3 Light Version.STL");
}

module controller() {
    translate(controller_size/2) linear_extrude(23) difference() {
        square(controller_size, center=true);
        translate([controller_hole_spacing.x/2, controller_hole_spacing.y/2]) circle(d=3);
        translate([controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) circle(d=3);
        translate([-controller_hole_spacing.x/2, controller_hole_spacing.y/2]) circle(d=3);
        translate([-controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) circle(d=3);
    }
}

module breadboard() {
    cube(concat(breadboard_size, 10));
    translate([breadboard_size.x/2-9,breadboard_size.y-40,10]) cube([18, 40, 6]);
}

module standoff(height) {
    linear_extrude(height) circle(d=5.5, $fn=6);
}

module fan() {
    translate([20,20,10]) difference() {
        cube([40,40,20], center=true);
        translate([16,16]) cylinder(20, d=3.5, center=true);
        translate([16,-16]) cylinder(20, d=3.5, center=true);
        translate([-16,16]) cylinder(20, d=3.5, center=true);
        translate([-16,-16]) cylinder(20, d=3.5, center=true);
    }
}

module standoff_hole_cutout() {
    countersink_depth = 1.8; // mm
    cylinder(countersink_depth, d=4.2);
    translate([0,0,countersink_depth]) cylinder(plate_thickness - countersink_depth, d=standoff_hole_d);
}

module m5_hole_cutout() {
    countersink_depth = plate_thickness/2; // mm
    cylinder(plate_thickness - countersink_depth, d=5.2);
    translate([0,0,plate_thickness-countersink_depth]) cylinder(countersink_depth, d=9.7);
}

module controller_cutout() {
    translate(controller_size/2) union() {
        translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) standoff_hole_cutout();
        translate([+controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) standoff_hole_cutout();
        translate([-controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) standoff_hole_cutout();
        translate([-controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) standoff_hole_cutout();
    }
}

module breadboard_cutout() {
    translate([0,0,plate_thickness/2]) linear_extrude(plate_thickness/2) {
        offset(r=1.5) square(breadboard_size);
    }
}

module bottom_plate() {
    difference() {
        translate(total_size/2) linear_extrude(total_size.z, center=true) rounded_rect(total_size, 3);
        // outer standoff holes
        union() {
            translate([outer_standoff_hole_offset, outer_standoff_hole_offset, 0]) standoff_hole_cutout();
            translate([total_size.x - outer_standoff_hole_offset, outer_standoff_hole_offset, 0]) standoff_hole_cutout();
            translate([outer_standoff_hole_offset, total_size.y - outer_standoff_hole_offset, 0]) standoff_hole_cutout();
            translate([total_size.x - outer_standoff_hole_offset, total_size.y - outer_standoff_hole_offset, 0]) standoff_hole_cutout();
        }
        // controller mount holes
        translate(controller_offset) controller_cutout();
        translate(breadboard_offset) breadboard_cutout();
        // rpi mount holes
        *union() {
            translate([total_size.x - rpi_outer_gap.x, total_size.y/2 - rpi_hole_spacing.y/2]) standoff_hole_cutout();
            translate([total_size.x - rpi_outer_gap.x, total_size.y/2 + rpi_hole_spacing.y/2]) standoff_hole_cutout();
            translate([total_size.x - rpi_outer_gap.x - rpi_hole_spacing.x, total_size.y/2 - rpi_hole_spacing.y/2]) standoff_hole_cutout();
            translate([total_size.x - rpi_outer_gap.x - rpi_hole_spacing.x, total_size.y/2 + rpi_hole_spacing.y/2]) standoff_hole_cutout();
        }
        *union() {
            translate([controller_offset.x+5, total_size.y/2]) m5_hole_cutout();
            translate([controller_offset.x+controller_size.x-5, total_size.y/2]) m5_hole_cutout();
            translate([total_size.x-20, total_size.y/2]) m5_hole_cutout();
        }
    }
    // locating pins
    *translate([0,0,plate_thickness]) union() {
        translate([2.5,2.5,0])                             cylinder(2, d1=2, d2=1.9);
        translate([2.5,total_size.y-2.5,0])                cylinder(2, d1=2, d2=1.9);
        translate([total_size.x - 2.5,2.5,0])              cylinder(2, d1=2, d2=1.9);
        translate([total_size.x - 2.5,total_size.y-2.5,0]) cylinder(2, d1=2, d2=1.9);
        translate([total_size.x/2,2.5])                    cylinder(2, d1=2, d2=1.9);
        translate([total_size.x/2,total_size.y-2.5])       cylinder(2, d1=2, d2=1.9);
        translate([2.5,total_size.y/2])                    cylinder(2, d1=2, d2=1.9);
        translate([total_size.x-2.5,total_size.y/2])       cylinder(2, d1=2, d2=1.9);
    }
}

module middle_plate() {
    rpi_plate_size = rpi_hole_spacing + [6,6];
    rpi_plate_offset_x = controller_size.x-rpi_plate_size.x-12.5;
    rpi_plate_offset_y = 22.5;
    linear_extrude(plate_thickness) difference() {
        offset(r=+3) offset(delta=-3)
        offset(r=-3) offset(delta=+3)
        union() {
            difference() {
                square(controller_size);
                /* translate([rpi_plate_offset_x-3,0]) square([rpi_plate_size.x+6,controller_size.y]); */
            }
            translate([rpi_plate_offset_x,rpi_plate_offset_y]) square(rpi_plate_size);
        }
        translate(controller_size/2) union() {
            translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) circle(d=standoff_hole_d);
            translate([+controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) circle(d=standoff_hole_d);
            translate([-controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) circle(d=standoff_hole_d);
            translate([-controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) circle(d=standoff_hole_d);
        }
        translate(rpi_plate_size/2 + [rpi_plate_offset_x,rpi_plate_offset_y]) {
            translate([+rpi_hole_spacing.x/2, +rpi_hole_spacing.y/2]) circle(d=standoff_hole_d);
            translate([+rpi_hole_spacing.x/2, -rpi_hole_spacing.y/2]) circle(d=standoff_hole_d);
            translate([-rpi_hole_spacing.x/2, +rpi_hole_spacing.y/2]) circle(d=standoff_hole_d);
            translate([-rpi_hole_spacing.x/2, -rpi_hole_spacing.y/2]) circle(d=standoff_hole_d);
        }
    }
}

module side_plate() {
    difference() {
        linear_extrude(3) {
            offset(r=-3) offset(delta=+3)
            difference() {
                offset(r=+3) offset(delta=-3)
                square([total_size.x, total_size.y]);
                offset(delta=-plate_thickness) square([total_size.x, total_size.y]);
            }
            translate([total_size.x/2,2.5]) circle(d=4);
            translate([total_size.x/2,total_size.y-2.5]) circle(d=4);
            translate([2.5,total_size.y/2]) circle(d=4);
            translate([total_size.x-2.5,total_size.y/2]) circle(d=4);
        }
        *union() {
            translate([2.5,2.5,0]) cylinder(2, d=2);
            translate([2.5,total_size.y-2.5,0]) cylinder(2, d=2);
            translate([total_size.x - 2.5,2.5,0]) cylinder(2, d=2);
            translate([total_size.x - 2.5,total_size.y-2.5,0]) cylinder(2, d=2);
            translate([total_size.x/2,2.5]) cylinder(2, d=2);
            translate([total_size.x/2,total_size.y-2.5]) cylinder(2, d=2);
            translate([2.5,total_size.y/2]) cylinder(2, d=2);
            translate([total_size.x-2.5,total_size.y/2]) cylinder(2, d=2);
        }
    }
}

module captured_standoff() {
    difference() {
        circle(d=8);
        offset(r=+0.5) offset(delta=-0.5) circle(d=5.5, $fn=6);
    }
}

module side_plate2() {
    translate(total_size/2) linear_extrude(plate_thickness, center=true)
    difference() {
        union() {
            difference() {
                rounded_rect(total_size, 3);
                rounded_rect(total_size-[6,6], 3);
            }
            translate([-total_size.x/2+5, -total_size.y/2+5]) rounded_rect([10,10], 3);
        }
        translate([-total_size.x/2, -total_size.y/2])
        translate([outer_standoff_hole_offset, outer_standoff_hole_offset])
        offset(r=+0.5) offset(delta=-0.5) circle(d=5.5, $fn=6);
    }
}

bottom_plate();
translate(concat(controller_offset, plate_thickness+30)) color("Yellow") middle_plate();
translate([0,0,plate_thickness]) color("Lime") side_plate2();
*translate([0,0,-plate_thickness]) color("Lime") side_plate();

%translate([102,102,29]) rotate([180,0,-90]) rpi3();
%translate(concat(controller_offset, plate_thickness*2+36)) controller();
%translate(concat(breadboard_offset, plate_thickness)) breadboard();

%translate([20+3,70,plate_thickness+10]) rotate([0,-90,0]) fan();

%translate(controller_size/2 + controller_offset) {
    translate([0,0,plate_thickness]) union() {
        translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) standoff(20+10);
        translate([+controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) standoff(20+10);
        translate([-controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) standoff(20+10);
        translate([-controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) standoff(20+10);
    }
    translate([0,0,2*plate_thickness+30]) union() {
        translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) standoff(6);
        translate([+controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) standoff(6);
        translate([-controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) standoff(6);
        translate([-controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) standoff(6);
    }
}

*%translate([0,0,2.5*25.4]) cube([200,200,0.1]);
