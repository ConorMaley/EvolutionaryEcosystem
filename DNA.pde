//Evolutionary Ecosystem
//Conor Maley
// Adapted from: Daniel Shiffman <http://www.shiffman.net>

// Class to describe DNA
// Has more features for two parent mating (not used in this example)

class DNA {

  // The genetic sequence
  float[] genes;
  
  // Constructor (makes a random DNA)
  DNA() {
    // DNA is random floating point values between 0 and 1 (!!)
    genes = new float[5];
    for (int i = 0; i < genes.length; i++) {
      genes[i] = random(-1,1);
    }
    
    genes[0] = abs(genes[0]);
  }
  
  DNA(float[] newgenes) {
    genes = newgenes;
  }
  
  DNA copy() {
    float[] newgenes = new float[genes.length];
    //arraycopy(genes,newgenes);
    // JS mode not supporting arraycopy
    for (int i = 0; i < newgenes.length; i++) {
      newgenes[i] = genes[i];
    }
    
    return new DNA(newgenes);
  }
  
  //random gene crossover
  DNA crossover(DNA a, DNA b) {
    float[] newgenes = new float[genes.length];
    for (int i = 0; i < newgenes.length; i++) {
      if (floor(random(0, 2)) == 0) {
        newgenes[i] = a.genes[i];
      }
      else {
        newgenes[i] = b.genes[i];
      } 
    }
    return new DNA(newgenes);
  }
  
  // Based on a mutation probability, picks a new random character in array spots
  void mutate(float m) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < m) {
         genes[i] = random(0,1);
      }
    }
    if (genes[0] < 0) {
      genes[0] = abs(genes[0]);
    }
  }
}