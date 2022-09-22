class Projectile extends GraphicObject {
  boolean isVisible = false;
  PVector size; 
  float topSpeed;
  float mass;
  float radius;
  
  Projectile () {
    this.location = new PVector (random (width), random (height));    
    this.velocity = new PVector (0, 0);
    this.acceleration = new PVector (0 , 0);
    
    this.size = new PVector (16, 16);
    this.radius = size.x / 2;
    this.mass = 1;
  }
  
  void activate() {
    isVisible = true;
  }
  
  void setDirection(PVector v) {
    velocity = v;
  }
  
  
  void update(float deltaTime) {
    
    if (!isVisible) return;
    
    velocity.add (acceleration);
    location.add (velocity);

    acceleration.mult (0);
    
    if (location.x < 0 || location.x > width || location.y < 0 || location.y > height) {
      isVisible = false;
    }
  }
  
  void display() {
    fill(220);
    if (isVisible) {
      pushMatrix();
        translate (location.x, location.y);
        
        ellipse (0, 0, 3, 3);
      popMatrix();
    }
  }
}
