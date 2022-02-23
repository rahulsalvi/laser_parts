$fn = 100;

hole_tol = 0.2; // mm, widen holes a bit to make clearance easier

module clevis() {
    difference() {
        width = 4;
        height = 4;
        hull() {
            translate([width,0]) circle(d=6);
            translate([-width,0]) circle(d=6);
            translate([0, height]) circle(d=8);
        }
        translate([0, height]) circle(d=3+hole_tol);
        translate([0,-50]) square(100, center=true);
    }
}

module original_and_mirror() {
    union() {
        children();
        mirror([0,1,0]) children();
    }
}

*union() {
    base_height=2;
    cylinder(base_height, d=25);
    original_and_mirror() translate([0,-6.5/2,base_height]) rotate([90,0,0]) linear_extrude(3) clevis();
}

t = $preview ? [-14/2,0,14.25] : [25/2+5,0,6.5/2];
r = $preview ? [-90,0,0] : [0,0,0];
translate(t) rotate(r)
!difference() {
    connector_width = 7; // mm
    connector_dia = 6.5; // mm
    connector_hole_dia = 3; // mm
    total_width = connector_width + 7;
    fillet_dia = 6; // mm
    union() {
        rotate([0,90,0]) cylinder(total_width, d=connector_dia);
        translate([0,0,-connector_dia/2]) cube([total_width,(connector_dia/2)+1,connector_dia]);
        translate([total_width/2,(connector_dia/2)+1,-connector_dia/2]) linear_extrude(connector_dia) clevis();
    }
    translate([(total_width-connector_width)/2,-connector_dia/2,-connector_dia/2]) cube([connector_width, connector_dia+1, connector_dia]);
    rotate([0,90,0]) cylinder(total_width, d=connector_hole_dia+hole_tol);
    translate([3.5-1,0,0]) rotate([0,90,0]) intersection() {
        cylinder(1, d=connector_dia);
        translate([-5,-10]) cube([10,10,1]);
    }
    translate([3.5+connector_width,0,0]) rotate([0,90,0]) intersection() {
        cylinder(1, d=connector_dia);
        translate([-5,-10]) cube([10,10,1]);
    }
}
