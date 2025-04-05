
include <third_party/gridfinity-rebuilt-openscad/standard.scad>;
include <modules/constants.scad>
use <modules/gridfinity.scad>
use <models.scad>
use <modules/label.scad>

module billy_drawer(height_in_units=1, width_in_cells = 8, depth_in_cells = 7) {
  drawer_outer_height = height_in_units*32 - 3 /* lip thickness */ - 0.5 /* tolerance */;
  drawer_grid_thickness = h_base; // 5;//bp_h_bot;
  //drawer_inner_height = drawer_outer_height - drawer_base_thickness;
  drawer_base_thickness = 0; // 0.4;

  difference() {
    drawer_outer_box(height_in_units, width_in_cells, depth_in_cells);
    translate([0, 0, drawer_grid_thickness])
    drawer_inner_box(height_in_units, width_in_cells, depth_in_cells);
    // Cut out grid
    translate([ 0, 0, -drawer_outer_height/2 -h_base +drawer_base_thickness ])
      rotate([0,0,90])
      gridfinity_baseplate_cut(width_in_cells, depth_in_cells, 0, extrude=false, deep=false);

    // Testing cutout
    *translate([0,0,-150]) cube([50,500,500]);
  }
  // Add handle
  // Add labels

  module drawer_outer_box(height_in_units, width_in_cells, depth_in_cells) {
    cube([
      base_unit_width*width_in_cells+grid_edge_tolerance+drawer_wall_thickness*2,
      base_unit_depth*depth_in_cells+grid_edge_tolerance+drawer_wall_thickness*2,
      drawer_outer_height
    ],
    center = true);
  }

  module drawer_inner_box(height_in_units, width_in_cells, depth_in_cells) {
    cube([
    base_unit_width*width_in_cells+grid_edge_tolerance,
    base_unit_depth*depth_in_cells+grid_edge_tolerance,
    drawer_outer_height
    ],
    center = true);
  }
}

billy_drawer(width_in_cells = 1, depth_in_cells = 2, height_in_units = 1);

//echo(bp_h_bot); // 6.4
//echo(h_base); // 5
