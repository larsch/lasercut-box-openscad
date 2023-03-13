include <../box.scad>

width = 205;
thickness = 3;
height = 60;
depth = 100;
lid_height = 20;
assemble = true;
spacing = 1;

outer_box();
move_inner() inner_box();
move_lid() lid();

module outer_box() {
    box(width = width,
        height = height - lid_height,
        depth = depth,
        thickness = thickness,
        open = true, assemble = assemble,
        spacing = spacing);
}

module inner_box() {
    box(width = width - 2 * thickness,
        depth = depth - 2 * thickness,
        height = height - 2 * thickness - 2,
        thickness = thickness,
        assemble = assemble,
        open = true,
        open_bottom = true,
        spacing = spacing);
}

module lid() {
    box(width = width,
        depth = depth,
        height = lid_height,
        thickness = thickness,
        open_bottom = true,
        assemble = assemble,
        spacing = spacing);
}

module move_inner() {
    if (assemble)
        translate([thickness,thickness,thickness]) children();
    else
        translate([0,width,0]) children();
}

module move_lid() {
    if (assemble)
        translate([0,0,height - lid_height + 30]) children();
    else
        translate([0,2*width,0]) children();
}