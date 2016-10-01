include <../box.scad>
include <pivotbox_defs.scad>

box(width = w, height = h, depth = d, thickness = thickness, open = true,
    dividers = middle_dividers, hole_dia = hole_dia,
    holes = [ [w/2-hole_dist, h/2], [w/2, h/2], [w/2+hole_dist, h/2] ],
    assemble = assemble, labels = true);

