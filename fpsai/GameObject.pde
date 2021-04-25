abstract class GameObject {
  void update(float dt) {};
  void render() {};
  PVector getPosition() { 
    return null; 
  }
  PVector getVelocity() { 
    return null; 
  }
}

class Wall {
  
}

class Box {
  
}
interface Renderable {
  void render();
}

class BoidRenderer implements Renderable {
  float l, w, h;
  
  BoidRenderer(float radius) {
    float r_squared = radius * radius;
    l = 2.0f * radius;
    w = r_squared / l;
    h = radius * sqrt(1.0f - r_squared / (l * l));
  }
  
  void render() {
    fill(0,180,255);
    stroke(0,180,255);
    ellipse(.0f, .0f, l/5, l/5);
    triangle(l/5, .0f, w/5, h/5, w/5, -h/5); 
  }
}
