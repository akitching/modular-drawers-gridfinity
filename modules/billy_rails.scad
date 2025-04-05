include <round-anything/polyround.scad>

module billy_drawer_mounts(height_in_units=1, lips_on_level=[0], stop_block=false) {
  alcove_depth = 258;
  alcove_width = 362;
  depth = 258;

  drawer_width = 362-21;
  drawer_tolerance = 0.5;
  side_width = (alcove_width - drawer_width) / 2 - drawer_tolerance;

  // Rails
  billy_rail(height_in_units, lips_on_level);

  // Supports
  support_head_width = 12;
  support_base_width = 7;
  support_horizontal_length = 5;
  support_angle_in_degrees = 30;
  support_vertical_thickness = 3;

  translate([0,-alcove_width,0])
  mirror(v = [0,1,0]) 
  billy_rail(height_in_units, lips_on_level);

  // Supports
  for (i = lips_on_level) {
    if (i < height_in_units) {
      
      offset = [0,0,32*i];
      translate([-50,0,0] + offset)
      lateral_support();
      translate([-100,0,0] + offset)
      lateral_support();
    }
  }

  module billy_rail(units, lips_on_level) {
    union() {
      side_wall(units, lips_on_level);
      lips(units, lips_on_level);
    }
  }

  module side_wall(units, lips_on_level) {
    height = units*32;
    length = alcove_depth;
    width = side_width; // 21/2 - 0.5; // (non-drawer space / 2) - tolerance;
    difference() {
      cube([length, width, height], center=false);
      mounting_holes_for_rail(units);
      support_slots(lips_on_level);
    }
  }

  module support_slots(levels) {
    for (level = levels) {
      translate([0, 0, level*32])
        translate([25/2, 0, 0])
          support_connector_slot_negative(0.5);

      translate([0, 0, level*32])
        translate([depth - 25/2, 0, 0])
          support_connector_slot_negative(0.5);
    }
  }

  module support_connector_slot_negative(units = 1) {
    union() {
      difference() {
        linear_extrude(height = units*32, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
          support_connector_shadow(0.2);
          // Cut off bottom
          support_lower_cutoff();
      }
      // Add entry cavity
      translate([0,-1,units*32-support_connector_entry_cavity_height])
        support_connector_entry_cavity();
    }
  }

  support_connector_entry_cavity_height = 7;
  module support_connector_entry_cavity() {
    width = support_head_width + 0.1;
    translate([-width/2,0,0])
      linear_extrude(height = support_connector_entry_cavity_height, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
        polygon(polyRound([
          [0,0,0],
          [0, support_horizontal_length + 1.1, 1],
          [width, support_horizontal_length + 1.1, 1],
          [width, 0, 0],
        ], 10));
  }

  module lateral_support() {
    support_length = alcove_width - side_width*2;

    rotate([0,0,-90])
      union() {
        cube([support_length, 25, 3]);

        translate([0, 25/2, 0])
          mirror([0,1,0])
            rotate([0,0,90])
              support_connector();

        translate([0, 25/2, 0])
          translate([support_length,0,0])
            rotate([0,0,-90])
              support_connector();
      }
  }

  module support_connector() {
    head_width = 12;
    base_width = 7;
    horizontal_length = 5;
    angle_in_degrees = 30;
    vertical_thickness = 3;

    horizontal_delta = head_width - base_width;

    base_left = [-horizontal_delta/2, 0, 0];
    head_left = [0, horizontal_length, 3];
    base_right = base_left -[base_width, 0, 0];
    head_right = head_left - [head_width, 0, 0];

    vertical_vector = [0, 0, 3];

    overlap_vector = [0,-5];

    //mirror([1,0,0])
    //translate([head_width/2,0,0])
    difference() {
      linear_extrude(height = vertical_thickness*3, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
        support_connector_shadow(0);

      support_lower_cutoff();
      support_upper_cutoff();
    }
  }

  module support_lower_cutoff() {
    translate([-support_head_width/2,0,0])
      rotate([215,0,0])
        translate([-support_head_width/2,-10,0])
          cube([support_head_width*2,10,10]);
  }

  module support_upper_cutoff() {
    translate([-support_head_width/2,0,0])
      translate([0,0,3]) 
        rotate([30,0,0])
          cube([support_head_width,10,10]);
    translate([-support_head_width/2,0,0])
      translate([0,0,3]) 
        rotate([90,0,0])
          cube([support_head_width, 10, 10]);
  }

  module support_connector_shadow(padding = 0) {
    translate([-support_head_width/2,0,0])
      polygon(polyRound(
        padding > 0
          ? offsetPolygonPoints(support_connector_points(padding), padding)
          : support_connector_points(),
      10));
  }

  function support_connector_points(radius_modifier = 0) = [
    [support_base_width/2, 0, 0],                         // base left
    [0, support_horizontal_length, 0.5 + radius_modifier],                  // head left
    [support_head_width, support_horizontal_length, 0.5 + radius_modifier], // head right 
    [support_head_width - support_base_width/2, 0, 0],    // base right
    [support_head_width - support_base_width/2, -5, 0],   // inner right
    [support_base_width/2, -5, 0],                        // inner left
  ];

  module lips(units, levels) {
    width = 16;
    thickness = 3;
    front_offset = 25;
    rear_offset = 25;
    depth = alcove_depth - front_offset - rear_offset;

    for (level = levels) {
      if (level < units)
        translate([front_offset,0,32*level])
          lip(depth, width, thickness);
    }
  }

  module lip(length, width, height) {
    translate([0,-width,0]) cube([length, width, height], center=false);
  }

  module mounting_holes_for_rail(units) {
    setback_from_front_edge = 36.5;
    first_layer_height = 11.5;
    vertical_spacing = 32;
    horizontal_spacing = 194 - 1.5;

    for (level = [0:units-1]) {
      height = first_layer_height + (level*vertical_spacing);
      mounting_hole_row([setback_from_front_edge,0,height], [setback_from_front_edge + horizontal_spacing,0,height]);
    }
  }

  module mounting_hole_row(front, rear) {
    #translate(front) rotate([-90,0,0]) screw_hole();
    #translate(rear) rotate([-90,0,0]) screw_hole();
  }

  module screw_hole() {
    screw_hole_diameter = 4;
    screw_hole_tolerance = 0.5;
    screw_head_diameter = 8;
    screw_head_depth = screw_head_diameter/2;

    union() {
      cylinder(r=screw_hole_diameter/2+screw_hole_tolerance,h=50);
      rotate([0,180,0])
      translate([0,0,-screw_head_depth-1])
      cylinder(r1=0,r2=screw_head_diameter/2+screw_hole_tolerance,h=screw_head_depth);
      translate([0,0,-1])
      cylinder(r=screw_head_diameter/2+screw_hole_tolerance, h=2);
    }
  }
}

*translate([300,0,64])
  billy_drawer_mounts(2);

*translate([300,0,0])
  billy_drawer_mounts(1);

*translate([300,0,32])
  billy_drawer_mounts(1);

//translate(v = [0,0,0])
billy_drawer_mounts(height_in_units = 5, lips_on_level = [0,2,4,6,8], stop_block = false);

translate(v = [0,0,-64])
billy_drawer_mounts(height_in_units = 1, lips_on_level = [0,1,2,4,6,8], stop_block = false);

*difference() {
  cube([258,10,0.6]);
  translate([36.5, 5, 0]) cylinder(h = 5, r = 2.5);
  translate([36.5 + 194 - 1.5, 5, 0]) cylinder(h = 5, r = 2.5);
}
