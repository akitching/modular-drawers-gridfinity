include <constants.scad>
include <round-anything/polyround.scad>
use <design_helpers.scad>

rotate([-90,0,0])
union() {
  translate([0, 0, -1.5])
    cube([100, 30, 3], center = true);
  label(82, 24.5);
  translate([0, 15-1.5, -5])
    cube([100, 3, 10], center = true);
}

module label(width, height) {
  mount_thickness = 2;
  edge_thickness = 2;
  top_radius = 0.5;
  base_radius = -0.8;

  slot_thickness = 1;
  slot_overlap = 1.5;

  points = [
    // [x, y, radius],
    [width/2 + edge_thickness, 0, 0],
    [width/2 + edge_thickness, height + edge_thickness*2, 1.5],
    [-width/2 - edge_thickness, height + edge_thickness*2, 1.5],
    [-width/2 - edge_thickness, 0, 0],
  ];

  label_points = [
    [-width/2, -height/2, 0],
    [-width/2, height/2, 2],
    [width/2, height/2, 2],
    [width/2, -height/2, 0],
  ];

  face_cutout_points = label_points;
  mounting_points = [
    [-width/2, -height/2 - slot_overlap, 0],
    [-width/2, height/2, 2],
    [width/2, height/2, 2],
    [width/2, -height/2 - slot_overlap, 0],
  ];
  lower_edge_points = [
    //[-width/2, height/2-0.1, 0],
    [-width/2, height/2, 0],
    [0, height/2, 0],
    [width/2, height/2, 0],
    //[width/2, height/2-0.1, 0],
  ];

  //print_point_ids_2d(label_points);
  //print_point_ids_2d(lower_edge_points);

  *translate([0, 0, 0.5]) 
  #polygon(polyRound(label_points));

  chain = beamChain(mounting_points, offset1 = -0.5, offset2 = -1.5);
  chainTop = beamChain(mounting_points, offset1 = -0.5 + slot_overlap, offset2 = -1.5);
  chainLowerEdge = beamChain(mounting_points, offset1 = -0.5, offset2 = -1.5);
  //print_point_ids_2d(chain);
  //print_point_ids_2d(chainTop);
  //print_point_ids_2d(chainLowerEdge);

  // Create outline
  linear_extrude(height = slot_thickness, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
    polygon(polyRound(chain, fn=50), 20);
  //*polyRoundExtrude(chain, slot_thickness, 0, -0.5, fn=50);

  // Add overlap
  translate([0, 0, slot_thickness])
    polyRoundExtrude(chainTop, mount_thickness - slot_thickness, top_radius, 0, fn=50);

  // Add gradient to underside
  //translate([0, 1.5, 0])
  difference() {
    polyRoundExtrude(chainLowerEdge,
      //paths = [[0,1], [1,2], [2,3], [3,0]],
      mount_thickness - slot_thickness, 0, -1.2);//, fn=50);
    translate([0, 0, -5])
    scale([1.01,1.01,1])
    linear_extrude(10, center = false)
    //#linear_extrude(height = slot_thickness, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
      polygon(radiiPoints_to_vector2_array(mounting_points));
  }

  *difference() {
    polyRoundExtrude(mounting_points, mount_thickness, top_radius, base_radius, fn=50);

    //translate([0, -height/4+edge_thickness, slot_thickness/2])
    translate([0, 0, slot_thickness])
      cube([width, height*2, slot_thickness], center = true);

    translate([0, 0, slot_thickness*2])
      #cube([width - slot_overlap*2, height*2 - slot_overlap*2, mount_thickness - slot_thickness], center = true);
  }
}

function radiiPoints_to_vector2_array(radiiPoints) = 
  [each [ for (point = radiiPoints) [point.x, point.y] ]];
//for (point = radiiPoints)
//{
  //[point.x, point.y]
//}

module label_mount(width) {
  difference() {
    label_faceplate(width, label_height, label_depth, label_radius);

    translate([
      label_mount_width+label_mount_overlap,
      label_mount_width+label_mount_overlap,
      0
    ]) label_face_cutout(width, label_height, label_depth, label_radius);

    translate([label_mount_width, label_mount_width, 0])
      label_slot(width, label_height, label_depth, label_radius);
  }
}

module label_face_cutout(width, height, depth, radius) {
  left_edge = radius;
  right_edge = left_edge + width - (label_mount_overlap*2);
  bottom_edge = radius;
  top_edge = bottom_edge + height - (label_mount_overlap*2);

  union() {
    rounded_rectangle(top_edge, bottom_edge, left_edge, right_edge, depth*2, radius);
    rounded_rectangle(
      top_edge+5,
      bottom_edge+5,
      left_edge+label_cutout_lip,
      right_edge-label_cutout_lip,
      depth*2,
      radius
    );
  }
}

module label_faceplate(width, height, depth, radius) {
  left_edge = radius;
  right_edge = left_edge + width + (label_mount_width*2);
  bottom_edge = label_radius;
  top_edge = bottom_edge + height + (label_mount_width*2);

  rounded_rectangle(top_edge, bottom_edge, left_edge, right_edge, depth*2, radius);
}

module label_slot(width, height, depth, radius) {
  left_edge = radius;
  right_edge = left_edge + width;
  bottom_edge = radius;
  top_edge = bottom_edge + height;

  translate([0,0,depth])
  rounded_rectangle(top_edge, bottom_edge, left_edge, right_edge, depth + label_depth_tolerance, radius);
}

module rounded_rectangle(top_edge, bottom_edge, left_edge, right_edge, depth, radius) {
  hull() {
    translate([left_edge, bottom_edge, 0])
      cylinder (h = depth, r = radius);
    translate([left_edge, top_edge, 0])
      cylinder (h = depth, r = radius);
    translate([right_edge, bottom_edge, 0])
      cylinder (h = depth, r = radius);
    translate([right_edge, top_edge, 0])
      cylinder (h = depth, r = radius);
  }
}
