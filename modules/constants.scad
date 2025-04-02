// Base dimensions of each drawer housing unit, excluding connectors
base_unit_width = 42;
base_unit_height = 6*7; // 66; // 2 + (6*7)+ceil(h_base+bp_h_bot)+(2*housing_wall_thickness);
base_unit_depth = 42;
grid_edge_tolerance = 2;

// Calculated width/height to add for each unit beyond the first
extra_unit_width = base_unit_width;
extra_unit_height = base_unit_height;

// Wall thickness
housing_wall_thickness = 5.0;
drawer_wall_thickness = 3.0;
back_wall_thickness = housing_wall_thickness * 0.6;

// Outer chamfering
chamfer_amount = 4.0;

// Connector and channel configuration
dovetail_size = housing_wall_thickness * 0.6;
dovetail_depth_percent = 0.8;
connector_support_tolerance = dovetail_size * 0.2;

// Drawer handle base size
drawer_handle_base_size = base_unit_height/2-2*housing_wall_thickness-drawer_wall_thickness;

// Label
label_height = 24.5;
label_depth = 0.85;
label_radius = 3.5;
label_champher = 0.2;

label_mount_width = 2;
label_mount_overlap = 0.5;
label_cutout_lip = 2;
label_depth_tolerance = 0.1;
