class Crosshair{
 int x,y,r;
 int vx, vy;  // Velocity in x and y directions
 
 PImage CrosshairImg; //Image for the crosshair
 
 Crosshair(){
  x = width/2;    //Default starting position (center of the screen)
  y = height/2;
  r = 15;        //Circle radius
  CrosshairImg = loadImage("Crosshair.png"); //Load crosshair image
 }

// Function to update the position of the cross hair
  void update(){  //update where target moves to
  //Horizontal movement
  if (left){
    vx = -25; //Move left
  }
  if (right){
    vx = 25; //Move right
  }
  if(!left && !right){
    vx = 0; // Stop horizontal movement
  }  
  
  //Vertical movement
  if (up){ 
    vy = -25; //Move up
  }
  if (down){
    vy = 25; //Move down
  }
  if(!up && !down){
    vy = 0; //Stop vertical movement
  }
 
 //Update position based on velocity
  x += vx;
  y += vy;
  
  // Boundary checks to prevent the crosshair from moving off the screen
    if (x < 0) {
      x = 0;
    }
    if (x > width - CrosshairImg.width) {
      x = width - CrosshairImg.width;
    }
    if (y < 0) {
      y = 0;
    }
    if (y > height - CrosshairImg.height) {
      y = height - CrosshairImg.height;
    }
  
  }  

//Function to display the crosshair
  void display(){
   image(CrosshairImg, x, y);  
  }
}
