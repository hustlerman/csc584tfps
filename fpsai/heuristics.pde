interface Heuristic<T> {
  float value(T start, T goal);
}

class Manhattan implements Heuristic<GridCell> {
  float value(GridCell start, GridCell goal) {
    return abs(goal.x - start.x) + abs(goal.y - start.y);
  }
}

class ManhattanCover implements Heuristic<GridCell> {
  float value(GridCell start, GridCell goal) {
    return abs(goal.x - start.x) + abs(goal.y - start.y) + start.exposure * 10;
  }
}
