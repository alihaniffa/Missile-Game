class AntiMissile{
  float speed, angle;
  float x,y,h,w,vx,vy;

  boolean active;
  boolean destroyed = false; // Flag to check if the anti-missile is destroyed
  
  AntiMissile(){
    active = false; // Initialise as inactive
    speed = 20;
    angle = 0;    
  }
 
// Function to update the anti-missiles position
  void update(){
    x += vx;
    y += vy;
   // Check if the anti-missile is out of the bounds and deactivate if so
    if (x < 0  || x > width){
      active = false;
    }
    if (y < 0 || y > height){
      active = false;  
    }
  }

//Function to display the anti-missile
  void display() {
    image(AntiMissileImg, x - AntiMissileImg.width / 2, y - AntiMissileImg.height / 2);
  }

//Function to fire the anti-missile
  void NAMfired(float sx, float sy, float sw, float sh){
    active = true; // Activate the anti-missile
    x = sx + sw/2 - w/2; 
    y = sy - 100;
    angle = atan2(c.y - y, c.x - x); //Calculate angle in reference to cross hair position

//Calculate velocity components based on the angle and speed
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
  }

// Checks if the anti-missile hits a missile
  boolean hits(Missile missile) {
    // Calculates the centrers of the anti-missile and the missile
    float antiMissileCenterX = x;
    float antiMissileCenterY = y;
    float missileCenterX = missile.x;
    float missileCenterY = missile.y;
    
    // Checks the distance between the centres and return true if they collide
    return dist(antiMissileCenterX, antiMissileCenterY, missileCenterX, missileCenterY) < 50; // Adjust radius as needed
  }   
}
