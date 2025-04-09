use <design_helpers.scad>
include <round-anything/polyround.scad>
include <constants.scad>

handle_thickness = 4;
head_width = 15;
base_width = 10;

function handle_connector_points(mount_depth) = [
  [0, -base_width/2],
  [0, base_width/2],
  [-mount_depth, head_width/2],
  [-mount_depth, -head_width/2],
];
function handle_connector_mount_points(mount_depth, tolerance = 0.1) =
  let(
    points = handle_connector_points(mount_depth),
    x_vector = [tolerance, 0, 0],
    y_vector = [0, tolerance/2, 0]
  )
  [
    points[0] + x_vector - y_vector,
    points[1] + x_vector + y_vector,
    points[2] - x_vector + y_vector,
    points[3] - x_vector - y_vector
  ];

drawer_handle(42+grid_edge_tolerance+drawer_wall_thickness*2, 3);

module drawer_handle(width, mount_depth) {

  translate([0, 0, -handle_thickness/2])
  rotate([-90, 0, 0])
  union() {
    translate([0, 0, -width/2])
      main_body(width);
    for (z=[0,1]) mirror([0, 0, z])
      translate([0, 0, width/4])
        handle_connector(handle_connector_points(mount_depth));
  }

  module main_body(width) {
    radiiPoints = [
      [-10,0,0],
      [15,0,0],
      [20,5,0],
      [20,10,1],
    ];
    startAngle = -45;
    endAngle = 45;

    chain = beamChain(radiiPoints,offset1=handle_thickness/2, offset2=-handle_thickness/2, startAngle = startAngle, endAngle=endAngle);
    difference() {
      polyRoundExtrude(radiiPoints = chain, length = width, r1 = 1.25, r2 = 1.25, fn = 10, convexity = 10);
      translate([-30, -handle_thickness, -width/2])
      cube([30, handle_thickness*2, width*2]);
    }
  }
}

module handle_connector(points) {
  translate([0, handle_thickness/2, 0])
    rotate([90,0,0]) {
      linear_extrude(height = handle_thickness, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
        polygon(points = points);
      print_point_ids_2d(points);
    }
}

module drawer_handle_cutouts(width, mount_depth) {
  translate([0, 0, -handle_thickness/2])
  rotate([-90, 0, 0])
    for (z=[0,1]) mirror([0, 0, z])
      translate([0, 0, width/4])
        handle_connector(handle_connector_mount_points(mount_depth, tolerance = 0.1));
}
