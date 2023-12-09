$fn = 40;

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
// made by Harvest Looms and Stoorstålka. Try it out on an 8-dent screen:
//
// * 1.75" will give you a 5-band heddle
// * 2.5" for a 7-band heddle
// * 3.5" for a 9-band heddle
//
// You need to sandwich the panel between two conventional slot-and-hole
// panels to complete the heddle.
band_weaving_reed_pattern_1 = [1, 0.5, 1, 0.05, 0.5, 0.05];

// Another popular patterned screen style for Sámi band weaving. This is
// meant to be assembled with one (or more) panel(s) on the left and
// identical one(s) on theright, but flipped, forming a mirror image.
// If you do 8-dent, make sure each panel is a multiple of 3/4" wide.
// Similarly for 12-dent, make it a multiple of 0.5" wide. Et cetera!
band_weaving_reed_pattern_2 = [1, 0.05, 0.333];

//// HEDDLE HANDLE SETTINGS

// These values affect the handles that run the top and bottom of the
// screens, as wel as the dowel caps that hold the assembly together.
// This design is different from ten16's original, in that the dowels are
// held in by end caps rather than screws (although you can choose to put
// screws into the end caps).

// The diameter of the dowel that runs the length of the heddle handles.
// Measure your dowel and change this value if it deviates from 7/16".
handle_dowel_dia = 7/16 * 25.4;

// For dowel caps, the thickness of the wall that supports the tongues
// and into which you screw an optional wood screw.
// FIXME: I don't know why it needs to be 0.001mm extra, but it does --
// otherwise the screw hole doesn't punch through the outside.
cap_wall_thickness = 2.001;

// A hole for a countersunk wood screw to attach the end caps to the dowel
// that runs through the handle of the entire heddle. You can choose an
// American screw number from countersunk_screw_hole_scad; I've commented
// out an example that uses a #3 screw.
// Keep this false if you just want to pressure-fit the end caps onto the
// dowels like I do.
include <countersunk_screw_hole.scad>;
//screw = no_3_screw;
screw = false;

// The bottom dowel caps are a bit longer than the top; this is so that
// they can reach all the way to the heddle brace. Adjust the length
// according to how much leftover space you expect to have after you've
// jammed a bunch of screen panels onto your bottom dowel. The default
// value matches that of the original design from ten16, although you'll
// have to cut your bottom dowels shorter by cap_wall_thickness × 2 to
// accommodate the dowel cap walls.
bottom_cap_length = 7.75;

// How much of a pressure fitting to put on the dowel caps. The total
// length of the top dowel caps will be this value plus the cap wall
// thickness (so you'll have to cut your top dowels this much longer than
// ten16's instructions), and the bottom dowel caps will just have a
// tighter bit of this length at the very end of the dowel holes (no
// adjustment needed here beyond what's described for the previous var).
// NOTE THAT this value can be zero if you're using a wood screw, in which
// case your top dowels can be the length that ten16 gives.
dowel_pressure_fitting_length = screw ? 0 : 4;

top_cap_length = cap_wall_thickness + dowel_pressure_fitting_length;

//// MORTISE AND TENON

// The dowel end caps need some way of locking into the panel of screen
// adjacent to them to prevent the whole dowel from rotating relative to
// the assembly. We use a little tongue and notch -- a mortise and tenon
// -- to make that happen. You don't need to worry about these settings
// unless you have troubles printing them and need to adjust.

// The dimensions of the mortise and tenon.
mortise_tenon_size = [4, 3, 2];

// The distance of the mortise and tenon from the non-curved end of the
// handle.
mortise_tenon_offset_from_base = -14.25;

// The gap between the two mortises and tenons.
mortise_tenon_spacing = 7;

// The fittings are rotated slightly for optimal fit between the
// dowel hole and the curved outer edge.
mortise_tenon_rotation = 55;

//// TOLERANCES

// Do some test prints with the default values (you can find some lines
// below to generate models for test prints) and twiddle these settings
// as needed. There are three places the tolerances are used:
//
// * The screen handles, into which the dowels go -- this should be loose
//   enough for the dowels to slide right through, but not so loose that
//   they wobble around sloppily.
// * The mortise-and-tenon joints in the dowel end caps -- these don't need
//   to be snug, and in fact shouldn't (I've had tenons break off). They
//   only need to be tight enough to not wobble around.
// * Pressure fittings in the dowel end caps -- if you're using screws, the
//   dowel holes in the end caps can be the same diameter as the ones in
//   the screen handles, but if you're using pressure fitting, they should
//   be snug.

// The gap between things that should fit snugly together.
pressure_fitting_tolerance = 0.05;

// The gap between things that should _not_ fit snugly together.
loose_tolerance = 0.1;

// The vagaries of 3D printing might mean you need to adjust the mortise
// and tenon tolerance separately from the dowel tolerance. You can adjust
// dowel tolerance by changing handle_dowel_dia, but changing
// mortise_tenon_size won't work the same, because it'll adjust both the
// mortises and tenons!
mortise_tenon_tolerance = loose_tolerance;
 
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
//screen(2.5 * 25.4, band_weaving_reed_pattern_1);

// Uncomment this line to build a dowel cap for the top handle.
// Note that if you want to rely on pressure-fitting alone, you'll want to
// cut your top dowel a bit longer and increase the second param here.
// A good value might be cap_wall_thickness * 3 = 6mm, which means 4mm of
// the top dowel would fit into the end cap, which means it should be 8mm
// longer than the instructions tell you.
//rotate([-90, 0, 0]) handle_with_fittings("cap", top_cap_length, screw);

// Uncomment this line to build a dowel cap for the bottom handle.
//rotate([-90, 0, 0]) handle_with_fittings("cap", bottom_cap_length, screw);

// Uncomment these lines to build the minimal parts needed to print a
// presure-fitting test.
//rotate([90, 0, 0]) handle_with_fittings("tolerance-test");
//translate([0, -40, top_cap_length]) rotate([-90, 0, 0]) handle_with_fittings("cap", top_cap_length);

// Uncomment these lines to build a length of handle to act as a spacer
// (this example is for a 2" length). This might be useful if you want to
// assemble a heddle that's shorter than your loom width.
//rotate([0, 90, 0]) handle_with_fittings("screen", 2 * 25.4);

//// DON'T TOUCH

// Treat the following as constants if you want to maintain compatibility
// with ten16's original heddle brace.

// The thickness of the handle, yup.
handle_thickness = 15.5;

// This constant doesn't actually affect anything; it's just a rough
// eyeballing of the amount the curved end pokes out beyond the cube.
handle_bezel_height = 2.5;
handle_height = handle_thickness + handle_bezel_height;

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

module handle_with_fittings(style, length, screw = false) {
  if (style == "screen") {
    difference() {
      handle(length);

      // The dowel hole.
      translate([handle_thickness / -2, -0.001, handle_thickness / 2]) rotate([-90, 0, 0]) cylinder(length + 0.002, d=handle_dowel_dia + loose_tolerance * 2);

      translate([0, -0.001, 0]) mortise_tenon_cubes("notch");
      // I cannot for the life of me figure out where this 0.08 is coming from and why it's necessary.
      // Anyhow, a handle with notches needs them on both sides.
      translate([0, length - mortise_tenon_size.y + 0.08, 0]) mortise_tenon_cubes("notch");
    }
  } else if (style == "tolerance-test") {
    length = cap_wall_thickness + mortise_tenon_size.y + mortise_tenon_tolerance / 2;
    difference() {
      handle(length);
      translate([0, length - mortise_tenon_size.y + 0.08, 0]) mortise_tenon_cubes("notch");
      translate([handle_thickness / -2, -0.001, handle_thickness / 2]) rotate([-90, 0, 0]) cylinder(length + 0.002, d=handle_dowel_dia + loose_tolerance * 2);
    }
  } else if (style == "cap") {
    difference() {
      union() {
        handle(length);
        translate([0, 0.001 - mortise_tenon_size.y, 0]) mortise_tenon_cubes("tongue");
      };
      dowel_hole_length = length - cap_wall_thickness;
      dowel_hole_length_beyond_pressure_fitting = dowel_hole_length - dowel_pressure_fitting_length;
      if (dowel_pressure_fitting_length > 0) {
        translate([handle_thickness / -2, dowel_hole_length_beyond_pressure_fitting - 0.001, handle_thickness / 2]) rotate([-90, 0, 0]) cylinder(dowel_pressure_fitting_length + 0.001, d=handle_dowel_dia + pressure_fitting_tolerance * 2);
      }
      if (dowel_hole_length_beyond_pressure_fitting > 0) {
        translate([handle_thickness / -2, -0.001, handle_thickness / 2]) rotate([-90, 0, 0]) cylinder(dowel_hole_length_beyond_pressure_fitting + 0.001, d=handle_dowel_dia + loose_tolerance * 2);
      }
      if (screw) {
        // FIXME: not sure why the overlap has to be 0.01 instead of
        // 0.001 in order to work.
        translate([handle_thickness / -2, length + 0.01, handle_thickness / 2]) rotate([-90, 0, 0]) countersunk_screw_hole(screw[0], screw[1], cap_wall_thickness);
      }
    }
  }
}

module mortise_tenon_cubes(component) {
  mortise_tenon_depth_offset = mortise_tenon_size.y / 2 - 0.001;
  offset = component == "notch" ? mortise_tenon_tolerance : -mortise_tenon_tolerance;
  size = [
    mortise_tenon_size.x + offset,
    mortise_tenon_size.y + offset / 2,
    mortise_tenon_size.z + offset
  ];
  translate([mortise_tenon_offset_from_base, mortise_tenon_depth_offset, mortise_tenon_spacing / 2]) rotate([0, mortise_tenon_rotation, 0]) cube(size, center=true);
  translate([mortise_tenon_offset_from_base, mortise_tenon_depth_offset, handle_thickness - mortise_tenon_spacing / 2]) rotate([0, -mortise_tenon_rotation, 0]) cube(size, center=true);
}

module handle(length) {
  translate([handle_thickness / -2, length / 2, handle_thickness / 2]) union() {
    translate([handle_thickness / -2 + 0.65, 0, 0]) intersection() {
      scale([0.35, 1, 1]) rotate([-90, 0, 0]) cylinder(length, d=16, center=true);
      cube([handle_thickness * 2, length, handle_thickness], center=true);
    }

    cube([handle_thickness, length, handle_thickness], center=true);
  }
}