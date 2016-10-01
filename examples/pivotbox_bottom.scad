include <../box.scad>
include <pivotbox_defs.scad>

box(width = 2*w, height = h, depth = d, thickness = thickness, open = true,
    dividers = bottom_dividers, hole_dia = hole_dia,
    holes = [ [w/2-hole_dist, h/2], [w/2, h/2], [2*w-(w/2-hole_dist), h/2], [2*w-w/2, h/2] ],
    assemble = assemble, labels = true, explode = 0);

