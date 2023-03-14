include <../box.scad>
include <pivotbox_defs.scad>

box(width = w, height = h, depth = d,
    dividers = top_dividers,
    holes = [ [w-(w/2-hole_dist), h/2], [w/2, h/2] ],
    hole_dia = hole_dia,
    ears = thickness*2.2, thickness = thickness,
    open = false, assemble = false, labels = true);

