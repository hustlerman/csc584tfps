int FRAME_RATE = 25;

Grid grid;
DynamicBoid boid;
SteeringFollowing follow;
GraphSearch<GridCell> gridSearch;
Heuristic<GridCell> gridHeuristic;
ArrayList<PVector> buttons;
int framesPast = 0;

ArrayList<GameObject> objects = new ArrayList<GameObject>();

void initializeBoid() {
  grid.reset(20,2,20,2);
  boid = new DynamicBoid((20.5) * grid.scale , 2.5 * grid.scale);
  PointPath path = new PointPath();
  path.addPoint(new PVector(boid.character.position.x, boid.character.position.y));
  follow = new SteeringFollowing(path);
  follow.epsilon = 5;
  follow.currentParam = 0.0;
  
  SteeringLook look = new SteeringLook();
  look.maxAngular = 10.0f * PI;
  look.maxRotation = 2.0 * PI;
  look.targetRadius = 0.0001f * PI;
  look.slowRadius = 0.2 * PI;
  look.timeToTarget = 0.25f;
    
  boid.addMovement(look);
  boid.addMovement(follow);
  boid.maxSpeed = 40f;
  boid.drag = 0.1f;
  objects.add(boid);
  
  // Enemy Boids
  DynamicBoid enemyboid1 = new DynamicBoid((10.5) * grid.scale , 2.5 * grid.scale);
  DynamicBoid enemyboid2 = new DynamicBoid((30.5) * grid.scale , 1.5 * grid.scale);
  DynamicBoid enemyboid3 = new DynamicBoid((40.5) * grid.scale , 4.5 * grid.scale);
  DynamicBoid enemyboid4 = new DynamicBoid((24.5) * grid.scale , 5.5 * grid.scale);
  DynamicBoid enemyboid5 = new DynamicBoid((25.5) * grid.scale , 7.5 * grid.scale);
  objects.add(enemyboid1);
  objects.add(enemyboid2);
  objects.add(enemyboid3);
  objects.add(enemyboid4);
  objects.add(enemyboid5);
  
}

void mouseClicked() {
  PointPath path = gridPath(boid.character.position.x/grid.scale, boid.character.position.y/grid.scale, (mouseX + grid.scale/2)/grid.scale, (mouseY+ grid.scale/2)/grid.scale, grid);
  if(path != null) {
    follow.path = path;
    follow.currPoint = 0;
  }
}

void setup() {
  
  // Configure processing
  size(960,340);
  frameRate(FRAME_RATE);
  smooth(2);
  
  // Configure search
  //gridHeuristic = new Manhattan();
  gridHeuristic = new ManhattanCover();

  //gridSearch = new aStar<GridCell>(gridHeuristic);
  gridSearch = new aStarTactical<GridCell>(gridHeuristic);

  // Build grid
  grid = new Grid(gridSearch, true);
  
  // Set button locations
  buttons = new ArrayList<PVector>();
  buttons.add(new PVector(4.5 * grid.scale , 3.5 * grid.scale));
  buttons.add(new PVector(39.5 * grid.scale , 3.5 * grid.scale));
  buttons.add(new PVector(4.5 * grid.scale , 10.5 * grid.scale));
  
  initializeBoid();
  //initializeDecisionTree();
}

void draw(){
  float dt = 1.0f / (float) FRAME_RATE;
  
  // Check if we should update the color
  PVector position = boid.getPosition();
  
  // Fill background
  
  // Build decision context
  GameState state = new GameState();
   
  // Go to hiding space if it's time
  state.add("hide", (framesPast / FRAME_RATE)%60 > 30 ? "True": "False");
  
  // Update game objects
  for(GameObject obj : objects)
    obj.update(dt);
    
  //translate(grid.scale, grid.scale);
  grid.render();
  
  // Render game objects
  for(GameObject obj : objects) {
    obj.render();
  }
  
  
}
