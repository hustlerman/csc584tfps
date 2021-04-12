class DynamicBoid extends GameObject {
  
  Kinematic character;
  float maxSpeed = 50000f;
  float drag = .0f;
  ArrayList<SteeringMovement> controllers;
  
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
        
        if(null != steering) {
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
  
  PVector getPosition() {
    return character.position; 
  }
  
  PVector getVelocity() {
     return character.velocity;
  }
}
