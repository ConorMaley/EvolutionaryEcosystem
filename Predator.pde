//Evolutionary Ecosystem
//Conor Maley

//Predator class
//Has both sexual and asexual mating capabilities.

//sexual breeding spawns offspring in random location (prevents mass overpopulation)

class Predator {
  PVector location; // Location
  PVector direction; // Direction faced
  PVector decision; //decision currently being made
  DNA dna;          // DNA
  float health;     // Life timer
  // DNA will determine size and maxspeed
  float r;
  float maxspeed;
  
  float xoff;
  float yoff;
  
  float PIdir;
  
  float turning;
  float moving;
  
  int ticks;
  
  Predator() {
    
  }
  
  Predator(PVector l, DNA dna_, int h) {
    location = l.get();
    ticks = 0;
    direction = new PVector(random(-1, 1), random(-1, 1));
    health = h;
    dna = dna_;
    // Gene 0 determines maxspeed and r
    // The bigger the bloop, the slower it is
    maxspeed = map(dna.genes[0], 0, 1, 12, 0);
    r = map(dna.genes[0], 0, 1, 0, 40);
    decision = new PVector(dna.genes[3], dna.genes[4]);
    turning = 0;
    moving = 0;
    
  }
  
  void run() {
    update();
    borders();
    display();
    ticks += 1;
  }
  
  void borders() {
    if (location.x < -r) location.x = w_width+r;
    if (location.y < -r) location.y = w_height+r;
    if (location.x > w_width+r) location.x = -r;
    if (location.y > w_height+r) location.y = -r;
  }
  
  void eat(ArrayList<Bloop> b) {
    
    // Are we touching any bloops?
    for (int i = b.size()-1; i >= 0; i--) {
      PVector loc = b.get(i).location;
      float d = PVector.dist(location, loc);
      // If we are, juice up our strength!
      if (d < r/2) {
        //health += 100;
        health += b.get(i).health/1.5;
        //pass by reference by default I think, so this should work. 
        b.remove(i);
      }
    }
  }
  
  //maybe later make food poisonous?
  
  void update () {
    //check if anything is in front of you
    
    //use decision.x for the speed increase/decrease
    //use decision.y for a turn
    
    //float spd = map(decision.x, -1, 1, -maxspeed, maxspeed);
    
    //float turn = map(decision.y, 0, 1, 0, 2*PI);
    
    //float spd = map(moving, -1, 1, -maxspeed, maxspeed);
    
    decision.x = moving;
    
    if (decision.x > 1) {
      decision.x = 1;
    }
    
    else if (decision.x < -1) {
      decision.x = -1;
    }
    
    float spd = map(decision.x, -1, 1, -maxspeed, maxspeed);
    
    decision.y+=turning;
    
    float turn = decision.y;
    
    
    
    if(turn > 2*PI) {
      turn -= 2*PI;
    }
    else if (turn < 0) {
      turn += 2*PI;
    }
    
    float vx = cos(turn) * spd;
    float vy = sin(turn) * spd;
    PVector velocity = new PVector(vx,vy);
    
    location.add(velocity);
    direction = velocity.normalize();
    // Death always looming
    // predators die a little bit faster
    health -= 0.35;
  }
  
  void decide(ArrayList<Bloop> bloops) {
    //check intersection in sight range
    /*
      Ok so, finding the determinant isn't working.
      So we're going to get a couple of points on the line and check if any of them are inside the bloops
    */
    
    //start point
    float x1 = location.x;
    float y1 = location.y;
    
    //end pt of ray
    float x2 = location.x + (direction.x*(r*3));
    float y2 = location.y + (direction.y*(r*3));
    
    line(x1, y1, x2, y2);
    
    // Are we touching any bloops?
    for (int i = bloops.size()-1; i >= 0; i--) {
      float b_rad = bloops.get(i).r;
      float b_x = bloops.get(i).location.x;
      float b_y = bloops.get(i).location.y;
      boolean contact = false;
      //just checking a couple of points on the antenna
      for (int j = 1; j <= 9; j++) {
        x2 = location.x + (direction.x*(r*(j/3)));
        y2 = location.y + (direction.y*(r*(j/3)));
        float dist = sqrt(pow((b_x - x2),2) + pow((b_y - y2),2));
        if (dist <= b_rad) {
          //println("Contact! " + dist);
          forward(dna.genes[3]);
          turn(dna.genes[4]);
          contact = true;
          break;                    
                              
        }
        else {
          //println("No Contact! " + dist);
          forward(dna.genes[1]);
          turn(dna.genes[2]);
          break;
        }
        
        
        
      }
      
      //break the i-for loop to save time
      if (contact) {
        break;
      }
      
    }
    
  }
  
  
  void display() {
    ellipseMode(CENTER);
    stroke(0, health);
   
    
    //this is the antenna line
    //it's longer than the Bloops' antennas
    fill(0,0,0);
    line(location.x, location.y, location.x + (direction.x*(r*3)), location.y + (direction.y*(r*3)));
    fill(255, 255-health, 255-health);
    ellipse(location.x, location.y, r, r);
    
    fill(0, 0, 255);
    text(health, location.x - r, location.y - r);
    //PVector velocity = new PVector(vx,vy);
    
  }
  
  Predator reproduce() {
    // asexual reproduction
    if (random(1) < 0.0005) {
      // Child is exact copy of single parent
      DNA childDNA = dna.copy();
      // Child DNA can mutate
      childDNA.mutate(0.01);
      health -= 50;
      return new Predator(location, childDNA, 75);
    } 
    else {
      return null;
    }  
  }
  
  Predator reproduce(ArrayList<Predator> p) {
    // Are we touching any other bloops?
    for (int i = p.size()-1; i >= 0; i--) {
      PVector loc = p.get(i).location;
      float d = PVector.dist(location, loc);
      // If we are, crossover the gene pool!
      if (d < r/2 && random(1) < 0.0011) {
        //println("we made a child!");
        DNA childDNA = dna.crossover(dna, p.get(i).dna);
        childDNA.mutate(0.01);
        health -= 50;
        p.get(i).health -= 50;
        return new Predator(new PVector(random(w_width), random(w_height)), childDNA, 80);
      }
    }
    
    return null;
  }
  
  void turn(float dir) {
    
    turning += (dir*(2/r));
    //println("turning = " + turning);
    
    //we're gonna set .05/-.05 as the max turning;
    if (turning > .05) {
      turning = .05;
    }
    
    else if (turning < -.05) {
      turning = -.05;
    }
    
    //decision.y += dir;
  }
  
  void forward(float dir) {
    //decision.x += (dir*(1/r));
    moving += (dir * 1/r);
    
    if (moving > 1) {
      moving = 1;
    }
    if (moving < -1) {
      moving = -1;
    }
    
    //println("moving = " + moving);
    //println("speed = " + map(moving, -1, 1, -maxspeed, maxspeed));
    
  }
  
  void mouseOver() {
    stroke(0);
    fill(255, 255, 255);
    rect(location.x + 50, location.y - 50, 50, 60);
    fill(0, 0, 255);
    text(r, location.x + 25, location.y - 70);
    text(dna.genes[1], location.x + 25, location.y - 60);
    text(dna.genes[2], location.x + 25, location.y - 50);
    text(dna.genes[3], location.x + 25, location.y - 40);
    text(dna.genes[4], location.x + 25, location.y - 30);
    
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