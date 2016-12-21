//Evolutionary Ecosystem
//Conor Maley
//Adapted from: Daniel Shiffman <http://www.shiffman.net>

//Two types of Creatures: predators and prey (bloops)
//Predators eat Bloops
//Bloops move at random
//Predators move based on if they see a prey or not
//Their sight is dependent on their antennas

// A World of creatures that eat food
// The more they eat, the longer they survive
// The longer they survive, the more likely they are to reproduce
// The bigger they are, the easier it is to land on food
// The bigger they are, the slower they are to find food
// When the creatures die, food is left behind


// PRESS SPACE TO PAUSE AND ENTER VIEWING MODE.

World world;
PrintWriter output;
boolean stop; 
int w_height, w_width;


void setup() {
  w_height = 600;
  w_width = 800;
  size(800, 800);
  
  stop = false;
  
  //output to analyze pop sizes
  output = createWriter("data.txt");
  output.println("NumBloops NumPredators");
  
  // World starts with 10 bloops
  // Start with 10 predators
  // and 50 pieces of food
  world = new World(10, 10, 50);
  smooth();
}

void draw() {
  background(255);
  
  if (!stop) {
    world.run();
  }
  else
  {
    world.stopped();
  }
  stroke(255);
  fill(255);
  rectMode(CORNER);
  rect(0, w_height, w_width, 200);
  stroke(0);
  //                         height + max radius
  line(0, w_height, w_width, w_height);
  
}

// We can add a creature manually if we so desire
void mousePressed() {
  world.bornPredator(mouseX,mouseY); 
}

void stop() {
  output.flush();
  output.close();
  exit();
}

void keyPressed() {
  //if (key == CODED) {
  //  if (keyCode == UP) {
  //    world.keyMoveUP();
  //  }
  //  else if (keyCode == DOWN) {
  //    world.keyMoveDOWN();
  //  }
  //  else if (keyCode == LEFT) {
  //    world.keyMoveLEFT();
  //  }
  //  else if (keyCode == RIGHT) {
  //    world.keyMoveRIGHT();
  //  }
    
  //}
  
  if (key == ' ') {
    stop = !stop;
  }
  
  //if (key == 'w' || key == 'W') {
  //  world.keyMoveUP();
  //}
  //else if (key == 'a' || key == 'A') {
  //  world.keyMoveLEFT();
  //}
  //else if (key == 's' || key == 'S') {
  //  world.keyMoveDOWN();
  //}
  //else if (key == 'd' || key == 'D') {
  //  world.keyMoveRIGHT();
  //}
  
  
}