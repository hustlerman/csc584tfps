int FRAME_RATE = 25;
float GRID_SCALE = 12.f;

DynamicBoid boid;
SteeringFollowing follow;

ArrayList<float[]> buttons;// EnemyLocations

int framesPast = 0;

ArrayList<GameObject> objects = new ArrayList<GameObject>();
ArrayList<Grid> grids = new ArrayList<Grid>();
int activeGrid = 0;

void initializeBoid() {
  for(Grid grid: grids) 
    grid.reset(20,2,20,2);
    
  boid = new DynamicBoid((20.5) * GRID_SCALE , 2.5 * GRID_SCALE);
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
    
  boid.addMovement(follow);  
  boid.addMovement(look);
  boid.maxSpeed = 40f;
  boid.drag = 0.1f;
  objects.add(boid);
  
  // Enemy Boids
  int count = 1;
  Random rand = new Random();
  
  while(buttons.size() > 0 && count <= 5) {
            int index = rand.nextInt(buttons.size());
            System.out.println("Selected: "+buttons.get(index)[0]+" "+buttons.get(index)[1]);
            DynamicBoid temp = new DynamicBoid((buttons.get(index)[0]) * GRID_SCALE,(buttons.get(index)[1])* GRID_SCALE);
            objects.add(temp);
            buttons.remove(index);
            count++;
  }
}

void mouseClicked() {
  PointPath path = gridPath(boid.character.position.x/GRID_SCALE, boid.character.position.y/GRID_SCALE, (mouseX + GRID_SCALE)/GRID_SCALE, (mouseY + GRID_SCALE)/GRID_SCALE, grids.get(activeGrid));
  if(path != null) {
    follow.path = path;
    follow.currPoint = 0;
  }
}

// Creates initial setup for simulation
void setup() {
  
  // Configure processing
  size(960,340);
  frameRate(FRAME_RATE);
  smooth(2);
  
  // Set button locations coordinates
  buttons = new ArrayList<float[]>();
  buttons.add(new float[]{7.5, 4.5});
  buttons.add(new float[]{3.5, 9.5});
  buttons.add(new float[]{6.5, 13.5});
  buttons.add(new float[]{9.5, 24.5});
  buttons.add(new float[]{18.5, 1.5});
  buttons.add(new float[]{32.5, 3.5});
  buttons.add(new float[]{42.5, 1.5});
  buttons.add(new float[]{44.5, 7.5});
  buttons.add(new float[]{40.5, 9.5});
  buttons.add(new float[]{37.5, 16.5});
  buttons.add(new float[]{27.5, 16.5});
  buttons.add(new float[]{46.5, 15.5});
  buttons.add(new float[]{39.5, 24.5});
  buttons.add(new float[]{49.5, 22.5});
  buttons.add(new float[]{61.5, 25.5});
  buttons.add(new float[]{58.5, 13.5});
  buttons.add(new float[]{59.5, 3.5});
  buttons.add(new float[]{66.5, 5.5});
  buttons.add(new float[]{74.5, 2.5});
  buttons.add(new float[]{72.5, 19.5});
  
  // Build grids
  grids.add(new Grid(new aStar<GridCell>(new Manhattan()), GRID_SCALE, true));
  grids.add(new Grid(new aStarTactical<GridCell>(new ManhattanCover()), GRID_SCALE, true));

  
  initializeBoid();
  //initializeDecisionTree();
}



void draw(){
  float dt = 1.0f / (float) FRAME_RATE;
  
  // Clear background
  background(255);
  
  // Check if you've arrived at the destination
  //if(boid.
  
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
