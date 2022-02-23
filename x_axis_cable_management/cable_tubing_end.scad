$fn = 200;

zip_tie_thickness = 1.2; // mm
zip_tie_width = 5; // mm
total_thickness = zip_tie_thickness + 4;

cable_tube_dia = 13; // mm
total_dia = cable_tube_dia+3;

total_width = 11; // mm
total_length = total_dia+(4+zip_tie_width)*2;

module ring(id, od) {
    difference() {
        circle(d=od);
        circle(d=id);
    }
}

difference() {
    linear_extrude(total_width) {
        offset(r=1) offset(delta=-1)
        square([total_length,total_thickness], center=true);
    }
    translate([total_length/2-zip_tie_width-2,-zip_tie_thickness/2,total_width-4]) cube([zip_tie_width,zip_tie_thickness,4]);
    translate([-(total_length/2-2),-zip_tie_thickness/2,total_width-4]) cube([zip_tie_width,zip_tie_thickness,4]);

    translate([0,-(total_thickness)/2 + 2.5, 7/2]) {
        translate([10,0,0]) rotate([90,0,0]) cylinder(2.5, d=6.2, $fn=6);
        translate([-10,0,0]) rotate([90,0,0]) cylinder(2.5, d=6.2, $fn=6);
        translate([10,10,0]) rotate([90,0,0]) cylinder(20, d=3.2);
        translate([-10,10,0]) rotate([90,0,0]) cylinder(20, d=3.2);
    }
}
