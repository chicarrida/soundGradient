import ddf.minim.*;
import ddf.minim.analysis.*;


float x;
float y;
float speed;
float rad;
float maxDim = 0;
float [] specVals;
int specSize;
int strk = 150;
float r, g, b;

Minim minim;
AudioInput input;
FFT fft; 
AudioPlayer player;

void setup () {
  // Sketch einstellen
  size (600, 300);
  smooth();
  stroke (60,60,60);
  specVals = new float[10];

  noFill ();
  // Startposition festlegen
  x = 150;
  y = 90;

  // Audiotoolkit anlegen
  minim = new Minim (this);
  
  //player = minim.loadFile("coma.mp3", 2048);
  //player.loop();
  fft = new FFT(player.bufferSize(), player.sampleRate());
  
  input = minim.getLineIn (Minim.STEREO, 512);
  fft = new FFT(input.bufferSize(), input.sampleRate());
  //background (0);
   background (60,60,60);
}
 
void draw () {

  //fft.forward(player.mix);
   fft.forward(input.mix);
  // Kreisgröße Abhängig von Lautstärke
  // float dim = player.mix.level () * width;
  float dim = input.mix.level()*width;
  rad = dim;    

  specSize = fft.specSize();
  println(specSize);
  specSize /= 10;
  
  for(int j = 0; j < 10; j++){
    
    for(int i = specSize*j; i < specSize*(j+1); i++){
      specVals[j] = Math.max(fft.getBand(i), fft.getBand(i-1));
    }    
  }
  for(int i = 1; i < specSize; i++){
    r = Math.max(fft.getBand(i), fft.getBand(i-1));
  }
   for(int i = specSize; i < specSize*2; i++){
    g = Math.max(fft.getBand(i), fft.getBand(i-1));
  }
   for(int i = specSize*2; i < specSize*3; i++){
    b = Math.max(fft.getBand(i), fft.getBand(i-1));
  }
 
 r = map(r, 0, 0.4, 0, 255);
 g = map(g, 0, 0.4, 0, 255);
 b = map(b, 0, 0.4, 0, 255);
 

 //background(r,g,b);  

 /*
  fill(r,0,0);
  ellipse (100, 100, 100, 100);
  fill(0,g,0);
  ellipse (300, 100, 100, 100);
  fill(0,0,b);
  ellipse (500, 100, 100, 100);
*/

for(int i = 0; i < 10;  i++){
  specVals[i]= map(specVals[i], 0,0.4,0,255);
}
int rrad = 30;
int alphaVal = 50;

/*for(int i = 0;i < 3; i++){
  createGradient(60*(i+1), 100, rrad, color(specVals[i],0,0),color(0,0,specVals[i]));
}*/

 createGradient(150,150,50,color(79,9,87),color(255,8,7));
// createGradient(450,150,100,color(0,g,0),color(0,0,(int)b));
// createGradient(150,150,100,color(r,0,0),color(0,(int)g,0));
}

/**
*Funktion um Gradient zu erstellen
**/
void createGradient (float x, float y, float radius, color c1, color c2){

  float px = 0, py = 0, angle = 0;

  // calculate differences between color components 
  float deltaR = red(c2)-red(c1);
  float deltaG = green(c2)-green(c1);
  float deltaB = blue(c2)-blue(c1);
  
  // hack to ensure there are no holes in gradient
  // needs to be increased, as radius increases
  float gapFiller = 8.0;

  int i;
  
  for (i=0; i< radius; i++){
    for (float j=0; j<360; j+=1.0/gapFiller){
      px = x+cos(radians(angle))*i;
      py = y+sin(radians(angle))*i;
      angle+=1.0/gapFiller;
      
      color c = color(
      (red(c1)+(i)*(deltaR/radius)),
      (green(c1)+(i)*(deltaG/radius)),
      (blue(c1)+(i)*(deltaB/radius))
        );
      set(int(px), int(py), c);           
    }
  }  

  // adds smooth edge 
  // hack anti-aliasing
  noFill();
  strokeWeight(3);
  ellipse(x, y, radius*2, radius*2);
}


/**
* Stop den ganzen Audio Kram
*/
void stop(){
 //player.close();
  minim.stop();
  super.stop();
}
