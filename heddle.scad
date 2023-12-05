include <heddle_handle.scad>;
$fn = 20;

// The total height of the heddle from edge of bottom handle to edge
// of top handle. If you have a small printer, make sure this is
// equal to or less than the build volume dimension you're trying to
// fit it into.
// Fun fact: this default value is for my Monoprice Select Mini,
// whose build volume is just slightly smaller than the original
// RHL's screens. That's why I built this parameterised model in the
// first place!
heddle_height = 110;

// The thickness of all the reeds (not their width; that's calculated
// from the dent).
reed_thickness = 3;

// The dent count, or number of threads per inch -- for example,
// 8-dent gives four reeds with holes in them, separated by four
// slots.
reed_dent = 8;

// The length of the holes in the reeds.
reed_hole_height = 10;

// The length of the screen, if that's what you're building.
// If you prefer metric, you can just define screen_length directly.
// Given that reed dents are specified in inches, and therefore the
// width of a reed is a fraction of an inch, screen_length must be an
// imperial number that's an even multiple of one reed and one slot.
// A similar thing is true for odd reed dent counts -- your screen
// length needs to be an even multiple of an inch. To find out why,
// make the screen length a non-recommended size and see what
// happens ;)
screen_inches = 1;
screen_length = screen_inches * 25.4;

//////// HEDDLE HANDLE SETTINGS IF YOU WANT TO OVERRIDE THEM!
//////// SCROLL DOWN TO FIND THE PLACE WHERE YOU OUTPUT THE MODELS.

// All the following commented values match the defaults from
// heddle_handle.scad. Uncomment them to change them.

// The diameter of the dowel that runs the length of the heddle handles.
//handle_dowel_dia = 7/16 * 25.4;

// The thickness of the dowel cap wall.
//cap_wall_thickness = 2.001;

// The amount by which to expand holes and shrink tongues.
// Adjust this to match the precision of your printer.
//tolerance = 0;

// Adjust dowel hole tolerance separately from notch/tongue.
//dowel_hole_tolerance = tolerance;

// Adjust notch/tongue tolerance separately from dowel hole tolerance.
//fitting_tolerance = tolerance;

// Put a screw hole in the dowel caps.
// Set to false to rely on pressure-fitting alone.
// Use the american_screw_size() function to choose anywhere from a
// #2 to #5 countersunk screw hole.
//screw = american_screw_size(3);

// The dimensions of the notch and tongue to keep the dowel caps from
// slipping. Length × depth × thickness.
//fitting_size = [4, 3, 2];

// The bottom dowel caps are a bit longer; this is so that they can
// reach all the way to the heddle brace. Adjust the length according
// to how much screen you've already jammed onto your dowel.
//bottom_cap_length = 7.75;

// Important calculations; don't touch.
reed_height = heddle_height - handle_height * 2;
single_reed_width = 25.4 / reed_dent * 2;
reed_spacing_unit = single_reed_width / 4;
number_of_reeds = (reed_dent / 2) * (screen_length / 25.4);

//////// HERE'S WHERE YOU OUTPUT THE STUFF!

// Uncomment this line to build a whole screen panel.
//screen();

// Uncomment this line to build a dowel cap for the top handle.
//translate([0, 0, cap_wall_thickness]) rotate([-90, 0, 0]) handle_with_fittings("cap", cap_wall_thickness);

// Uncomment this line to build a dowel cap for the bottom handle.
//translate([0, 0, bottom_cap_length]) rotate([-90, 0, 0]) handle_with_fittings("cap", bottom_cap_length);

module screen() {
  for (i = [0:number_of_reeds - 1]) {
      translate([0, i * single_reed_width, 0]) reed();
  }

  translate([reed_height, 0, 0]) scale([-1, 1, 1]) handle_with_fittings("screen", screen_length);
  handle_with_fittings("screen", screen_length);
}

module reed() {
    translate([0, reed_spacing_unit / 2, 0]) difference() {
        cube([reed_height + 0.002, reed_spacing_unit * 3, reed_thickness]);
        reed_hole_start = (reed_height - reed_hole_height + reed_spacing_unit) / 2;
        reed_hole_square = reed_hole_height - reed_spacing_unit;
        translate([reed_hole_start, reed_spacing_unit, -0.001]) cube([reed_hole_square, reed_spacing_unit, reed_thickness + 0.002]);
        translate([reed_hole_start, reed_spacing_unit * 1.5, -0.001]) cylinder(reed_thickness + 0.002, d = reed_spacing_unit);
        translate([reed_hole_start + reed_hole_square, reed_spacing_unit * 1.5, -0.001]) cylinder(reed_thickness + 0.002, d = reed_spacing_unit);
    }
}