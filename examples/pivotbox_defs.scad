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
// Dividers in each top box: One along width
top_dividers = [ 1, 0 ];
// Dividers in each middle box: Two along width
middle_dividers = [ 2, 0 ];
// Dividers in bottom box: One along depth
bottom_dividers = [ 0, 1 ];

// To make circles sufficiently smooth
$fn = 50;
