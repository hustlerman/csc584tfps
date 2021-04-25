int FRAME_RATE = 25;

Grid grid;
DynamicBoid boid;
SteeringFollowing follow;
GraphSearch<GridCell> gridSearch;
Heuristic<GridCell> gridHeuristic;
ArrayList<float[]> buttons;// EnemyLocations
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
  int count = 1;
  Random rand = new Random();
  
  while(buttons.size() > 0 && count <= 5) {
            int index = rand.nextInt(buttons.size());
            System.out.println("Selected: "+buttons.get(index)[0]+" "+buttons.get(index)[1]);
            DynamicBoid temp = new DynamicBoid((buttons.get(index)[0]) * grid.scale,(buttons.get(index)[1])* grid.scale);
            objects.add(temp);
            buttons.remove(index);
            count++;
  }
  /*DynamicBoid enemyboid1 = new DynamicBoid((42.5) * grid.scale , 1.5 * grid.scale);
  DynamicBoid enemyboid2 = new DynamicBoid((44.5) * grid.scale , 7.5 * grid.scale);
  DynamicBoid enemyboid3 = new DynamicBoid((72.5) * grid.scale , 19.5 * grid.scale);
  DynamicBoid enemyboid4 = new DynamicBoid((66.5) * grid.scale , 5.5 * grid.scale);
  DynamicBoid enemyboid5 = new DynamicBoid((74.5) * grid.scale , 2.5 * grid.scale);
  objects.add(enemyboid1);
  objects.add(enemyboid2);
  objects.add(enemyboid3);
  objects.add(enemyboid4);
  objects.add(enemyboid5);*/
  
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
