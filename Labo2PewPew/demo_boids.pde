int currentTime;
int previousTime;
int deltaTime;

ArrayList<Mover> flock;
int flockSize = int(random(10, 20));

ArrayList<Projectile> p;

Vaisseau v;

boolean debug = false;

void setup () {
  //fullScreen(P2D);
  size (800, 600);
  currentTime = millis();
  previousTime = millis();
  
  v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  
  //////////////////////////
  p = new ArrayList<Projectile>();
  
  //////////////////////////
  
  flock = new ArrayList<Mover>();
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-2, 2), random(-2, 2)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
  }

  //flock.get(0).debug = true;
}

void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;
  
  update(deltaTime);
  display();  
  
  
}

/***
  The calculations should go here
*/


PVector thrusters = new PVector(0, -0.02);

boolean peutTirer = true;;
void update(int delta) {
  
  //////////////////////
  ArrayList<Mover> toremove = new ArrayList<Mover>();
  int i = 0;
  for ( Projectile pp : p) {
    if(pp.location.x > width || pp.location.y > height || pp.location.x <= 0 || pp.location.y <= 0){
      pp.isVisible = false;
    }
    pp.update(deltaTime);
      for (Mover m : flock) {
        if(m.isColliding(pp) && pp.isVisible == true){
          //m.location.x = width/2;
          //m.location.y = height/2;
          toremove.add(m);
          pp.isVisible = false;
        }
      }
      
      if(pp.isVisible == true){
        i++;
      }
      
      if(i >= 10){
        peutTirer = false;
      }
      else{
        peutTirer = true;
      }
  }
  
  for (Mover m : flock) {
        if(v.isColliding(m)){
          int xx = int(random(0, width));
          int yy = int(random(0, height));
          while(!v.goodRespawn(m, xx, yy)){
            v.location.x = xx;
            v.location.y = yy;
            xx = int(random(0, width));
            yy = int(random(0, height));
          }
          v.velocity.x = 0;
          v.velocity.y = 0;
        }
      }
  
  //////////////////////
  
  flock.removeAll(toremove);
  
  v.update(delta);
  
  for (Mover m : flock) {
    m.flock(flock);
    m.update(delta);
  }
  
    if (keyPressed) {
    switch (key) {
      case 'w':
        v.thrust();
        break;
      case 'a':
        v.pivote(-.03);
        break;
      case 'd':
        v.pivote(.03);
        break;
      }
    }
}

/***
  The rendering should go here
*/
void display () {
  background(0);

  ////////////////////
  for ( Projectile pp : p) {
    pp.display();
  }
  ////////////////////


  v.display();

  for (Mover m : flock) {
    m.display();      
  }
}

void keyPressed() {
  switch (key) {
    case 'r':
      setup();
      break;
  }
}

void mouseClicked(){

    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-2, 2), random(-2, 2)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);

}

void keyReleased() {
    switch (key) {
      case 'w':
        v.noThrust();
        break;
        case ' ':
          if(peutTirer == true){
            Projectile d = new Projectile();
            d.location.x = v.location.x;
            d.location.y = v.location.y;
        
            d.activate();
            d.velocity.x = cos(v.heading - PI/2);
            d.velocity.y = sin(v.heading - PI/2);
            d.velocity.mult(5);
            
            p.add(d);
          }
        break;
        
    }  
}
