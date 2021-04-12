class Kinematic {
  PVector position;
  float orientation;
  PVector velocity;
  float rotation;
  
  Kinematic() {
    this.position = new PVector(.0f, .0f);
    this.orientation = .0f;
    this.velocity = new PVector(.0f, .0f);
    this.rotation = .0f;
  }     

  Kinematic(PVector position, float orientation) {
    this.position = position;
    this.orientation = orientation;
    this.velocity = new PVector(.0f, .0f);
    this.rotation = .0f;
  }   
  
  Kinematic(PVector position, float orientation, PVector velocity, float rotation) {
    this.position = position;
    this.orientation = orientation;
    this.velocity = velocity;
    this.rotation = rotation;
  }   
}


class DynamicSteeringOutput {
  PVector linear;
  float angular;

  DynamicSteeringOutput() {
    this.linear = new PVector(.0f, .0f);
    this.angular = .0f;
  }   
  
  DynamicSteeringOutput(PVector linear, float angular) {
    this.linear = linear;
    this.angular = angular;
  }   
}


interface SteeringMovement {
  DynamicSteeringOutput getSteering(Kinematic character);
}
