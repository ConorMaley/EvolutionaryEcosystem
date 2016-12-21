//Evolutionary Ecosystem
//Conor Maley
// Adapted from: Daniel Shiffman <http://www.shiffman.net>
// Spring 2007, The Nature of Code

// The World we live in
// Has bloops, predators, and food

class World {

  ArrayList<Bloop> bloops;    // An arraylist for all the bloops
  ArrayList<Predator> predators;
  ArrayList<Integer> bloop_size;
  ArrayList<Integer> pred_size;
  int maxBloops;
  int maxPreds;
  Food food;

  int time;

  // Constructor
  World(int numBloops, int numPredators, int numFoods) {
    // Start with initial food and creatures
    maxPreds = numPredators;
    maxBloops = numBloops;
    time = 0;
    food = new Food(numFoods);
    bloops = new ArrayList<Bloop>();              // Initialize the arraylists
    predators = new ArrayList<Predator>(); 
    bloop_size = new ArrayList<Integer>();
    pred_size = new ArrayList<Integer>();
    
    for (int i = 0; i < numBloops; i++) {
      PVector l = new PVector(random(w_width), random(w_height));
      DNA dna = new DNA();
      bloops.add(new Bloop(l, dna, 200));
    }

    for (int i = 0; i < numPredators; i++) {
      PVector l = new PVector(random(w_width), random(w_height));
      DNA dna = new DNA();
      predators.add(new Predator(l, dna, 200));
    }
  }

  ArrayList<PVector> getBloops() {
    ArrayList<PVector> locs = new ArrayList<PVector>();
    for (int i = bloops.size()-1; i >= 0; i--) {
      Bloop b = bloops.get(i);
      locs.add(b.location);
    }
    return locs;
  }

  // Make a new bloop
  void bornBloop(float x, float y) {
    PVector l = new PVector(x, y);
    DNA dna = new DNA();
    bloops.add(new Bloop(l, dna, 200));
  }


  // Make a new predator
  void bornPredator(float x, float y) {
    PVector l = new PVector(x, y);
    DNA dna = new DNA();
    predators.add(new Predator(l, dna, 200));
  }


  // Run the world
  void run() {
    // Deal with food
    food.run();

    //save the populations.
    if (predators.size() < 3) {
      savePredators();
    }

    if (bloops.size() < 3) {
      saveBloops();
    }

    for (int i = predators.size()-1; i >= 0; i--) {
      // All predators run and eat
      Predator p = predators.get(i);
      p.decide(bloops);
      p.run();
      p.eat(bloops);
      // If it's dead, kill it and make food
      if (p.dead()) {
        predators.remove(i);
        food.add(p.location);
      }
      // Perhaps this bloop would like to make a baby?
      //Predator child = p.reproduce();
      Predator child = p.reproduce(predators);
      if (child != null) predators.add(child);
    }

    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = bloops.size()-1; i >= 0; i--) {
      // All bloops run and eat
      Bloop b = bloops.get(i);
      b.run();
      b.eat(food);
      // If it's dead, kill it and make food
      if (b.dead()) {
        bloops.remove(i);
        food.add(b.location);
      }
      // Perhaps this bloop would like to make a baby?
      //asexual
      Bloop child = b.reproduce();
      //sexual
      //Bloop child = b.reproduce(bloops);

      if (child != null) bloops.add(child);
    }
    //output
    if (time % 5 == 0) {
      //here let's try to do some sort of visualization of the pop sizes.
      bloop_size.add(bloops.size());
      pred_size.add(predators.size());
      
      if (maxBloops < bloops.size())
        maxBloops = bloops.size();
        
      if (maxPreds < predators.size())
        maxPreds = predators.size();
      
      if(bloop_size.size() > 400) {
        bloop_size.remove(0);
        pred_size.remove(0);
      }
      
      time = 0;
      writeToOutput();
    }

    time++;
  }

  void stopped() {
    //check if the mouse location is over the bloops and preds
    
    food.run();
    
    for (int i = bloops.size()-1; i >= 0; i--) {
      Bloop b = bloops.get(i);
      b.display();
      if (mouseX > b.location.x - b.r && mouseX < b.location.x + b.r) {
        if (mouseY > b.location.y - b.r && mouseY < b.location.y + b.r) {
          
          b.mouseOver();
        }
      }
    }

    for (int i = predators.size()-1; i >= 0; i--) {
      Predator p = predators.get(i);
      p.display();
      if (mouseX > p.location.x - p.r && mouseX < p.location.x + p.r) {
        if (mouseY > p.location.y - p.r && mouseY < p.location.y + p.r) {
          
          p.mouseOver();
        }
      }
      
    }
  }
  
  void updateStats() {
    
  }

  void saveBloops() {
    PVector l = new PVector(random(w_width), random(w_height));
    DNA dna = new DNA();
    bloops.add(new Bloop(l, dna, 200));
  }

  void savePredators() {
    PVector l = new PVector(random(w_width), random(w_height));
    DNA dna = new DNA();
    predators.add(new Predator(l, dna, 200));
  }
  
  void writeToOutput() {
    output.println(bloops.size() + " " + predators.size());
  }

  void keyMoveUP() { 
    for (int i = predators.size()-1; i >= 0; i--) {
      Predator p = predators.get(i);
      p.forward(1);
    }
  }

  void keyMoveDOWN() {
    for (int i = predators.size()-1; i >= 0; i--) {
      Predator p = predators.get(i);
      p.forward(-1);
    }
  }

  void keyMoveLEFT() {
    for (int i = predators.size()-1; i >= 0; i--) {
      Predator p = predators.get(i);
      p.turn(-1);
    }
  }

  void keyMoveRIGHT() {
    for (int i = predators.size()-1; i >= 0; i--) {
      Predator p = predators.get(i);
      p.turn(1);
    }
  }
}