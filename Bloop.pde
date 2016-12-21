//Evolutionary Ecosystem
//Conor Maley
// Adapted from: Daniel Shiffman <http://www.shiffman.net>

// Creature class
// has both sexual and asexual capabilities

//sexual breeding spawns offspring in random location (prevents mass overpopulation)

class Bloop {
  PVector location; // Location
  DNA dna;          // DNA
  float health;     // Life timer
  float xoff;       // For perlin noise
  float yoff;
  // DNA will determine size and maxspeed
  float r;
  float maxspeed;

  // Create a "bloop" creature
  Bloop(PVector l, DNA dna_, int h) {
    location = l.get();
    health = h;
    xoff = random(1000);
    yoff = random(1000);
    dna = dna_;
    // Gene 0 determines maxspeed and r
    // The bigger the bloop, the slower it is
    maxspeed = map(dna.genes[0], 0, 1, 15, 0);
    r = map(dna.genes[0], 0, 1, 0, 50);
    //r = map(1, 0, 1, 0, 50);
  }
  
  Bloop(PVector l, DNA dna_, boolean child) {
    
  }

  void run() {
    update();
    borders();
    display();
  }

  // A bloop can find food and eat it
  void eat(Food f) {
    ArrayList<PVector> food = f.getFood();
    // Are we touching any food objects?
    for (int i = food.size()-1; i >= 0; i--) {
      PVector foodLocation = food.get(i);
      float d = PVector.dist(location, foodLocation);
      // If we are, juice up our strength!
      if (d < r/2) {
        health += 100; 
        food.remove(i);
      }
    }
  }

  // At any moment there is a teeny, tiny chance a bloop will reproduce
  Bloop reproduce() {
    // asexual reproduction
    if (random(1) < 0.0016) {
      // Child is exact copy of single parent
      DNA childDNA = dna.copy();
      // Child DNA can mutate
      childDNA.mutate(0.01);
      health -=25;
      return new Bloop(location, childDNA, 200);
    } 
    else {
      return null;
    }  
  }
  
  Bloop reproduce(ArrayList<Bloop> b) {
    // Are we touching any other bloops?
    for (int i = b.size()-1; i >= 0; i--) {
      PVector loc = b.get(i).location;
      float d = PVector.dist(location, loc);
      // If we are, crossover the gene pool!
      if (d < r/2 && random(1) < 0.002) {
        //println("we made a child!");
        health -= 50;
        DNA childDNA = dna.crossover(dna, b.get(i).dna);
        childDNA.mutate(0.01);
        return new Bloop(new PVector(random(w_width), random(w_height)), childDNA, 200);
      }
    }
    
    return null;
  }

  // Method to update location
  void update() {
    // Simple movement based on perlin noise
    float vx = map(noise(xoff),0,1,-maxspeed,maxspeed);
    float vy = map(noise(yoff),0,1,-maxspeed,maxspeed);
    PVector velocity = new PVector(vx,vy);
    xoff += 0.01;
    yoff += 0.01;

    location.add(velocity);
    // Death always looming
    health -= 0.2;
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = w_width+r;
    if (location.y < -r) location.y = w_height+r;
    if (location.x > w_width+r) location.x = -r;
    if (location.y > w_height+r) location.y = -r;
  }

  // Method to display
  void display() {
    ellipseMode(CENTER);
    stroke(0, health);
    fill(255 - health);
    ellipse(location.x, location.y, r, r);
    float vx = map(noise(xoff),0,1,-maxspeed,maxspeed);
    float vy = map(noise(yoff),0,1,-maxspeed,maxspeed);
    PVector velocity = new PVector(vx,vy);
    line(location.x, location.y, location.x + (velocity.normalize().x*(r*2)), location.y + (velocity.normalize().y*(r*2)));
    //line(location.x, location.y, location.x + (velocity.normalize().x*(r*1.5)), location.y + (velocity.normalize().y*(r*1.5)));
    //line(location.x, location.y, location.x + cos(45) * (-velocity.normalize().x*(r*1.5)), location.y + sin(45) * (-velocity.normalize().y*(r*1.5)));
    //line(location.x, location.y, location.x + sin(-60) * (velocity.normalize().x*(r*1.5)), location.y + cos(-60) * (velocity.normalize().y*(r*1.5)));
  }
  
  void mouseOver() {
    stroke(0);
    fill(255, 255, 255);
    rect(location.x + 50, location.y - 50, 50, 50);
    
  }

  // Death
  boolean dead() {
    if (health < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}