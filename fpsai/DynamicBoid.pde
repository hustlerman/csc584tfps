class DynamicBoid extends GameObject {
  
  Kinematic character;
  float maxSpeed = 50000f;
  float drag = .0f;
  ArrayList<SteeringMovement> controllers;
  Renderable shape = new BoidRenderer(25);
  // Enemy Reder
  //Renderable enemyShape = new EnemyBoidRenderer(25);
  boolean seenByEnemy = false; // seen by enemy
  //HashSet<PVector> radiusPoints = new HashSet<PVector>();// Points visible to enemy boids.
  DynamicBoid(float x, float y) {
    controllers = new ArrayList<SteeringMovement>();
    character = new Kinematic(new PVector(x, y), PI * .5f);
  }
  
  void addMovement(SteeringMovement controller) {
     controllers.add(controller);
  }
  
  void update(float dt) {
    DynamicSteeringOutput totalSteering = new DynamicSteeringOutput();
    
    for(SteeringMovement controller : controllers) {
        DynamicSteeringOutput steering = controller.getSteering(character);
        
        if(steering != null) {
          totalSteering.linear.add(steering.linear);
          totalSteering.angular += steering.angular;
        }
    }
    
    
    
    character.velocity.mult(1.0f - drag);
    character.rotation *= 1.0f - drag;   
    
    character.velocity.add(PVector.mult(totalSteering.linear, dt));
    character.rotation += totalSteering.angular * dt;
    
    character.position.add(PVector.mult(character.velocity, dt));
    character.orientation += character.rotation * dt;
    
    if(character.velocity.mag() > maxSpeed)
       character.velocity.normalize().mult(maxSpeed); 
    
    if(PI < character.orientation)
      character.orientation -= TWO_PI;
    else if(-PI > character.orientation)
      character.orientation += TWO_PI;
  }
  void render() {
    pushMatrix();
    translate(character.position.x, character.position.y);
    rotate(-character.orientation);
    
    shape.render();
    //enemyShape.render();//Enemy
    popMatrix();
  }
  
  void setPosition(PVector position) {
    this.character.position =  position.copy();
  }
  
  PVector getPosition() {
    return character.position; 
  }
  
  PVector getVelocity() {
     return character.velocity;
  }
}
