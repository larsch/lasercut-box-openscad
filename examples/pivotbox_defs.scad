// Box with pivoting lid, inspired by http://www.instructables.com/id/Laser-Cut-Sewing-Box

// Material thickness
thickness = 4;
// Width (bottom box is twice this)
w = 150;
// Height of each section
h = 50;
// Depth
d = 150;
// Distance between holes. Larger values make the box open wider
hole_dist = 50;
// Hole diameter. Use filament rivets (http://makezine.com/2016/04/05/pro-tip-use-filament-add-simple-rivets-and-hinges-to-3d-prints/) for assembly.
hole_dia = 3;
// Dividers in each top box: One along width
top_dividers = [ 1, 0 ];
// Dividers in each middle box: Two along width
middle_dividers = [ 2, 0 ];
// Dividers in bottom box: One along depth
bottom_dividers = [ 0, 1 ];
// Width of connecting rods
rod_width = 10;

// To make circles sufficiently smooth
$fn = 50;
