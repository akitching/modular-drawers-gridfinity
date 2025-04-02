include <constants.scad>

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
