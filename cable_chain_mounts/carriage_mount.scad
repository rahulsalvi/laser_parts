$fn = 100;

mount_hole_d = 5.3; // mm, 5mm hole plus a bit of tolerance
chain_hole_d = 3.2; // mm, 3mm hole plus a bit of tolerance

module chain_bracket() {
    translate([0,0,2]) linear_extrude(2) difference() {
        square([40,20]);
        translate([15,13]) circle(d=chain_hole_d);
        translate([9,5]) circle(d=chain_hole_d);
        translate([21,5]) circle(d=chain_hole_d);
    }
    linear_extrude(2.5) difference() {
        square([40,20]);
        // d=6 is a press-fit
        translate([15,13]) circle(d=6.2, $fn=6);
        translate([9,5]) circle(d=6.2, $fn=6);
        translate([21,5]) circle(d=6.2, $fn=6);
    }
    rotate([-90,0,0]) linear_extrude(2) polygon([[0,0], [40,0], [40,10], [0,0]]);
    translate([0,18,0]) rotate([-90,0,0]) linear_extrude(2) polygon([[0,0], [40,0], [40,10], [0,0]]);
    translate([30,20,4]) rotate([90,0,0]) linear_extrude(2) polygon([[0,0], [10,0], [10,5], [0,0]]);
    translate([30,2,4]) rotate([90,0,0]) linear_extrude(2) polygon([[0,0], [10,0], [10,5], [0,0]]);
}


rotate([180,0,0]) mirror([0,0,1])
union() {
    linear_extrude(2) difference() {
        union() {
            offset(r=-3) offset(delta=3)
            offset(r=3) offset(delta=-3)
            polygon([
                    [0,10],
                    [7.5,22.5],
                    [22.5,22.5],
                    [22.5,0],
                    [77.5,0],
                    [77.5,22.5],
                    [92.5,22.5],
                    [92.5,-12],
                    [0,-12],
                    [0,10]
                ]);
        }
        // mounting holes
        translate([15,15]) circle(d=mount_hole_d);
        translate([85,15]) circle(d=mount_hole_d);
    }
    translate([21.25,0,42]) rotate([0,90,90]) chain_bracket();
}
