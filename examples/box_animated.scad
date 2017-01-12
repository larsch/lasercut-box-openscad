include <../box.scad>

size = 4*3.5 + 25 + 30 * sin($t * 360);
translate([-size/2, -size/2, -size/2])
box(width =  size,
    height = size,
    depth =  size, thickness = 4,
    assemble = true);
