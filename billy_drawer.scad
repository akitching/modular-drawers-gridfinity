
include <third_party/gridfinity-rebuilt-openscad/standard.scad>;
include <modules/constants.scad>
use <modules/gridfinity.scad>
use <models.scad>
use <modules/label.scad>
use <modules/drawer_handle.scad>
use <modules/design_helpers.scad>

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

    // Cut out handle mounting
    translate([0, base_unit_depth*depth_in_cells/2 + grid_edge_tolerance + drawer_wall_thickness, 0])
      translate([0, 0, drawer_outer_height/2])
      rotate([0, 0, 90])
      drawer_handle_cutouts(base_unit_width+grid_edge_tolerance+drawer_wall_thickness*2, drawer_wall_thickness);

    // Testing cutout
    *translate([0,0,-150]) cube([50,500,500]);
  }

  // Add handle
  *translate([0, base_unit_depth*depth_in_cells/2 + grid_edge_tolerance + drawer_wall_thickness, 0])
    translate([0 ,0, drawer_outer_height/2])
      handle(width_in_cells, height_in_units);

  // Add labels
  difference() {
    for (x=[0,1]) mirror([x,0,0])
      translate([0, base_unit_depth*depth_in_cells/2 + grid_edge_tolerance + drawer_wall_thickness, 0])
      translate([base_unit_width*width_in_cells/2 - 82/2, 0, 0])
      rotate([-90, 0, 0])
        label(width = 82, height = 24.5);

    // Ensure labels do not extend past the top and bottom edges of the drawer
    translate([0,0,5 + drawer_outer_height/2])
      cube([1000, 1000, 10], center = true);
    translate([0,0,-5 - drawer_outer_height/2])
      cube([1000, 1000, 10], center = true);
  }

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

  module handle(width_in_cells, height_in_units) {
    //translate([-2.5, 0, -5])
    difference() {
      handle_shape(width_in_cells);
      translate([0, 0, -2])
      scale([0.92, 0.92, 1])
        handle_shape(width_in_cells);
    }
    translate([0, 0, 0])
      print_point_ids(points = handle_points(width_in_cells, height_in_units));

    module handle_shape(width_in_cells) {
      translate([0, 0, 0])
      polyhedron(
        points = handle_points(width_in_cells, height_in_units),
        faces = [
          [0, 1, 2],
          [0, 2, 5, 3],
          [3, 5, 4],
          [2, 1, 4, 5],
          [0, 3, 4, 1],
        ],
        convexity = 1);
    }

    function handle_points(width_in_cells, height_in_units) = [
      -handle_top_x_vector(width_in_cells),
      -handle_bottom_x_vector(width_in_cells) + handle_bottom_z_vector(height_in_units),
      -handle_middle_x_vector(width_in_cells) + handle_middle_y_vector() + handle_middle_z_vector(height_in_units),
      handle_top_x_vector(width_in_cells),
      handle_bottom_x_vector(width_in_cells) + handle_bottom_z_vector(height_in_units),
      handle_middle_x_vector(width_in_cells) + handle_middle_y_vector() + handle_middle_z_vector(height_in_units),
    ];

    function handle_middle_z_vector(height_in_units) = [0, 0, -14];
    function handle_bottom_z_vector(height_in_units) = height_in_units == 1
      ? [0, 0, -drawer_outer_height]
      : [ 0, 0, -28];

    function handle_top_x_vector(width_in_cells) = [base_unit_width/2, 0, 0];
    function handle_middle_x_vector(width_in_cells) = width_in_cells == 1
      ? handle_top_x_vector(width_in_cells)
      : handle_top_x_vector(width_in_cells) + [0, 0, 0];
    function handle_bottom_x_vector(width_in_cells) = width_in_cells == 1
      ? handle_top_x_vector(width_in_cells)
      : handle_top_x_vector(width_in_cells) + [0, 0, 0];

    function handle_middle_y_vector() = [0, 15, 0];
  }
}

billy_drawer(width_in_cells = 8, depth_in_cells = 7, height_in_units = 1);

//echo(bp_h_bot); // 6.4
//echo(h_base); // 5
