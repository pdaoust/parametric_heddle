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
// 8-dent gives eight slots per inch to put threads through.
reed_dent = 8;

// The pattern of holes for the threads to fit through.
// This requires a bit of explanation, so here you go!
// If you specify values that are less than or equal to 1, it'll indicate how far up and down the screen the slot goes. Examples:
// * 1 = a slot that goes from the top to the bottom of the screen.
// * 0.1 = the hole is only 10% the height of the screen; the other 90%
//   is filled in.
// If you specify values that are more than 1, it'll treat them as
// lengths of the holes in millimetres instead.
// Anyhow, this pattern is repeated as many times as is necessary to fill
// up your reed panel, starting with a half-wide hole. I'd recommend a full slot
// for the first hole, because lining up two halves of a smaller hole might
// create alignment issues and sharp bits for the yarn to catch on.
// To see what I'm talking about, choose isometric view and look at it from
// directly above. See how the left and right edges of the screen are
// slightly narrower than than handles and have little scalloped corners?
// That's two halves of a hole.

// An old-fashioned screen with nothing but full-length slots.
//reed_pattern = [1];

// A modern screen with alternating slots and 10mm holes.
//reed_pattern = [1, 10];

// A fancy patterned screen for band weaving like you see in the middle of
// https://harvestlooms.com/products/15-double-slot-rigid-heddle-loom-weaving-backstrap-band-weaving-inkle-pattern-weaving-saami-sami-baltic-nordic-inlay-patterns
// Try it out on a screen 3 inches wide to get the full effect.
reed_pattern = [1, 0.05, 0.5, 0.05, 1, 0.5];

// The length of the screen, if that's what you're building.
// If you prefer metric, you can just define screen_length directly.
// Given that reed dents are specified in inches, and therefore the
// width of a reed is a fraction of an inch, screen_length must be an
// imperial number that's an even multiple of one reed and one slot.
// A similar thing is true for odd reed dent counts -- your screen
// length needs to be an even multiple of an inch. To find out why,
// make the screen length a non-recommended size and see what
// happens ;)
screen_inches = 2;
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

//////// HERE'S WHERE YOU OUTPUT THE STUFF!

// Uncomment this line to build a whole screen panel.
//screen();

// Uncomment this line to build a dowel cap for the top handle.
//rotate([-90, 0, 0]) handle_with_fittings("cap", cap_wall_thickness);

// Uncomment this line to build a dowel cap for the bottom handle.
//rotate([-90, 0, 0]) handle_with_fittings("cap", bottom_cap_length);

// Uncomment these lines to build the minimal parts needed to print a
// presure-fitting test.
//rotate([90, 0, 0]) handle_with_fittings("fitting-tolerance-test");
//translate([0, -40, cap_wall_thickness]) rotate([-90, 0, 0]) handle_with_fittings("cap", cap_wall_thickness);

module screen() {
  reed_height = heddle_height - handle_height * 2;
  hole_spacing = 25.4 / reed_dent;
  hole_width = hole_spacing / 2;
  number_of_holes = reed_dent * (screen_length / 25.4);
  reed_pattern_count = len(reed_pattern);

  difference() {
    cube([reed_height + 0.002, screen_length, reed_thickness]);
    for (i = [0:number_of_holes]) {
      hole_length = reed_pattern[i % reed_pattern_count];
      calculated_hole_length = hole_length <= 1
        // A fraction of the reed height.
        ? reed_height * hole_length
        // A millimetre value.
        : hole_length;
      translate([reed_height / 2, i * hole_spacing, 0]) reed_hole(calculated_hole_length, hole_width);
    }
  }

  translate([reed_height, 0, 0]) scale([-1, 1, 1]) handle_with_fittings("screen", screen_length);
  handle_with_fittings("screen", screen_length);
}

module reed_hole(length, width) {
  translate([0, 0, reed_thickness / 2 - 0.001]) union() {
    cube([length - width, width, reed_thickness + 0.003], center=true);
    translate([length / 2 - width / 2, 0, 0]) cylinder(reed_thickness + 0.003, d=width, center=true);
    translate([length / -2 + width / 2, 0, 0]) cylinder(reed_thickness + 0.003, d=width, center=true);
  }
}