module billy_drawer_mounts(height_in_units=1, lips_on_level=[0], stop_block=false) {
  alcove_depth = 258;
  alcove_width = 362;
  depth = 258;

  billy_rail(height_in_units, lips_on_level);

  translate([0,-alcove_width,0])
  mirror(v = [0,1,0]) 
  billy_rail(height_in_units, lips_on_level);

  module billy_rail(units, lips_on_level) {
    union() {
      side_wall(units);
      lips(lips_on_level);
    }
  }

  module side_wall(units) {
    height = units*32;
    length = alcove_depth;
    width = 21/2 - 0.5; // (non-drawer space / 2) - tolerance;
    difference() {
      cube([length, width, height], center=false);
      mounting_holes_for_rail(units);
    }
  }

  module lips(levels) {
    width = 16;
    thickness = 3;
    front_offset = 25;
    rear_offset = 25;
    depth = alcove_depth - front_offset - rear_offset;

    for (level = levels) {
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
    horizontal_spacing = 194;

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
billy_drawer_mounts(height_in_units = 6, lips_on_level = [0,2,4], stop_block = false);
