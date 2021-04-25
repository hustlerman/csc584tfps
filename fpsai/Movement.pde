class Static {
  PVector position;
  float orientation;
  
  Static() {
    this.position = new PVector(.0f, .0f);
    this.orientation = .0f;
  }     
  
  Static(PVector position, float orientation) {
    this.position = position;
    this.orientation = orientation;
  }   
}

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

class SteeringAlign implements SteeringMovement {
  
  Kinematic target = new Kinematic();
  
  float maxAngular = 2.0f * PI;
  float maxRotation = PI;
  
  float targetRadius = 0.001f * PI;
  float slowRadius = 0.25 * PI;
  float timeToTarget = 0.5f;
  
  DynamicSteeringOutput getSteering(Kinematic character) {
    DynamicSteeringOutput result = new DynamicSteeringOutput();
    float delta = target.orientation - character.orientation;
    
    if(PI < delta)
      delta -= TWO_PI;
    else if(-PI > delta)
      delta += TWO_PI;
    
    float absDelta = abs(delta);
    
    if(absDelta <= targetRadius)
      return result;
      
    float targetRotation = maxRotation;
    
    if(absDelta <= slowRadius)
      targetRotation *= absDelta / slowRadius; 
    
    targetRotation *= delta / absDelta;
    
    result.angular = targetRotation - character.rotation;
    result.angular /= timeToTarget;
    
    float absAngular = abs(result.angular);
    
    if(absAngular > maxAngular) {
      result.angular /= absAngular;
      result.angular *= maxAngular;
    }
    
    return result;
  }
}


class SteeringLook extends SteeringAlign {

  DynamicSteeringOutput getSteering(Kinematic character) {
     if(character.velocity.mag() >= 0.01f)
       target.orientation = atan2(-character.velocity.y, character.velocity.x);
     
     return super.getSteering(character);
  }
}


class SteeringSeek implements SteeringMovement {

  Static target = null;
  
  float maxLinear = 500f;
  
  DynamicSteeringOutput getSteering(Kinematic character) {
    if(null == target)
      return null;
      
    DynamicSteeringOutput result = new DynamicSteeringOutput();
     
    result.linear = PVector.sub(target.position, character.position);
    result.linear.normalize().mult(maxLinear);
    
    return result;
  }
}
