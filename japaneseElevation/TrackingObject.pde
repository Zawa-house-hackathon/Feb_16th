// Launches your webcam and when you select an object it will track it.
// By modifying the code below you can change the type of tracker used.
// None of the trackers are perfect and they each have different strengths
// and weaknesses.

import processing.video.*;
import boofcv.processing.*;
import boofcv.struct.image.*;
import georegression.struct.point.*;
import georegression.struct.shapes.*;

Capture cam;
SimpleTrackerObject tracker;

// storage for where the use selects the target and the current target location
Quadrilateral_F64 target = new Quadrilateral_F64();
// if true the target has been detected by the tracker
boolean targetVisible = false;
PFont f;
// indicates if the user is selecting a target or if the tracker is tracking it
int mode = 0;
double tempx;
double tempy;
int size;

PImage mapImg;
void setup() {
  // Open up the camera so that it has a video feed to process
  initializeCamera(800, 600);
  surface.setSize(cam.width, cam.height);

  // Select which tracker you want to use by uncommenting and commenting the lines below
  //    tracker = Boof.trackerCirculant(null, ImageDataType.F32);
  tracker = Boof.trackerTld(null, ImageDataType.F32);
  //    tracker = Boof.trackerMeanShiftComaniciu(null, ImageType.ms(3,GrayF32.class));
  //    tracker = Boof.trackerSparseFlow(null, ImageDataType.F32);

  f = createFont("Arial", 32, true);
  
  oauth = new OAuthRestAPI();
  String[] locations = new String[2];
  try {
    Paging paging = new Paging ( 1 );
    List<DirectMessage> messages;
    messages = twitter.getDirectMessages( paging );
    for ( DirectMessage message : messages ) {
      println( message.getText() );
    }
    locations = getLocation(messages.get(0).getText());
    println(locations[0] +"¥n"+ locations[1]);
  }
  
  catch ( TwitterException te ) {
    println( te );
  }
  
  float[][] map = getAroundElevMap(float(locations[0]), float(locations[1]), 10, 0.6);
  //テスト用
  //for(int i=0; i<wid; i++)for(int j=0; j<hig; j++)map[i][j] = i+j;
  mapImg = generateImg(map);
}

void draw() {
  if (cam.available() == true) {
    cam.read();

    if ( mode == 1 ) {
      targetVisible = true;
    } else if ( mode == 2 ) {
      // user has selected the object to track so initialize the tracker using
      // a rectangle.  More complex objects and be initialized using a Quadrilateral.
      if ( !tracker.initialize(cam, target.a.x, target.a.y, target.c.x, target.c.y) ) {
        mode = 100;
      } else {
        targetVisible = true;
        mode = 3;
      }
    } else if ( mode == 3 ) {
      // Update the track state using the next image in the sequence
      if ( !tracker.process(cam) ) {
        // it failed to detect the target.  Depending on the tracker this could mean
        // the track is lost for ever or it could be recovered in the future when it becomes visible again
        targetVisible = false;
      } else {
        // tracking worked, save the results
        targetVisible = true;
        target.set(tracker.getLocation());
      }
    }
  }
  image(cam, 0, 0);

  // The code below deals with visualizing the results
  textFont(f);
  textAlign(CENTER);
  fill(0, 0xFF, 0);
  if ( mode == 0 ) {
    text("Click and Drag", width/2, height/4);
  } else if ( mode == 1 || mode == 2 || mode == 3) {
    if ( targetVisible ) {
      drawTarget();
    } else {
      text("Can't Detect Target", width/2, height/4);
    }
  } else if ( mode == 100 ) {
    text("Initialization Failed.\nSelect again.", width/2, height/4);
  }
}

void mousePressed() {
  // use is draging a rectangle to select the target
  mode = 1;
  target.a.set(mouseX, mouseY);
  target.b.set(mouseX, mouseY);
  target.c.set(mouseX, mouseY);
  target.d.set(mouseX, mouseY);
  tempx=target.b.x;
  tempy=target.d.y;
}

void mouseDragged() {
  target.b.x = mouseX;
  target.c.set(mouseX, tempy+mouseX-tempx);
  target.d.y = tempy+mouseX-tempx;
}

void mouseReleased() {
  // After the mouse is released tell it to initialize tracking
  mode = 2;
}

// Draw the target using different colors for each side so you can see if it is rotating
// Most trackers don't estimate rotation.
void drawTarget() {
  size = (int)(target.b.x-target.a.x);
  noFill();
  strokeWeight(3);
  stroke(255, 0, 0);
  line(target.a, target.b);
  stroke(0, 255, 0);
  line(target.b, target.c);
  stroke(0, 0, 255);
  line(target.c, target.d);
  stroke(255, 0, 255);
  line(target.d, target.a);
  PImage img;
  img = bumpImage(get((int)target.a.x,(int)target.a.y, size, size), mapImg);
  image(img, (float)target.a.x, (float)target.a.y, size, size);
}

void line( Point2D_F64 a, Point2D_F64 b ) {
  line((float)a.x, (float)a.y, (float)b.x, (float)b.y);
}

void initializeCamera( int desiredWidth, int desiredHeight ) {
  String[] cameras = Capture.list();
  for (int i=0; i<cameras.length; i++) {
    println(cameras[i]);
  }
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    cam = new Capture(this, desiredWidth, desiredHeight);
    cam.start();
  }
}

PImage createNormalMap(PImage normalMap){
  PImage ret = loadImage("000.png");
  int wid = normalMap.width;
  int hig = normalMap.height;
  ret.resize(wid, hig);
  for(int i=0; i<wid; i++){
    for(int j=0; j<hig; j++){
      int index = j * normalMap.width + i;
      color col = normalMap.pixels[index];
      if(col==color(0,0,255)){
        ret.pixels[index] = color(0,0,255);
        continue;
      }
      red(col);
      if(i-1<0)ret.pixels[index] = color(0,0,255);//outof
      if(i+1>normalMap.width-1)ret.pixels[index] = color(0,0,255);//outof
      int dx = (normalMap.pixels[j * normalMap.width + (i+1)]-normalMap.pixels[j * normalMap.width + (i-1)])/2;
      if(j-1<0)ret.pixels[index] = color(0,0,255);//outof
      if(j+1>normalMap.height-1)ret.pixels[index] = color(0,0,255);//outof
      int dy = (normalMap.pixels[(j+1) * normalMap.width + 1]-normalMap.pixels[(j-1) * normalMap.width + i])/2;
    }
  }
  return ret;
}

PImage bumpImage(PImage base, PImage heightMap){
  for(int i=0; i<base.width; i++){
    for(int j=0; j<base.height; j++){
      color baseCol = base.pixels[j*base.width + i];
      color heigCol = heightMap.pixels[j*heightMap.height/base.height*heightMap.width + i*heightMap.width/base.width];
      if(heigCol == color(0,0,255)){
        base.pixels[j*base.width + i] = color(250, 250, 240, 255);
        continue;
      }
      int heights = (int)red(heigCol);
      base.pixels[j*base.width + i] = color(heights/5, heights, heights/5);
    }
  }
  return base;
}