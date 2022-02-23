cutoff_size = 2.1; // mm
translate([0,0,-cutoff_size]) difference() {
    translate([-70,-95]) import("C270_Focuser_Front.stl");
    cube([100,100,cutoff_size]);
}
