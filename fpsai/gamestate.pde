import java.util.HashSet;
import java.util.Set;

class GameState {
  HashMap<String, String> data;
  
  GameState() {
    data = new HashMap<String, String>();
  }
  
  void add(String key, String value) {
    data.put(key, value);
  }
  
  String get(String key) {
    return data.get(key); 
  }
}

class GameSpec {
  HashMap<String, HashSet<String>> spec;
  
  GameSpec() {
    spec = new HashMap<String, HashSet<String>>(); 
  }
  
  void addValue(String key, String value) {
    if(!spec.containsKey(key))
      spec.put(key, new HashSet<String>());
    
    spec.get(key).add(value);
  }
  
  Set<String> getValues(String key) {
    return spec.get(key); 
  }
}

//class Action {
//  SteeringMovement movement;
  
//  Action(SteeringMovement movement) {
//    this.movement = movement; 
//  }
  
//  SteeringMovement getMovement() {
//    return movement;
//  }
//}

//class PathfindingAction extends Action {
//  PVector target;
//  GameObject character;
//  Grid grid;
  
//  PathfindingAction(PVector t, GameObject o, Grid g, SteeringMovement movement) {
//    super(movement);
//    this.target = t;
//    this.character = o;
//    this.grid = g;
    
//  }
  
//  SteeringMovement getMovement() {
//    ((SteeringFollowing)this.movement).path = gridPath(character.getPosition().x/grid.scale, character.getPosition().y/grid.scale, target.x/grid.scale, target.y/grid.scale, grid);
//    return this.movement;
//  }
//}

//// Context for executing behavior tree
//class DecisionContext {
//  DynamicBoid boid;
//  GameState state;
  
//  DecisionContext(DynamicBoid boid, GameState state) {
//    this.boid = boid;
//    this.state = state;
//  }
  
//  GameState getState() {
//    return state; 
//  }
  
//  void sendAction(Action action) {
//    SteeringMovement movement = action.getMovement(); 
    
//    if(null != movement)
//      boid.controller = movement; 
//  }
//}
