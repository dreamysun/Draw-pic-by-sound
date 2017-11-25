import processing.video.*;
import ddf.minim.*;
Minim minim;
AudioInput music;
//AudioPlayer music;
Capture capture;
float r,volume;

void setup(){
  size(1280,720);
  background(0);
  colorMode(HSB,255);
  minim = new Minim(this);
  music = minim.getLineIn();
  //music = minim.loadFile("Breath and Life.mp3", 2048);
  //music.loop();
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]+", "+i);
    }
  }
  capture = new Capture(this, width, height);
  capture.start(); 
}

void draw(){
  volume = music.left.level()+music.right.level();
  float maxVolume = 1; 
  
  if (capture.available()) {
    capture.read();
    capture.loadPixels();

    for(int i=0; i<music.bufferSize()/20; i++){
      r = map(volume,0,maxVolume,0.7,5)*random(0.5,3);
      noStroke();
      float x = width*(0+i*0.02)+random(-music.right.get(i)*600,music.right.get(i)*600);
      x = constrain(x,0,width);
      color c = capture.get(int(x),int(height-music.left.get(i)*760));
      float ratio = map(volume,0,maxVolume,0.5,2);
      float b = brightness(c)*ratio;
      b = constrain(b,50,255);
      fill(hue(c),saturation(c),b,150);
      ellipse(x,height-music.left.get(i)*760,r*2,r*2);
    }
  }
}