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

rpi_plate_size = [rpi_hole_spacing.x+31, controller_size.y-10];
rpi_plate_offset = [controller_size.x-rpi_plate_size.x, controller_size.y];
rpi_offset = [65, rpi_hole_spacing.y/2 + 25.5];

standoff_hole_d = 2.7; // mm

echo(total_size / 25.4);
echo(total_size);

outer_standoff_hole_offset = 5; // mm

module ring(id, od) {
    difference() {
        circle(d=od);
        circle(d=id);
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

module standoff_hole_cutout_inverted() {
    countersink_depth = 1.8; // mm
    cylinder(plate_thickness - countersink_depth, d=standoff_hole_d);
    translate([0,0,plate_thickness - countersink_depth]) cylinder(countersink_depth, d=4.2);
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
        translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y*1.5]) standoff_hole_cutout();
        translate([-controller_hole_spacing.x/2 + rpi_plate_offset.x, +controller_hole_spacing.y*1.5]) standoff_hole_cutout();
    }
}

module breadboard_cutout() {
    translate([0,0,plate_thickness/2]) linear_extrude(plate_thickness/2) {
        offset(r=1.5) square(breadboard_size);
    }
}

module honeycomb(hexagon_d, linewidth, rows, cols, fillet=0) {
    x_spacing = 2*(hexagon_d/2)*cos(30)+linewidth;
    y_spacing = tan(60)*x_spacing/2;
    for (j = [0:rows-1]) {
        hex_offset = (j % 2 == 0) ? 0 : x_spacing/2;
        extra = (j % 2 == 0) ? 0 : 1;
        for (i = [0:cols-1+extra]) {
            translate([i*x_spacing - hex_offset, j*y_spacing]) rotate(90) offset(r=+fillet) offset(delta=-fillet) circle(d=hexagon_d, $fn=6);
        }
    }
}

module bottom_plate() {
    difference() {
        linear_extrude(total_size.z)
        offset(r=-3) offset(delta=+3)
        offset(r=+3) offset(delta=-3) {
            square([total_size.x,total_size.y]);
            translate([-10, total_size.y/2]) square([20,20], center=true);
            translate([total_size.x+10, total_size.y/2]) square([20,20], center=true);
        }
        // outer standoff holes
        union() {
            translate([outer_standoff_hole_offset, outer_standoff_hole_offset, 0]) standoff_hole_cutout();
            translate([total_size.x - outer_standoff_hole_offset, outer_standoff_hole_offset, 0]) standoff_hole_cutout();
            translate([outer_standoff_hole_offset, total_size.y - outer_standoff_hole_offset, 0]) standoff_hole_cutout();
            translate([total_size.x - outer_standoff_hole_offset, total_size.y - outer_standoff_hole_offset, 0]) standoff_hole_cutout();
        }
        // controller mount holes
        translate(controller_offset) controller_cutout();
        // breadboard slot
        translate(breadboard_offset) breadboard_cutout();
        // mounting holes
        union() {
            translate([-10, total_size.y/2]) m5_hole_cutout();
            translate([total_size.x+10, total_size.y/2]) m5_hole_cutout();
        }
    }
    // locating pins
    translate([0,0,total_size.z]) linear_extrude(plate_thickness/2) union() {
        translate([outer_standoff_hole_offset, outer_standoff_hole_offset]) ring(7.5,8.5);
        translate([total_size.x - outer_standoff_hole_offset, outer_standoff_hole_offset, 0]) ring(7.5,8.5);
        translate([outer_standoff_hole_offset, total_size.y - outer_standoff_hole_offset, 0]) ring(7.5,8.5);
        translate([total_size.x - outer_standoff_hole_offset, total_size.y - outer_standoff_hole_offset, 0]) ring(7.5,8.5);
    }
}

module bottom_plate_with_cutouts() {
    difference() {
        bottom_plate();
        linear_extrude(plate_thickness) intersection() {
            offset(r=+3) offset(delta=-3)
            offset(r=-3) offset(delta=+3)
            union() {
                polygon([
                    [20,10],
                    [total_size.x-20,10],
                    [total_size.x-20,30],
                    [40,30],
                    [40,90],
                    [20,90],
                    [20,10]
                ]);
                polygon([
                    [10,25],
                    [20,25],
                    [20,50],
                    [10,50],
                    [10,25]
                ]);
                polygon([
                    [10,65],
                    [20,65],
                    [20,90],
                    [10,90],
                    [10,65]
                ]);
                polygon([
                    [10,90],
                    [30,90],
                    [30,total_size.y-10],
                    [10,total_size.y-10],
                    [10,90]
                ]);
                gap = 5;
                polygon([
                    [breadboard_offset.x+gap, breadboard_offset.y+gap],
                    [breadboard_offset.x+breadboard_size.x-gap, breadboard_offset.y+gap],
                    [breadboard_offset.x+breadboard_size.x-gap, breadboard_offset.y+breadboard_size.y-gap],
                    [breadboard_offset.x+gap, breadboard_offset.y+breadboard_size.y-gap],
                    [breadboard_offset.x+gap, breadboard_offset.y+gap]
                ]);
            }
            honeycomb(10,1,15,15,1);
        }
    }
}

module middle_plate() {
    difference() {
        linear_extrude(plate_thickness) difference() {
            offset(r=+3) offset(delta=-3)
            offset(r=-3) offset(delta=+3)
            union() {
                square(controller_size);
                translate(rpi_plate_offset) square(rpi_plate_size);
            }
            translate(controller_size/2) union() {
                translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) circle(d=standoff_hole_d);
                translate([+controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) circle(d=standoff_hole_d);
                translate([-controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) circle(d=standoff_hole_d);
                translate([-controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) circle(d=standoff_hole_d);
            }
        }
        translate(controller_size/2) union() {
            translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y*1.5]) standoff_hole_cutout_inverted();
            translate([-controller_hole_spacing.x/2 + rpi_plate_offset.x, +controller_hole_spacing.y*1.5]) standoff_hole_cutout_inverted();
        }
        translate(rpi_offset) {
            translate([+rpi_hole_spacing.x/2, +rpi_hole_spacing.y/2]) standoff_hole_cutout_inverted();
            translate([+rpi_hole_spacing.x/2, -rpi_hole_spacing.y/2]) standoff_hole_cutout_inverted();
            translate([-rpi_hole_spacing.x/2, +rpi_hole_spacing.y/2]) standoff_hole_cutout_inverted();
            translate([-rpi_hole_spacing.x/2, -rpi_hole_spacing.y/2]) standoff_hole_cutout_inverted();
        }
    }
}

module middle_plate_with_cutouts() {
    difference() {
        middle_plate();
        linear_extrude(plate_thickness) intersection() {
            offset(r=+3) offset(delta=-3)
            offset(r=-3) offset(delta=+3)
            union() {
                polygon([
                    [10,10],
                    [105-10,10],
                    [105-10,20],
                    [10,20],
                    [10,10]
                ]);
                polygon([
                    [45,40],
                    [85,40],
                    [85,80],
                    [45,80],
                    [45,40]
                ]);
                polygon([
                    [35,30],
                    [105-10,30],
                    [105-10,80],
                    [35,80],
                    [35,30]
                ]);
                polygon([
                    [10,30],
                    [45,30],
                    [45,40],
                    [10,40],
                    [10,40]
                ]);
            }
            honeycomb(10,1,15,15,1);
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

bottom_plate_with_cutouts();
translate(concat(controller_offset, plate_thickness+30)) color("Yellow") middle_plate_with_cutouts();
%translate([0,0,plate_thickness+3]) side_plate2();
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
        translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y*1.5]) standoff(20+10);
        translate([-controller_hole_spacing.x/2 + rpi_plate_offset.x, +controller_hole_spacing.y*1.5]) standoff(20+10);
    }
    translate([0,0,2*plate_thickness+30]) union() {
        translate([+controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) standoff(6);
        translate([+controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) standoff(6);
        translate([-controller_hole_spacing.x/2, +controller_hole_spacing.y/2]) standoff(6);
        translate([-controller_hole_spacing.x/2, -controller_hole_spacing.y/2]) standoff(6);
    }
}

*%translate([0,0,2.5*25.4]) cube([200,200,0.1]);
