no_0_screw = [ .119 * 25.4, .06 * 25.4 ];
no_1_screw = [ .146 * 25.4, .073 * 25.4 ];
no_2_screw = [ 11/64 * 25.4, 3/32 * 25.4 ];
no_3_screw = [ 13/64 * 25.4, 7/64 * 25.4 ];
no_4_screw = [ 15/64 * 25.4, 7/64 * 25.4 ];
no_5_screw = [ 1/4 * 25.4, 1/8 * 25.4 ];
no_6_screw = [ 9/32 * 25.4, 9/64 * 25.4 ];
no_7_screw = [ 5/16 * 25.4, 5/32 * 25.4 ];
no_8_screw = [ 11/32 * 25.4, 5/32 * 25.4 ];
no_9_screw = [ 23/64 * 25.4, 11/64 * 25.4 ];
no_10_screw = [ 25/64 * 25.4, 3/16 * 25.4 ];
american_screw_sizes = [
  no_0_screw,
  no_1_screw,
  no_2_screw,
  no_3_screw,
  no_4_screw,
  no_5_screw,
  no_6_screw,
  no_7_screw,
  no_8_screw,
  no_9_screw,
  no_10_screw
];

function american_screw_size(number) = american_screw_sizes[number];

module countersunk_screw_hole(head_dia, shank_dia, shank_length) {
  head_depth = (head_dia - shank_dia) / 2;
  rotate([180, 0, 0]) union() {
    cylinder(head_depth, d1=head_dia, d2=shank_dia);
    translate([0, 0, head_depth - 0.001]) cylinder(shank_length, d=shank_dia);
  }
}