// For dowel caps, the thickness of the wall that supports the tongues
// and into which you screw a wood screw.
// FIXME: I don't know why I need it to be 0.001mm extra, but I do --
// otherwise the screw hole doesn't punch through the outside.
cap_wall_thickness = is_undef(cap_wall_thickness) ? 2.001 : cap_wall_thickness;

// The bottom caps are longer than the top caps, so the screen can
// reach all the way to the heddle brace. This is an approximation
// of the bottom cap lengths from the original design.
bottom_cap_length = 7.75;

// The amount by which to expand holes and shrink tongues.
// Adjust this to match the precision of your printer.
tolerance = is_undef(tolerance) ? 0 : tolerance;
include <countersunk_screw_hole.scad>;

// A hole for a countersunk wood screw to attach the handle caps
// to the dowel that runs through the handle of the entire heddle.
// Set this to false if you just want to pressure-fit the handle caps
// with the built-in tongues and notches.
// This setting applies only to dowel caps, not screen handles.
screw = is_undef(screw) ? no_3_screw : screw;

// Within reason, you can play around with the dowel size.
// Make sure the handle walls are thick enough though!
handle_dowel_dia = is_undef(handle_dowel_dia) ? 7/16 * 25.4 : handle_dowel_dia;

// You can change this independently from other tolerances to adjust
// for a dowel that's slightly bigger or smaller than advertised.
dowel_hole_tolerance = is_undef(dowel_hole_tolerance) ? tolerance : dowel_hole_tolerance;

// The size of the tongue and notch to attach the end caps to the
// dowel and the heddle screen panels. If you play with these values,
// make sure the handles have thick enough walls afterward!
fitting_size = is_undef(fitting_size) ? [4, 3, 2] : fitting_size;
fitting_offset_from_base = is_undef(fitting_offset_from_base) ? -14.25 : fitting_offset_from_base;

// This is the gap between the two fitting notches/tongues.
fitting_spacing = is_undef(fitting_spacing) ? 7 : fitting_spacing;

// The fittings are rotated slightly for optimal fit between the
// dowel hole and the curved outer edge.
fitting_rotation = 55;
fitting_tolerance = tolerance;

// If you want this to be compatible with the original loom's
// heddle block, treat the rest of the variables as constants.
handle_thickness = 15.5;
// Don't change this one; it'll cause weird things to happen.
fitting_depth_offset = fitting_size.y / 2 - 0.001;

// This constant doesn't actually affect anything; it's just a rough
// eyeballing of the amount the curved end pokes out beyond the cube.
handle_bezel_height = 2.5;
handle_height = handle_thickness + handle_bezel_height;

//handle_with_fittings("screen", 20);

module handle_with_fittings(style, length) {  
  if (style == "screen") {
    difference() {
      handle(length);
      translate([0, -0.001, 0]) fitting_cubes("notch");
      // I cannot for the life of me figure out where this 0.08 is coming from and why it's necessary.
      // Anyhow, a handle with notches needs them on both sides.
      translate([0, length - fitting_size.y + 0.08, 0]) fitting_cubes("notch");
    }
  } else {
    union() {
      handle(length);
      // A handle with tongues only needs one...
      translate([0, 0.001 - fitting_size.y, 0]) fitting_cubes("tongue");
      // Because the other end is just a cap.
      translate([-handle_thickness, length - cap_wall_thickness, 0]) difference() {
        cube([handle_thickness, cap_wall_thickness, handle_thickness]);
        if (screw) {
          // FIXME: not sure why the overlap has to be 0.01 instead of
          // 0.001 in order to work.
          translate([handle_thickness / 2, cap_wall_thickness + 0.01, handle_thickness / 2]) rotate([-90, 0, 0]) countersunk_screw_hole(screw[0], screw[1], cap_wall_thickness);
        }
      }
    }
  }
}

module fitting_cubes(component) {
  offset = component == "notch" ? fitting_tolerance : -fitting_tolerance;
  size = [
    fitting_size.x + offset,
    fitting_size.y + offset / 2,
    fitting_size.z + offset
  ];
  translate([fitting_offset_from_base, fitting_depth_offset, fitting_spacing / 2]) rotate([0, fitting_rotation, 0]) cube(size, center=true);
  translate([fitting_offset_from_base, fitting_depth_offset, handle_thickness - fitting_spacing / 2]) rotate([0, -fitting_rotation, 0]) cube(size, center=true);
}

module handle(length) {
  translate([handle_thickness / -2, length / 2, handle_thickness / 2]) difference() {
    union() {
      translate([handle_thickness / -2 + 0.65, 0, 0]) intersection() {
        scale([0.35, 1, 1]) rotate([-90, 0, 0]) cylinder(length, d=16, center=true);
        cube([handle_thickness * 2, length, handle_thickness], center=true);
      }
      
      cube([handle_thickness, length, handle_thickness], center=true);
    }
    
    translate([0, -0.001, 0]) rotate([-90, 0, 0]) cylinder(length + 0.002, d=handle_dowel_dia + dowel_hole_tolerance, center=true);
  }
}