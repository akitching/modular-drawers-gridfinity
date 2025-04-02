/********
 *
 */

module rail(length, drawer_height, thickness, stop_block=false)
{
  drawer_tolerance = 1;

  lip_height = 3;
  lip_width = 16;

  screw_hole_diameter = 4;
  screw_hole_tolerance = 0.5;
  screw_head_diameter = 8;
  screw_head_depth = screw_head_diameter/2;

  union() {
    side(length, thickness-drawer_tolerance, drawer_height);
    lip(length, lip_width, lip_height);
  }

  module side(length, width, height) {
    difference() {
      cube([length, width, height+lip_height], center=false);
      translate([0,0,lip_height-5.5])
      mounting_holes(length, height);
    }
  }

  module lip(length, width, height) {
    translate([0,-width,0]) cube([length, width, height], center=false);
  }

  module mounting_holes(length, height) {
    setback_from_front_edge = 36.5;
    vertical_spacing = 32;

    front_column = setback_from_front_edge - screw_hole_diameter;
    rear_column = length - setback_from_front_edge + screw_hole_diameter;
    bottom_row = height/2 - (vertical_spacing/2);
    top_row = bottom_row + vertical_spacing;

    translate([front_column,0,bottom_row]) rotate([-90,0,0]) screw_hole();
    translate([front_column,0,top_row]) rotate([-90,0,0]) screw_hole();
    translate([rear_column,0,bottom_row]) rotate([-90,0,0]) screw_hole();
    translate([rear_column,0,top_row]) rotate([-90,0,0]) screw_hole();
  }

  module screw_hole() {
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


rail(length=267, drawer_height=32*2-3, thickness=21/2);
*translate([0,0,32*2])
%rail(length=267, drawer_height=32*2-3, thickness=21/2);
*%rail(length=267, drawer_height=56, thickness=21/2);
