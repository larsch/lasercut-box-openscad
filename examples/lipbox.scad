include <../box.scad>

// Dimensions are inside
inner = false;

// width
width = 205;

// height
height = 60;

// depth
depth = 100;

// material thickness
thickness = 3;

// height of lid
lid_height = 20;

// assemble on/off
assemble = true;

// spacing in 2d render
spacing = 1;

// clearance between inner lip and lid
inner_clearance = 1;

outer_box();
move_inner() inner_box();
move_lid() lid();

module outer_box() {
    box(width = width,
        height = height - lid_height,
        depth = depth,
        inner = inner,
        thickness = thickness,
        open = true, assemble = assemble,
        spacing = spacing);
}


module inner_box() {
    inner_height = inner ? height : (height - 2 * thickness);
    box(width = width - 2 * thickness,
        depth = depth - 2 * thickness,
        height = inner_height - inner_clearance,
        inner = inner,
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
        inner = inner,
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
    lid_lift = inner ? thickness : 0;
    if (assemble)
        translate([0,0,height - lid_height + lid_lift + 30]) children();
    else
        translate([0,2*width,0]) children();
}
