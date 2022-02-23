$fn = 100;

mount_hole_d = 5.3; // mm, 5mm hole plus a bit of tolerance
chain_hole_d = 3.2; // mm, 3mm hole plus a bit of tolerance

total_length = 72.5;

module brace() {
    linear_extrude(2) polygon([
        [0,0],
        [total_length-15-2-7.5,0],
        [total_length-15-2-7.5,6.5],
        [0,0]
    ]);
}


mirror([0,1,0])
rotate([180,0,0]) translate([0,0,-2]) union() {
    linear_extrude(2) difference() {
        offset(r=-3) offset(delta=3)
        offset(r=3) offset(delta=-3)
        polygon([
            [0, 0],
            [total_length-15,0],
            [total_length-15,-7.5],
            [total_length,-7.5],
            [total_length,27.5],
            [total_length-15,27.5],
            [total_length-15,20],
            [0,20],
            [0,0]
        ]);
        translate([total_length-7.5, 0]) circle(d=mount_hole_d);
        translate([total_length-7.5, 20]) circle(d=mount_hole_d);
        translate([15, 20-13]) circle(d=chain_hole_d);
        translate([9, 20-5]) circle(d=chain_hole_d);
        translate([21, 20-5]) circle(d=chain_hole_d);
    }
    linear_extrude(2) square([3,20]);
    translate([0,0,-2.5]) rotate([-90,0,0]) brace();
    translate([0,18,-2.5]) rotate([-90,0,0]) brace();
    translate([total_length-15-2-7.5,0,-2.5]) rotate([180,0,90]) linear_extrude(6.5) square([20,2]);
    translate([0,0,-2.5]) linear_extrude(2.5) difference() {
        square([total_length-15-7.5,20]);
        translate([15, 20-13]) circle(d=6.2, $fn=6);
        translate([9, 20-5]) circle(d=6.2, $fn=6);
        translate([21, 20-5]) circle(d=6.2, $fn=6);
    }
}
