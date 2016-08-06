// Box options:

w = 130; // Width
h = 150; // Height
d = 170; // Depth
t = 4; // Material thickness
fw = 10; // Finger width (approximate)
fd = 2*t; // Distance to first finger (from inside)
open_top = true;
bottom_inset = 2 * t;

// Display options:

explode = 0; // 3d explosion
front_color = "RoyalBlue";
back_color = "RoyalBlue";
bottom_color = "SlateBlue";
top_color = "SlateBlue";
left_color = "MediumAquamarine";
right_color = "MediumAquamarine";

// Cutting options:

kerf = 0.3; // Kerf width (cuts will be offset by half this)

// render:

box3d();
// box2d();

// Internals:

e = 0.01;
kc = kerf / 2;
keep_top = !open_top;
hm = h - bottom_inset;

module cuts(tw, li = 0, ri = 0) {
     w = tw - li - ri;
     innerw = w - t*2 - 2 * fd;
     tc = floor((innerw / fw - 1) / 2);
     steps = tc * 2 + 1;
     stepsize = innerw / steps;
     x = (w - steps * stepsize) / 2;
     echo(tc, steps, steps*stepsize + x * 2, w);
     echo(x, w - steps * stepsize);
     translate([li,0])
     for (i = [0:tc]) {
	  translate([x+i*stepsize*2,-e])
		    square([stepsize, t+e]);
     }
}

module movecutstop(w, h) {
     translate([w,h,0])
     rotate(180,[0,0,1])
	  children();
}

module movecutsleft(w, h) {
     translate([0, h/2])
     rotate(-90, [0,0,1])
     translate([-h/2,0])
	  children();
}

module movecutsright(w, h) {
     translate([w-t,0])
     rotate(90,[0,0,1])
     translate([0,-t])
	  children();
}

module invcuts(w, li = 0, ri = 0) {
     difference() {
	  translate([-2*e,-e]) square([w+4*e,t+e]);
	  cuts(w, li, ri);
     }
}

module panelize(x, y, name, cl) {
     color(cl)
	  linear_extrude(height = t)
	  children();
     color("Yellow")
	  translate([x/2,y/2,t+1])
	  text(text = name, halign = "center", valign="center");
}

module panel2d(x, y) {
     square([x,y]);
}

module front3d() {
     translate([0,t-explode,0])
	  rotate(90, [1,0,0])
	  panelize(w,h, "Front", front_color)
	  front();
}

module back3d() {
     translate([w,d-t+explode,0])
	  rotate(-90, [1,0,0])
	  rotate(180,[0,0,1])
	  panelize(w, h, "Back", back_color)
	  back();
}

module bottom3d() {
     translate([w,0,t-explode])
	  rotate(180,[0,1,0])
	  panelize(w, d, "Bottom", bottom_color)
	  bottom();
}

module top3d() {
     translate([0,0,h-t+explode])
	  panelize(w, d, "Top", top_color)
	  top();
}

module left3d() {
     translate([t-explode,d,0])
     rotate(-90,[0,1,0])
	  rotate(-90,[0,0,1])
	  panelize(d, h, "Left", left_color)
	  left();
}

module right3d() {
     translate([w-t+explode,0,0])
     rotate(90,[0,1,0])
	  rotate(90,[0,0,1])
	  panelize(d, h, "Right", right_color)
	  right();
}

module left() { cut_left() panel2d(d, h); }
module right() { cut_right() panel2d(d, h); }
module top() { cut_top() panel2d(w, d); }
module bottom() { cut_bottom() panel2d(w, d); }
module back() { cut_back() panel2d(w, h); }
module front() { cut_front() panel2d(w, h); }

module box3d() {
     front3d();
     back3d();
     translate([0,0,bottom_inset]) bottom3d();
     if (!open_top)
	  top3d();
     left3d();
     right3d();
}


// Kerf compensation modifier
module compkerf() { offset(delta = kc) children(); }
module box2d() {
     compkerf() front();
     x1 = w + kc * 2 + e;
     translate([x1,0]) compkerf() back();
     x2 = x1 + w + 2 * kc + e;
     translate([x2,0]) compkerf() left();
     x3 = x2 + d + 2 * kc + e;
     translate([x3,0]) compkerf() right();
     y1 = h + kc * 2 + e;
     x4 = 0;
     translate([x4,y1]) compkerf() top();
     x5 = w + 2 * kc + e;
     translate([x5,y1]) compkerf() bottom();
}

module cut_front() {
     difference() {
	  children();
	  translate([0,bottom_inset]) cuts(w);
	  if (keep_top) movecutstop(w, h) cuts(w);
	  movecutsleft(w, h) cuts(h, 0, bottom_inset);
	  movecutsright(w, h) cuts(h, bottom_inset, 0);
     }
}

module cut_top() {
     difference() {
	  children();
	  invcuts(w);
	  movecutstop(w, d) invcuts(w);
	  movecutsleft(w, d) invcuts(d);
	  movecutsright(w, d) invcuts(d);
     }
}

module cut_left() {
     difference() {
	  children();
	  translate([0,bottom_inset]) cuts(d);
	  if (keep_top) movecutstop(d, h) cuts(d);
	  movecutsleft(d, h) invcuts(h, 0, bottom_inset);
	  movecutsright(d, h) invcuts(h, bottom_inset, 0);
     }
}

module cut_bottom() { cut_top() children(); }
module cut_right() { cut_left() children(); }
module cut_back() { cut_front() children(); }
