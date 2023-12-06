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
// from the dent count).
reed_thickness = 3;

// The dent count, or number of threads per inch -- for example,
// 8-dent gives eight slots per inch to put threads through.
reed_dent = 8;

// Here's how you create patterns of holes and slots for the threads to fit
// through. The pattern is an array of lengths. Values that are less than
// or equal to 1 are treated as fractions of a full-length slot that goes
// all the way to the handles. Examples:
//
// * 1 = a slot that goes from the top to the bottom of the screen.
// * 0.1 = the hole is only 10% the height of the screen; the other 90%
//   is filled in.
//
// Values that are more than 1 are treated as lengths in millimetres. You
// may notice that this means you can't create an 1mm hole. That's tricky,
// because (a) you must have more dexterity than I do to thread something
// that thin, (b) your printer must have insanely good precision, and (c)
// the minimum hole length is the same as the hole width, which is
// calculated from the dent count:
//
//   hole width in inches = 1 ÷ dent count ÷ 2
//
// The pattern is repeated as many times as is necessary to fill up your
// reed panel, starting with a half-wide hole. I'd recommend a full slot
// for the first hole, because lining up two halves of a short hole might
// create alignment issues and sharp bits for the yarn to catch on.
// To see what I'm talking about, choose isometric view and look at it from
// directly above. See how the left and right edges of the screen are
// slightly narrower than than handles and have little scalloped corners?
// That's because they're both half of a slot.

// Here are some samples to get you going.

// An old-fashioned screen with nothing but full-length slots.
slots_reed_pattern = [1];

// A modern screen with alternating slots and holes.
slots_holes_reed_pattern = [1, 0.05];

// A fancy patterned screen for Sámi band weaving, similar to the ones
// made by Harvest Looms and Stoorstålka. Try it out on an 8-dent screen
// 2.5 inches wide to get a 7-band heddle (must be sandwiched between two
// conventional slot-and-hole panels to complete the heddle).
band_weaving_reed_pattern = [1, 0.5, 1, 0.05, 0.5, 0.05];

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
// to how much leftover space you expect to have after you've jammed a
// bunch of screen panels onto your bottom dowel.
//bottom_cap_length = 7.75;
 
//////// HERE'S WHERE YOU OUTPUT THE STUFF!

// Uncomment this line to build a whole screen panel. The first value is
// the width of the panel in mm (you can see I've specified it in inches
// then converted it to mm), while the second value is an array of hole
// sizes (see above for some examples). You can also override all the
// default values; see the screen() module below for parameter order.
//
// Keep in mind that you want your screen length to be some tidy multiple
// of the reeds you're specifying. For instance, a simple pattern of
// slots and holes in an 8-dent reed will repeat every 1/4 inch
// (1/8" hole spacing * 2 hole sizes in the pattern). So you'll want a
// screen length of some multiple of 1/4".
// The example given here uses the band weaving pattern to create a 7-band
// heddle panel to be used between two conventional slot-and-hole panels.
screen(2.5 * 25.4, band_weaving_reed_pattern);

// Uncomment this line to build a dowel cap for the top handle.
// Note that if you want to rely on pressure-fitting alone, you'll want to
// cut your top dowel a bit longer and increase the second param here.
// A good value might be cap_wall_thickness * 3 = 6mm, which means your
// top dowel should be 12mm longer than the instructions tell you.
//rotate([-90, 0, 0]) handle_with_fittings("cap", cap_wall_thickness);

// Uncomment this line to build a dowel cap for the bottom handle.
//rotate([-90, 0, 0]) handle_with_fittings("cap", bottom_cap_length);

// Uncomment these lines to build the minimal parts needed to print a
// presure-fitting test.
//rotate([90, 0, 0]) handle_with_fittings("fitting-tolerance-test");
//translate([0, -40, cap_wall_thickness]) rotate([-90, 0, 0]) handle_with_fittings("cap", cap_wall_thickness);

// Uncomment these lines to build a length of handle to act as a spacer
// (this example is for a 2" length). This might be useful if you want to
// assemble a heddle that's shorter than your loom width.
//rotate([0, 90, 0]) handle_with_fittings("screen", 2 * 25.4);

module screen(screen_length, reed_pattern, heddle_height = heddle_height, reed_dent = reed_dent, reed_thickness = reed_thickness) {
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