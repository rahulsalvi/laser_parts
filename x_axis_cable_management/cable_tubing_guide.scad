$fn = 200;

zip_tie_thickness = 1.2; // mm
zip_tie_width = 5; // mm

cable_tube_dia = 13; // mm
total_dia = cable_tube_dia+3;

total_width = 10; // mm
total_length = total_dia+(4+zip_tie_width)*2;

module ring(id, od) {
    difference() {
        circle(d=od);
        circle(d=id);
    }
}

difference() {
    linear_extrude(total_width) {
        circle(d=total_dia);
        offset(r=1) offset(delta=-1)
        square([total_length,zip_tie_thickness+4], center=true);
    }
    translate([0,0,(total_width-zip_tie_width)/2]) linear_extrude(zip_tie_width) ring(total_dia,total_dia+zip_tie_thickness*2);
    cylinder(total_width,d=cable_tube_dia);
    linear_extrude(total_width) polygon([
        [0,0],
        [-20/sqrt(2),-20],
        [20/sqrt(2),-20],
        [0,0]
    ]);
    translate([total_length/2-zip_tie_width-2,-zip_tie_thickness/2,0]) cube([zip_tie_width,zip_tie_thickness,4]);
    translate([total_length/2-zip_tie_width-2,-zip_tie_thickness/2,total_width-4]) cube([zip_tie_width,zip_tie_thickness,4]);
    translate([-(total_length/2-2),-zip_tie_thickness/2,0]) cube([zip_tie_width,zip_tie_thickness,4]);
    translate([-(total_length/2-2),-zip_tie_thickness/2,total_width-4]) cube([zip_tie_width,zip_tie_thickness,4]);
}
