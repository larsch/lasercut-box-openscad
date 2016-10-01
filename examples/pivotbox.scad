include <../box.scad>

w = 150;
h = 50;
d = 150;
assemble = true;//false;
hole_dist = 50;
$fn = 50;

// Bottom

box(width = 2*w, height = h, depth = d, thickness = 4, open = true,
    dividers = [ 0, 1 ],
    holes = [ [w/2-hole_dist, h/2], [w/2, h/2], [2*w-(w/2-hole_dist), h/2], [2*w-w/2, h/2] ],
    assemble = assemble, labels = true, explode = 0);

// Middle

box(width = w, height = h, depth = d, thickness = 4, open = true,
    dividers = [ 2, 0 ],
    holes = [ [w/2-hole_dist, h/2], [w/2, h/2], [w/2+hole_dist, h/2] ], assemble = assemble, labels = true, explode = 0);

// Top

box(width = w, height = h, depth = d, dividers = [ 1, 0 ], holes = [ [w-(w/2-hole_dist), h/2], [w/2, h/2] ], ears = 10, thickness = 4, open = false, assemble = assemble, labels = true, explode = 0);

