/**
 * Assignment 3 (Naba Khan, Ali Haniffa, Aidan Schultz)
 * 
 *
 * This is a simplified version of the classic Missile Command game. 
 * The player controls an anti-missile battery to protect cities from falling missiles. 
 * The game includes multiple rounds, increasing difficulty, and a game-over screen.
 *
 * How to play the game:
 * Use arrow keys to move the crosshair.
 * Press the space bar to fire anti-missiles at falling missiles.
 * Protect your cities from being destroyed by the missiles.
 * Each round will end after 30 seconds and it will get more difficult as the levels progress.
 **/

// Global variables
ArrayList<Missile> missiles; //List to store falling missiles
AntiMissile n;
Crosshair c;
ArrayList<AntiMissile> NAM; //List to store fired anti-missiles
City[] cities;
City[] cities2;
AntiMissileBattery battery;
ArrayList<Explosion> explosions = new ArrayList<Explosion>(); //List to store explosions

int score = 0;
int round = 1;
int missilesPerRound = 20;
int missileSpeed = 5;
int roundDuration = 30000; // 30 seconds
int startTime;
int missileInterval;
int lastMissileTime;
boolean gameOver = false;
int lastRoundEndTime;
boolean roundActive = true;

// Variables for player control
PVector batteryPosition; //Position of the anti-missile battery
PVector crosshairPosition;

// Images
PImage MissileImg;
PImage AntiMissileBatteryImg;
PImage CityImg;
PImage BrokenCityImg;
PImage CrosshairImg;
PImage BackgroundImg;
PImage AntiMissileImg;
PImage[] explosionImages = new PImage[4];

//Control flags
boolean left, up, right, down, NAMfired; //Control flags for arrow keys and firing

//Font
PFont retroFont;

void setup() {
  size(1440, 810); // Set canvas size
  retroFont = createFont("Retro Gaming.ttf", 64); //Retro gaming font
  
// Load images
  MissileImg = loadImage("Missile.png");
  AntiMissileBatteryImg = loadImage("AntiMissileBattery.png");
  CityImg = loadImage("City.png");
  BrokenCityImg = loadImage("BrokenCity.png");
  CrosshairImg = loadImage("Crosshair.png");
  BackgroundImg = loadImage("Background.png");
  AntiMissileImg = loadImage("NormalAntiMissile.png");
   for (int i = 0; i < explosionImages.length; i++) {
    explosionImages[i] = loadImage("Explosion" + (i + 1) + ".png");
  }
  
  missiles = new ArrayList<Missile>(); //Initalise missiles list
  cities = new City[6]; //Initalise cities array
  NAM = new ArrayList<AntiMissile>(); //Initalise anti-missiles list

// Define the gap for the anti-cannon
int gapWidth = 100; 
int cityWidth = width / 7;
int xAxisConstant = 150;
int yAxisConstant = 50;

// Initialise cities at the bottom of the screen
for (int i = 0; i < cities.length; i++) {
  if (i < cities.length / 2) {
    // Position cities on the left side of the gap
    cities[i] = new City(xAxisConstant + i * cityWidth, height - yAxisConstant);
  } else {
    // Position cities on the right side of the gap
    cities[i] = new City(xAxisConstant + i * cityWidth + gapWidth, height - yAxisConstant);
  }
}
  
// Initialise battery and crosshair positions
  battery = new AntiMissileBattery(width / 2, height - 100);
  batteryPosition = new PVector(4 * width/7 - 150, height - 100);
  crosshairPosition = new PVector(width / 2, height / 2);
  startTime = millis(); // Record the start time
  lastMissileTime = startTime;
  missileInterval = roundDuration / missilesPerRound; // Calculate interval between missile launches
  
//Normal antimissile targetting/crosshair control
  left = false;
  up = false;
  right = false;
  down = false;
  c = new Crosshair(); 
  n = new AntiMissile();
}

void draw() {
  if (gameOver) {
    displayGameOverScreen(); //Display game over screen if game is over
  } else {
    background(BackgroundImg); // Clear the screen with the background image
  
// Check for missile generation
  int currentTime = millis();
  if (currentTime - lastMissileTime >= missileInterval) {
    generateMissile(); // Generate a new missile
    lastMissileTime = currentTime;
  }
  
// Update and display missiles
  updateMissiles();
  updateAntiMissiles();

  displayCities(); // Display cities
  displayBattery(); // Display battery
  displayScore(); // Display score and round
  c.update();    //Update crosshair
  c.display();   //Display crosshair
  n.update();   //Update anti-missile

// Update and display explosions
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion explosion = explosions.get(i);
    explosion.update();
    explosion.display();
    if (!explosion.active) {
      explosions.remove(i);
    }
  }
   
// Check if the round duration has passed
  checkRoundProgress();
  
// Check for game over
    checkGameOver();
  }
}

// Function to display cities
void displayCities() {
  for (City city : cities) {
    city.display();
  }
}

// Function to display the anti-missile battery
void displayBattery() {
  image(AntiMissileBatteryImg, batteryPosition.x, batteryPosition.y);
}

// AntiMissile controls
void keyPressed(){
 if (keyCode == LEFT){
   left = true;
 }else if (keyCode == UP){
   up = true;
  }else if (keyCode == RIGHT){
   right = true;
  }else if (keyCode == DOWN){
   down = true;
  }
  if (key == ' ') {
    AntiMissile n = new AntiMissile();
    n.NAMfired(width / 2, height, 5, 5); //Fire anti-missile towards crosshair
    NAM.add(n);
  }
}

void keyReleased(){
 if (keyCode == LEFT){
   left = false;
 }else if (keyCode == UP){
   up = false;
  }else if (keyCode == RIGHT){
   right = false;
  }else if (keyCode == DOWN){
   down = false;
  }
}

// Function to display the player's score and round
void displayScore() {
  fill(255); // White text colour
  textFont(retroFont, 32); // Set the font and size
  text("Score: " + score, 10, 40); //Display score at top-left corner
  text("Round: " + round, 10, 80); //Display round below the score
}

//Function to generate a missile
void generateMissile() {
  float x = random(width);
  missiles.add(new Missile(x, 0, missileSpeed)); 
}

//Function to update missiles
void updateMissiles() {
 for (int i = missiles.size() - 1; i>=0; i--) {
   Missile m = missiles.get(i);
   m.move();
   m.display();
 
// Check if missile hits a City
 for (City city : cities) {
   if (!city.destroyed && m.hits(city)) {
     city.destroyed = true;
     missiles.remove(i);
     explosions.add(new Explosion(m.x, m.y));
     break;
   }
 }
 
// Check if missile hits an anti-missile
    for (int j = NAM.size() - 1; j >= 0; j--) {
      AntiMissile am = NAM.get(j);
      if (am.hits(m)) {
        missiles.remove(i);
        NAM.remove(j);
        score += 10; // Increase score by 10 for each hit
        explosions.add(new Explosion(m.x, m.y));
        break; // Exit the loop once the missile is removed
      }
    }
    
//Remove missiles if it goes off the screen    
 if (m.y > height) {
   missiles.remove(i);
  }
 }
}

//Function to update anti-missiles
void updateAntiMissiles() {
  for (int i = NAM.size() - 1; i >=0; i--) {
    AntiMissile am = NAM.get(i);
    am.update();
    am.display();
  }
}

// Function to start a new round
void startNewRound() {
  round++;
  missileSpeed += 2; // Increase missile speed
  missilesPerRound += 5; 
  missileInterval = roundDuration / missilesPerRound; // Recalculate interval between missile launches
  lastRoundEndTime = millis(); // Reset the round timer
  startTime = millis(); // Record the start time for the new round
  lastMissileTime = startTime; // Reset the missile generation timer
}

// Function to check round progress and start a new round if necessary
void checkRoundProgress() {
  int currentTime = millis();
  if (currentTime - lastRoundEndTime >= roundDuration) {
    startNewRound(); // Start a new round if the current round duration has passed
  }
}

// Function to check if all cities are destroyed to end the game
void checkGameOver() {
  gameOver = true; // Assume all cities are destroyed
  for (City city : cities) {
    if (!city.destroyed) {
      gameOver = false; // If any city is not destroyed, the game is not over
      break;
    }
  }
}

// Function to display the game over screen
void displayGameOverScreen() {
  background(0); // Black background 
  fill(0, 255, 0); // Green text color
  textFont(retroFont, 64);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width / 2, height / 2); // Display "GAME OVER" text
  textFont(retroFont, 32);
  text("Score: " + score, width / 2, height / 2 + 60); // Display final score
}
