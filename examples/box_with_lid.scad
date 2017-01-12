include <../box.scad>
width = 150;
height = 100;
depth = 200;
thickness = 4;
extra = thickness + 2;
assemble = true;

if (assemble) {
     the_box();
     translate([-extra, -extra, height - 4 * thickness]) lid();
} else {
     the_box();
     translate([0,height+depth+4*kerf])
     lid();
}

module the_box() {
     box(width = width,
	 height = height,
	 depth = depth,
	 thickness = thickness,
	 open = true,
	 inset = 2 * thickness,
	 assemble = assemble);
}

module lid() {
     box(width = width + 2 * extra,
	 height = 6 * thickness,
	 depth = depth + 2 * extra,
	 thickness = thickness,
	 open = true,
	 inset = 4 * thickness,
	 assemble = assemble);
}
