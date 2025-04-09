
module print_point_ids(points)
{
  for (pointIndex = [0: len(points) -1]) {
    translate(points[pointIndex] + [0,0,1])
    rotate([90, 0, 180])
      #text(str(pointIndex), size=1, halign = "center", valign = "center");
    translate(points[pointIndex])
      %cube(1, center = true);
  }
}

module print_point_ids_2d(points)
{
  for (pointIndex = [0: len(points) -1]) {
    point = points[pointIndex];
    pos = [point.x, point.y, 0];
    translate(pos + [0,0,1])
    rotate([90, 0, 180])
      #text(str(pointIndex), size=1, halign = "center", valign = "center");
    translate(pos)
      %cube(1, center = true);
  }
}
