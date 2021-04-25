import java.util.Random;
import java.util.List;
import java.util.Collection;

int SEED = 27;

class Node<T> {
  T value;
  List<Edge<T>> incoming;
  List<Edge<T>> outgoing;
  
  Node(T value) {
    this.value = value;
    this.incoming = new ArrayList<Edge<T>>();
    this.outgoing = new ArrayList<Edge<T>>();
  }
  
  void edgeTo(Node<T> node, float weight) {
    Edge<T> edge = new Edge<T>(this, node, weight);
    this.outgoing.add(edge);
    node.incoming.add(edge);
  }
}


class Edge<T> {
  Node<T> start;
  Node<T> end;
  float weight;

  
  Edge(Node<T> start, Node<T> end, float weight) {
    this.start = start;
    this.end = end;
    this.weight = weight;
  }
}

class Grid {
  
  float scale = 12f;
  
  Node<GridCell>[][] graph;
  
  GraphSearch<GridCell> search;
  Node<GridCell> start = null;
  Node<GridCell> goal = null;
  
  //Grid(boolean[][] map, GraphSearch search) {
  //  this(map, search, false);
  //}
  
  Grid(GraphSearch search, boolean diagonal) {
    // Loads map from file
    String[] lines = loadStrings("gamemap.txt");
    
    boolean[][] map = new boolean[lines.length][lines[0].length()];
    
    for(int i = 0; i < lines.length; i++) {
      for(int j = 0; j < lines[i].length(); j++) {
        map[i][j] = lines[i].charAt(j) == 'o';
      }
    }
    
    this.search = search;
    
    // Initialize graph
    this.graph = new Node[map.length][map[0].length];
    
    for(int y=0; y < map.length; ++y)
      for(int x=0; x < map[y].length; ++x)
        graph[y][x] = new Node<GridCell>(new GridCell(x,y, map[y][x]));
    
    // Construct UP edges
    for(int y=0; y < map.length - 1; ++y)
      for(int x=0; x < map[y].length; ++x)
        if(map[y + 1][x])
          graph[y][x].edgeTo(graph[y + 1][x], 1.0f);
    
    // Construct DOWN edges
    for(int y=1; y < map.length; ++y)
      for(int x=0; x < map[y].length; ++x)
        if(map[y - 1][x])
          graph[y][x].edgeTo(graph[y - 1][x], 1.0f);
        
    // Construct LEFT edges
    for(int y=0; y < map.length; ++y)
      for(int x=1; x < map[y].length; ++x)
        if(map[y][x - 1])
          graph[y][x].edgeTo(graph[y][x - 1], 1.0f);
        
    // Construct RIGHT edges
    for(int y=0; y < map.length; ++y)
      for(int x=0; x < map[y].length - 1; ++x)
        if(map[y][x + 1])
          graph[y][x].edgeTo(graph[y][x + 1], 1.0f);
        
    if(diagonal) {
      float root = sqrt(2.0f);
      
      // Construct UP-LEFT edges
      for(int y=0; y < map.length - 1; ++y)
        for(int x=1; x < map[y].length; ++x)
          if(map[y + 1][x - 1])
            graph[y][x].edgeTo(graph[y + 1][x - 1], root);
      
      // Construct UP-RIGHT edges
      for(int y=0; y < map.length - 1; ++y)
        for(int x=0; x < map[y].length - 1; ++x)
          if(map[y + 1][x + 1])
            graph[y][x].edgeTo(graph[y + 1][x + 1], root);

      // Construct DOWN-LEFT edges
      for(int y=1; y < map.length; ++y)
        for(int x=1; x < map[y].length; ++x)
          if(map[y - 1][x - 1])
            graph[y][x].edgeTo(graph[y - 1][x - 1], root);
      
      // Construct DOWN-RIGHT edges
      for(int y=1; y < map.length; ++y)
        for(int x=0; x < map[y].length - 1; ++x)
          if(map[y - 1][x + 1])
            graph[y][x].edgeTo(graph[y - 1][x + 1], root);
    }
  }
  
  
  
  void reset(int startX, int startY, int goalX, int goalY) {
    start = graph[startY][startX];
    goal = graph[goalY][goalX];
    
    search.reset(start, goal);
  }
  
  void update() {
    search.update();
  }
  
  void render() {
    
    // Draw map
    stroke(0,0,0);
    
    for(int y=0; y < graph.length; y++) {
      for(int x=0; x < graph[y].length; x++) {
        if(graph[y][x].value.traversable) {
          if(graph[y][x].value.cleared) {
            fill(0,255,0);
          } else {
            fill(255,192,203);
          }
        } else {
          fill(255,255,255);
        }
        square(x * scale, y * scale, scale);
      }
    }
    
    // Draw open and closed sets if available
    Collection<Node<GridCell>> open = search.openSet();
    
    if(null != open) {
      noStroke();
      fill(0, 180, 255);
      
      for(Node<GridCell> node : open)
        circle(node.value.x * scale + 0.5 * scale, 
          node.value.y * scale  + 0.5 * scale, 0.8 * scale);
    }
    
    Collection<Node<GridCell>> closed = search.closedSet();
    
    if(null != closed) {
      noStroke();
      fill(100, 100, 100);
      
      for(Node<GridCell> node : closed)
        circle(node.value.x * scale + 0.5 * scale, 
          node.value.y * scale  + 0.5 * scale, 0.8 * scale);
    }
    
    // Draw path if available
    List<Edge<GridCell>> path = search.shortestPath();
    
    if(null != path) {
      strokeWeight(10);
      stroke(200, 200, 0);
      
      for(Edge<GridCell> edge : path) {
        float sx = edge.start.value.x * scale + 0.5 * scale;
        float sy = edge.start.value.y * scale + 0.5 * scale;
        float ex = edge.end.value.x * scale + 0.5 * scale;
        float ey = edge.end.value.y * scale + 0.5 * scale; 
        line(sx, sy, ex, ey);
      }
      
      strokeWeight(1);
    }
    
    // Draw start and goal
    if(null != start) {
      noStroke();
      fill(255,0,0);
      circle(start.value.x * scale + 0.5 * scale, 
        start.value.y * scale  + 0.5 * scale, 0.8 * scale);
    }
    
    if(null != goal) {
      noStroke();
      fill(0,255,0);
      circle(goal.value.x * scale + 0.5 * scale, 
        goal.value.y * scale + 0.5 * scale, 0.8 * scale);
    }   
    
  }
}
