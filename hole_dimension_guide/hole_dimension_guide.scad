$fn = 100;

difference() {
    square([100, 120]);
    translate([10, 10])
    for (i = [0:5]) {
        for (j = [0:4]) {
            translate([j*20, i*20]) circle(d=(2.5+0.25*(i*5+j)));
        }
    }
}
