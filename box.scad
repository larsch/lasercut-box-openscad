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
labels = false;

// Examples:

// box(width = 130, height = 150, depth = 170, thickness = 4);
// box(width = 130, height = 150, depth = 170, thickness = 4, open = true, inset = 8);
// lidbox(width = 130, height = 150, depth = 170, thickness = 4);

// box2d();

// Internals:

e = 0.01;
kc = kerf / 2;

module box(width, height, depth, thickness, finger_width, finger_margin,
	   open = false, inset = 0, assemble = false,
     hole_width = false) {
  w = width;
  h = height;
  d = depth;
  t = thickness;
  hm = h - inset;
  fm = (finger_margin == undef) ? thickness * 2 : finger_margin;
  fw = (finger_width == undef) ? thickness * 2 : finger_width;
  keep_top = !open;

  module left() { cut_left() panel2d(d, h); }
  module right() { cut_right() panel2d(d, h); }
  module top() { cut_top() panel2d(w, d); }
  module bottom() { cut_bottom() panel2d(w, d); }
  module back() { cut_back() panel2d(w, h); }
  module front() { cut_front() panel2d(w, h); }

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
    translate([x4,y1]) compkerf() bottom();
    if (keep_top) {
	 x5 = w + 2 * kc + e;
	 translate([x5,y1]) compkerf() top();
    }
  }

  module box3d() {
    front3d(w, h, d);
    back3d(w, h, d);
    translate([0,0,inset]) bottom3d();
    if (keep_top)
      top3d();
    left3d();
    right3d();
  }

  module cut_front() {
    difference() {
      children();
      translate([0,inset]) cuts(w);
      if (keep_top) movecutstop(w, h) cuts(w);
      movecutsleft(w, h) cuts(h);
      movecutsright(w, h) cuts(h);
      if (hole_width) {
	   r = hole_height / 2;
	   hull() {
		translate([w/2 - hole_width/2 + r, h - hole_margin - r])
		     circle(r = r);
		translate([w/2 + hole_width/2 - r, h - hole_margin - r])
		     circle(r = r);
	   }
      }
    }
  }

  module cut_top() {
    difference() {
      children();
      invcuts(w);
      movecutstop(w, d) invcuts(w);
      movecutsleft(w, d) translate([t,0]) invcuts(d-2*t);
      movecutsright(w, d) translate([t,0]) invcuts(d-2*t);
    }
  }

  module cut_left() {
    difference() {
      children();
      translate([t,inset]) cuts(d-2*t);
      if (keep_top) movecutstop(d, h) translate([t,0]) cuts(d-2*t);
      movecutsleft(d, h) invcuts(h);
      movecutsright(d, h) invcuts(h);
    }
  }

  module cut_bottom() { cut_top() children(); }
  module cut_right() { cut_left() children(); }
  module cut_back() { cut_front() children(); }

  module cuts(tw, li = 0, ri = 0) {
    w = tw - li - ri;
    innerw = w - t*2 - 2 * fm;
    tc1 = floor((innerw / fw - 1) / 2);
    tc = (tc1 < 0) ? 0 : tc1;
    steps = tc * 2 + 1;

    fw_fitting = innerw / steps;

    // Use a default finger if we cant fit one within margins
    fw1 = (innerw < fw) ? fw : fw_fitting;
    // Divide length by 3 if we can fit less that 3 fingers
    fw2 = (tw < fw * 3) ? (tw / 3) : fw1;

    stepsize = fw2;

    x = (w - steps * stepsize) / 2;
    fw_minimum = t;

    if (tw >= 3 * fw_minimum) {
      translate([li,0])
	for (i = [0:tc]) {
	  translate([x+i*stepsize*2,-e])
	    square([stepsize, t+e]);
	}
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
    if (labels) {
	 color("Yellow")
	      translate([x/2,y/2,t+1])
	      text(text = name, halign = "center", valign="center");
    }
  }

  module panel2d(x, y) {
    square([x,y]);
  }

  if (assemble)
    box3d();
  else
    box2d();
}


// Kerf compensation modifier
module compkerf() { offset(delta = kc) children(); }
