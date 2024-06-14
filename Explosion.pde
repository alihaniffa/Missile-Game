class Explosion {
  float x, y;
  int frame = 0;
  int frameInterval = 100; // Time between frames in milliseconds
  int lastFrameTime;
  boolean active = true; //Flag to check if the explosion is active

  Explosion(float x, float y) {
    this.x = x; //Initialise the x position
    this.y = y; //Initialise the y position
    lastFrameTime = millis(); //Record the time when explosition was created
  }

//Function to update the explosition animation
  void update() {
    if (active && millis() - lastFrameTime >= frameInterval) {
      frame++; //Move to the next frame
      lastFrameTime = millis();
      if (frame >= explosionImages.length) {
        active = false; // Deactive the explosion if the last frame is reached
      }
    }
  }

//Function to display the explosion
  void display() {
    if (active) {
      // Draw the current frame of the explostion centered at (x,y)
      image(explosionImages[frame], x - explosionImages[frame].width / 2, y - explosionImages[frame].height / 2);
    }
  }
}
