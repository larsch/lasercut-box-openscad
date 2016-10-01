include <pivotbox_defs.scad>

module connector_short(d, w, hd) {
    difference() {
        hull() {
            circle(r = w/2);
            translate([0, d]) circle(r = w/2);
        }
        circle(r = hd/2);
        translate([0, d]) circle(r = hd/2);
    }
}

module connector_long(d, w, hd) {
    difference() {
        hull() {
            circle(r = w/2);
            translate([0, 2*d]) circle(r = w/2);
        }
        circle(r = hd/2);
        translate([0, d]) circle(r = hd/2);
        translate([0, 2*d]) circle(r = hd/2);
    }
}

rod_length = sqrt(h*h+hole_dist*hole_dist);

e = 1;
for (i = [0 : 7])
    translate([i*(rod_width+e), 0]) connector_short(rod_length, rod_width, hole_dia);
for (i = [0 : 3])
    translate([(8+i)*(rod_width+e), 0]) connector_long(rod_length, rod_width, hole_dia);
