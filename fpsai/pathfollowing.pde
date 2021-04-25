abstract class Path extends GameObject {
  abstract PVector getPosition(float param);
  abstract float getParam(PVector position, float lastParam);
}


class PointPath extends Path {

  ArrayList<PVector> points = new ArrayList<PVector>();
  float scale = 1.0;
  float range = 2.0;

  void addPoint(PVector point) {
    points.add(point);
  }

  PVector getPosition(float param) {
    int index = round(param / scale);


    if (index < points.size())
      return points.get(index);
    else
      return points.get(points.size() - 1);
  }

  float getParam(PVector position, float lastParam) {
    int minIndex = round((lastParam - range) / scale);
    minIndex = max(minIndex, 0);

    int maxIndex = round((lastParam + range) / scale) + 1;
    maxIndex = min(maxIndex, points.size());

    float minDistance = Float.POSITIVE_INFINITY;
    float param = 0.0;

    for (int i=minIndex; i < maxIndex; ++i) {
      float distance = PVector.sub(points.get(i), position).mag();

      if (distance < minDistance) {
        minDistance = distance;
        param = scale * (float) i;
      }
    }

    return param;
  }

  void render() {
    fill(0, 180, 255);
    stroke(0, 180, 255);

    for (PVector point : points) {
      circle(point.x, point.y, 10);
    }
  }
}


class SteeringFollowing extends SteeringSeek {

  PointPath path;
  float epsilon = 1.0;
  float currentParam = 0.0;
  int currPoint = 0;
  
  SteeringFollowing(PointPath path) {
    this.path = path;
  }
  
  SteeringFollowing(float startX, float startY, float goalX, float goalY, Grid grid) {
    this.path = gridPath(startX, startY, goalX, goalY, grid);
  }

  DynamicSteeringOutput getSteering(Kinematic character) {
    // Grab the current point and check if the epsilon is within range
    if(currPoint < path.points.size() - 1 && PVector.sub(path.points.get(currPoint), character.position).mag() < epsilon ) {
      currPoint++;
      
    }
    if(currPoint < path.points.size()) {
      PVector target = path.points.get(currPoint);

      super.target = new Static(target, 0.);
      return super.getSteering(character); 
    }
    return null;
    
  }
}

PointPath gridPath(float startX, float startY, float goalX, float goalY, Grid grid) {
  grid.reset((int)Math.floor(startX),(int)Math.floor(startY), (int)Math.floor(goalX), (int)Math.floor(goalY));
  if(!grid.graph[Math.round(goalY)][Math.round(goalX)].value.traversable)
    return null;
  while(grid.search.shortestPath() == null) {
    grid.search.update(); 
  }
  PointPath path = new PointPath();
  List<Edge<GridCell>> edges = grid.search.shortestPath();
  for(int i = edges.size() - 1; i >= 0; i--) {
    path.addPoint(new PVector((((GridCell)edges.get(i).end.value).x + 0.5) * grid.scale, (((GridCell)edges.get(i).end.value).y + 0.5) * grid.scale));
  }
  path.scale = 20.0;
  return path;
}
