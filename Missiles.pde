class Missile {
  float x, y;
  float speed;
  boolean destroyed = false; //Flag to check if the missile is destroyed

  Missile(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed; // Set the speed of the missiles
  }

// Function to move the missile down the screen
  void move() {
    y += speed; //Update the y position based on the speed
  }

// Function to display the missile
  void display() {
    image(MissileImg, x - MissileImg.width / 2, y - MissileImg.height / 2);
  }

// Check if the missile hits a city
 boolean hits(City city) {
    // Calculate the centeres of the missiles and the city
    float missileCenterX = x;
    float missileCenterY = y;
    float cityCenterX = city.x;
    float cityCenterY = city.y;
    // Check the distance between the centers and return true if they collide
    return dist(missileCenterX, missileCenterY, cityCenterX, cityCenterY) < 100; 
  }

// Check if the missile hits an anti-missile                                                           
 boolean hits(AntiMissile antiMissile) {
    // Calculate the centers of the missile and the anti-missile
    float missileCenterX = x;
    float missileCenterY = y;
    float antiMissileCenterX = antiMissile.x;
    float antiMissileCenterY = antiMissile.y;
    return dist(missileCenterX, missileCenterY, antiMissileCenterX, antiMissileCenterY) < 25; 
  }
}
