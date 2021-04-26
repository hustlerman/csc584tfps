int FRAME_RATE = 25;
float GRID_SCALE = 12.f;
int NUM_ENEMIES = 5;
int NUM_SIMULATIONS = 100;
PVector START = new PVector(3.5, 3.5);
PVector GOAL = new PVector(75.5, 14.5);
DynamicBoid boid;
SteeringFollowing follow;

ArrayList<PVector> enemySpawnpoints; // EnemyLocations

int framesPast = 0;

ArrayList<GameObject> objects = new ArrayList<GameObject>();
ArrayList<DynamicBoid> enemyBoids = new ArrayList<DynamicBoid>();

ArrayList<Grid> grids = new ArrayList<Grid>();

int activeGrid = 0;
int currSim = -1;

void initializeBoid() {
  boid = new DynamicBoid(START.x  * GRID_SCALE, START.y  * GRID_SCALE);
  PointPath path = gridPath(START.x, START.y, GOAL.x, GOAL.y, grids.get(activeGrid));
  follow = new SteeringFollowing(path);
  follow.epsilon = 5;
  follow.currentParam = 0.0;
  
  SteeringLook look = new SteeringLook();
  look.maxAngular = 10.0f * PI;
  look.maxRotation = 2.0 * PI;
  look.targetRadius = 0.0001f * PI;
  look.slowRadius = 0.2 * PI;
  look.timeToTarget = 0.25f;
    
  boid.addMovement(follow);  
  boid.addMovement(look);
  boid.maxSpeed = 40f;
  boid.drag = 0.1f;
  objects.add(boid);
  
  // Enemy Boids
  for(int i = 0; i < NUM_ENEMIES; i++) {
    DynamicBoid temp = new DynamicBoid(0, 0);
    objects.add(temp);
    enemyBoids.add(temp);
  }
  
}

void nextSimulation() {
  // First, check if we completed the last simulation and print out the data if so
  if(currSim == NUM_SIMULATIONS) { //<>//
     outputData();
     System.exit(0);
  } else {
    currSim++; 
  }
    
  //follow.path = gridPath(START.x, START.y, GOAL.x, GOAL.y, grids.get(activeGrid));
  //follow.currPoint = 0;
  
  // Change enemy positions
  Random rand = new Random();
  ArrayList<PVector> temp = new ArrayList<PVector>();
  
  for(DynamicBoid enemy: enemyBoids) {
    PVector pos = enemySpawnpoints.remove(rand.nextInt(enemySpawnpoints.size()));
    enemy.setPosition(pos);
    temp.add(pos);
  }
  
  // Reinsert into list
  for(PVector p: temp) {
    enemySpawnpoints.add(p);
  }
  
  // 
  
}

void outputData() {
  
}

//void mouseClicked() {
//  PointPath path = gridPath(boid.character.position.x/GRID_SCALE, boid.character.position.y/GRID_SCALE, (mouseX + GRID_SCALE)/GRID_SCALE, (mouseY + GRID_SCALE)/GRID_SCALE, grids.get(activeGrid));
//  if(path != null) {
//    follow.path = path;
//    follow.currPoint = 0;
//  }
//}

// Creates initial setup for simulation
void setup() {
  
  // Configure processing
  size(960,340);
  frameRate(FRAME_RATE);
  smooth(2);
  
  // Set button locations coordinates
  enemySpawnpoints = new ArrayList<PVector>();
  enemySpawnpoints.add(new PVector(7.5 * GRID_SCALE, 4.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(3.5 * GRID_SCALE, 9.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(6.5 * GRID_SCALE, 13.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(9.5 * GRID_SCALE, 24.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(18.5 * GRID_SCALE, 1.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(32.5 * GRID_SCALE, 3.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(42.5 * GRID_SCALE, 1.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(44.5 * GRID_SCALE, 7.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(40.5 * GRID_SCALE, 9.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(37.5 * GRID_SCALE, 16.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(27.5 * GRID_SCALE, 16.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(46.5 * GRID_SCALE, 15.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(39.5 * GRID_SCALE, 24.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(49.5 * GRID_SCALE, 22.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(61.5 * GRID_SCALE, 25.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(58.5 * GRID_SCALE, 13.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(59.5 * GRID_SCALE, 3.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(66.5 * GRID_SCALE, 5.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(74.5 * GRID_SCALE, 2.5 * GRID_SCALE));
  enemySpawnpoints.add(new PVector(72.5 * GRID_SCALE, 19.5 * GRID_SCALE));
  
  // Build grids
  grids.add(new Grid(new aStar<GridCell>(new Manhattan()), GRID_SCALE, true));
  grids.add(new Grid(new aStarTactical<GridCell>(new ManhattanCover()), GRID_SCALE, true));

  
  initializeBoid();
  //initializeDecisionTree();
  nextSimulation();
}



void draw(){
  float dt = 1.0f / (float) FRAME_RATE;
  
  // Clear background
  background(255);
  
  // Check if you've arrived at the destination
  if(follow.currPoint == follow.path.points.size() - 1) {
    System.out.println("here!");
    // Move to next search algorithm
    activeGrid = (activeGrid + 1) % grids.size();
    
    // Reset boid position to start and change path
    boid.setPosition(START.copy().mult(GRID_SCALE));
    follow.path = gridPath(START.x, START.y, GOAL.x, GOAL.y, grids.get(activeGrid)); //<>//
    follow.currPoint = 0;
    
    // Reset enemy sight values (TODO)
    
    // If we're back to the first grid, reset the simluation
    if(activeGrid == 0) {
      nextSimulation();
    }
  }
  
  // Update game objects
  for(GameObject obj : objects)
    obj.update(dt);
    
  //translate(grid.scale, grid.scale);
  grids.get(activeGrid).render();
  
  // Render game objects
  for(GameObject obj : objects) {
    obj.render();
  }
  
  
}
