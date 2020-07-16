w_divider_color = "CadetBlue";
h_divider_color = "CornflowerBlue";
front_color = "RoyalBlue";
back_color = "RoyalBlue";
bottom_color = "SlateBlue";
top_color = "SlateBlue";
left_color = "MediumAquamarine";
right_color = "MediumAquamarine";
e = 0.01;

module box(width, height, depth, thickness,
           finger_width, // (default = 2 * thickness)
           finger_margin, // (default = 2 * thickness)
           inner = false,
           open = false,
           open_bottom = false,
           inset = 0,
           dividers = [ 0, 0 ],
           holes = [],
           hole_dia = 0,
           ears = 0,
           assemble = false,
           hole_width = false,
           kerf = 0.0,
           labels = false,
           explode = 0,
           spacing = 0)
{
  w = inner ? width + 2 * thickness : width;
  h = inner ? height + 2 * thickness : height;
  d = inner ? depth + 2 * thickness : depth;
  t = thickness;
  hm = h - inset;
  fm = (finger_margin == undef) ? thickness * 2 : finger_margin;
  fw = (finger_width == undef) ? thickness * 2 : finger_width;
  keep_top = !open;
  keep_bottom = !open_bottom;
  kc = kerf / 2;
  ears_radius = ears;
  ears_width = 3;

  // Kerf compensation modifier
  module compkerf() { offset(delta = kc) children(); }

  // 2D panels with finger cuts
  module left() { cut_left() panel2d(d, h); }
  module right() { cut_right() panel2d(d, h); }
  module top() { 
    if (ears_radius > 0) {
      difference() {
        panel2d(w, d);
        translate([t, d-t+e]) panel2d(2*t, t);
        translate([t, -e]) panel2d(2*t, t);
      }
    } else {
      cut_top() panel2d(w, d);
    }
  }
  module bottom() { cut_bottom() panel2d(w, d); }
  module ears_outer(is_front) {
    translate([is_front ? 0 : w, h]) 
      circle(ears_radius, [0, 0]);
  }
  module ears_inner(is_front) {
    translate([is_front ? 0 : w, h])
      difference() {
      circle(ears_radius-ears_width, [0, 0]);
      square([t, t]);
    }
  }
  module back() {
    cut_back() difference() {
      union() {
        panel2d(w, h);
        if (ears_radius > 0)
          ears_outer(false);
      }
      if (len(holes) > 0)
        for (i = [ 0 : len(holes)-1 ])
          hole([w-holes[i][0], holes[i][1]]);
      if (ears_radius > 0)
        ears_inner(false);
    }
  }
  module hole(center) {
    translate(center) circle(d = hole_dia);
  }
  module front() {
    cut_front() difference() {
      union()
      {
        panel2d(w, h); 
        if (ears_radius > 0)
          ears_outer(true);
      }
      if (len(holes) > 0)
        for (i = [ 0 : len(holes)-1 ])
          hole(holes[i]);
      if (ears_radius > 0)
        ears_inner(true);
    }
  }

  module w_divider() { cut_w_divider() translate([0, t, 0]) panel2d(w, h-t); }
  module h_divider() { cut_h_divider() translate([0, t, 0]) panel2d(d, h-t); }

  // Panels positioned in 3D
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
    translate([0, 0, h-t+explode+(ears_radius > 0 ? t : 0)])
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

  module w_divider3d() {
    if (dividers[0] > 0) {
      ndivs = dividers[0];
      for (i = [ 1 : 1 : ndivs ])
        translate([0, d/(ndivs+1)*i+t/2,0])
          rotate(90, [1,0,0])
          panelize(w,h, "Divider", w_divider_color)
          w_divider();
    }
  }

  module h_divider3d() {
    translate([0,0,explode > e && dividers[0] > 0 ? h + explode : explode])
      if (dividers[1] > 0) {
        ndivs = dividers[1];
        for (i = [1 : 1 : ndivs])
          translate([w/(ndivs+1)*i-t/2,0,0])
            rotate(90, [1,0,0])
            rotate(90, [0,1,0])
            panelize(d,h, "Divider", h_divider_color)
            h_divider();
      }
  }

  module w_dividers() {
    if (dividers[0] > 0) {
      ndivs = dividers[0];
      for (i = [0 : 1 : ndivs-1])
        translate([i*(w+e)+spacing*(i+1),0,0])
          w_divider();
    }
  }

  module h_dividers() {
    if (dividers[1] > 0) {
      ndivs = dividers[1];
      for (i = [0 : 1 : ndivs-1])
        translate([i*(d+e)+spacing*(i+1),0,0])
          h_divider();
    }
  }

  // Panelized 2D rendering for cutting
  module box2d() {
    compkerf() front();
    x1 = w + kc * 2 + e + spacing;
    translate([x1,0]) compkerf() back();
    x2 = x1 + w + 2 * kc + e + ears_radius + spacing;
    translate([x2,0]) compkerf() left();
    x3 = x2 + d + 2 * kc + e + spacing;
    translate([x3,0]) compkerf() right();
    y1 = h + kc * 2 + e + ears_radius + spacing;
    if (keep_bottom) {
      x4 = 0;
      translate([x4,y1]) compkerf() bottom();
    }
    if (keep_top) {
      x5 = w + 2 * kc + e + spacing;
      translate([x5,y1]) compkerf() top();
    }
    x6 = w + 2 * kc + (keep_top ? w+e : 0) + e + spacing;
    translate([x6,y1]) compkerf() w_dividers();
    translate([x6+kerf,y1 + (dividers[0] > 0 ? y1 : 0)]) compkerf() h_dividers();
  }

  // Assembled box in 3D
  module box3d() {
    front3d();
    back3d();
    if (keep_bottom)
      translate([0,0,inset]) bottom3d();
    if (keep_top)
      top3d();
    left3d();
    right3d();
    w_divider3d();
    h_divider3d();
  }

  // Finger cutting operators
  module cut_front() {
    difference() {
      children();
      if (keep_bottom) translate([0,inset]) cuts(w);
      if (keep_top && (ears_radius == 0)) movecutstop(w, h) cuts(w);
      movecutsleft(w, h) cuts(h);
      movecutsright(w, h) cuts(h);
      if (dividers[1] > 0) {
        ndivs = dividers[1];
        for (i = [1 : 1 : ndivs])
          movecuts(w/(ndivs+1)*i-t/2, 0) cuts(h, li = thickness*2);
      }
      holecuts();
    }
  }

  module cut_w_divider() {
    difference() {
      children();
      movecutsleft(w, h) invcuts(h, ri = thickness*2);
      movecutsright(w, h) invcuts(h, li = thickness*2);
      if (dividers[1] > 0) {
        ndivs = dividers[1];
        for (i = [1 : 1 : ndivs])
          movecuts(w/(ndivs+1)*i-t/2, h/2) square([h / 2, thickness]);
      }
      holecuts();
    }
  }

  module cut_h_divider() {
    difference() {
      children();
      movecutsleft(d, h) invcuts(h, ri = thickness*2);
      movecutsright(d, h) invcuts(h, li = thickness*2);
      if (dividers[0] > 0) {
        ndivs = dividers[0];
        for (i = [1 : 1 : ndivs])
          movecuts(d/(ndivs+1)*i-t/2, 0) square([h / 2, thickness]);
      }
      holecuts();
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
      if (keep_bottom) translate([t,inset]) cuts(d-2*t);
      if (keep_top && (ears_radius == 0)) movecutstop(d, h) translate([t,0]) cuts(d-2*t);
      movecutsleft(d, h) invcuts(h);
      movecutsright(d, h) invcuts(h);
      if (dividers[0] > 0) {
        ndivs = dividers[0];
        for (i = [1 : 1 : ndivs])
          movecuts(d/(ndivs+1)*i-t/2, 0) cuts(h, li = thickness*2);
      }
    }
  }

  module cut_bottom() { cut_top() children(); }
  module cut_right() { cut_left() children(); }
  module cut_back() { cut_front() children(); }

  // Handle hole
  module holecuts() {
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

  // Finger cuts (along x axis)
  module cuts(tw, li = 0, ri = 0, full = false) {
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

  // Inverse finger cuts (along x axis)
  module invcuts(w, li = 0, ri = 0, full = true) {
    difference() {
      translate([-2*e,-e]) square([w+4*e,t+e]);
      cuts(w, li, ri, full);
    }
  }

  // Finger cut positioning operators
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

  module movecuts(w, h) {
    translate([w, h])
      rotate(90,[0,0,1])
      translate([0,-t])
      children();
  }

  // Turn 2D Panel into 3D
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
