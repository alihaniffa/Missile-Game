class City {
  float x, y;
  boolean destroyed = false; // Flag to check if the city is destroyed

  City(float x, float y) {
    this.x = x; //Initalise x position
    this.y = y; //Initalise y position
  }

// Function to display the city
  void display() {
    if (!destroyed) {
      // If the city is not destroyed, display the intact city image centered at (x, y)
      image(CityImg, x - CityImg.width / 2, y - CityImg.height / 2);
    } else {
      // If the city is destroyed, display the broken city image centered at (x, y)
      image(BrokenCityImg, x - BrokenCityImg.width / 2, y - BrokenCityImg.height / 2);
    }
  }
}
