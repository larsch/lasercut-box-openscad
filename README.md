# Laser cut Box OpenSCAD Module

This is an OpenSCAD module for creating boxes to be laser-cut out of
flat panels (e.g. plywood or acrylic). The boxes dimensions are
customizable, supports opening the top, insetting the bottom, and
adding handles.

## Synopsis

```
box(options);
```

## Options

 * width (length) - outer width of box
 * height (length) - outer height of box
 * depth (length) - outer depth of box
 * inner (boolean) - width/height/depth are inner dimensions
 * thickness (length) - material thickness
 * finger_width (length) - target finger width
 * finger_margin (length) - distance from inside edge to first finger
 * open (boolean) - Removes the top
 * inset (length) - Amount to inset the bottom side
 * assemble (boolean) - Render assembled 3D box instead of 2D cutting plans
 * hole_width - Width of handle hole
 * hole_height - Height of handle hole
 * hole_margin - Distance from top edge to handle hole
 * kerf (diameter) - Cutting kerf (rendering will be offset by half this)
 * dividers (array with two elements) - How many dividers to insert in X and Y directions
 * holes (array) - Where to place rivet holes
 * hole_dia (length) - Diameter of rivet holes
 * ears (boolean) - If true, 'ears' for hinges are generated

## Examples

```scad
include <box.scad>
box(width = 120, height = 100, depth = 140, thickness = 4, assemble = true);
```

![Normal closed box](examples/box_normal.png)

Dimensions are outer by default. Set ```inner = true``` to render a box based on inner dimensions:

```scad
include <box.scad>
box(width = 120, height = 100, depth = 140, thickness = 4, inner = true, assemble = true);
```

Set ```assemble = false``` to render the final rendering for cutting:

![Rendering](examples/box_normal_cut.png)

Another example with open top and handles:

![Open box with handles](examples/box_open_handles.png)

You can use another box as a lid:

![Box With lid](examples/box_with_lid.png)

The target finger size can be adjusted using the ```finger_width``` option, but it will be adjusted depending on the box dimensions:

![Dynamic finger adjustment](anim.gif)

## License

Copyright (c) 2016 Lars Christensen

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
