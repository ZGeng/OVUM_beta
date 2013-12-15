import java.util.Arrays;
import java.awt.Desktop;
import java.io.*;
import fisica.*;
import geomerative.*;
import ddf.minim.*;
import oscP5.*;
import netP5.*;

//control part
OscP5 oscP5;
Skeleton skeleton = new Skeleton();
PVector rightposition;
PVector leftposition;
float leftPtx, leftPty, rightPtx, rightPty; //for adjust kinect positions
//sound part
Minim minim;
AudioSample bump;
AudioSample eat;
AudioSample explode;
AudioPlayer bgm;
boolean hit;

//intro screen
PFont titleFont;
PFont bodyFont;
int numBubbles = 35;
Bubble[] bubbles;//intro scene

//phicial world part
FWorld world;
float gravity;
Jelly jelly;
float jellysize;
Tunnel tunnel;
ArrayList<Enemy> enemies;

int waitTime;//delay between scenes

//rescale screen part
float scale;
float offset; 
int gamewidth = 600;
int gameheight = 600;// the width and height of the screen world

//level and scene switch
String scene;//begin/prepare/instructor/ending 
boolean spaceHit; //to trigger the scene switch
int level;//level number 

PGraphics pg;

void setup() {
  //open("Synapse.app");
  //control part
  oscP5 = new OscP5(this, 12345);
  //scene and level 
  spaceHit = false;
  waitTime = 0; //record switchtimes
  level = 0;
  jellysize = gamewidth/10;
  gravity = 0;
  //display resscale
  size(displayWidth, displayHeight, P3D);
  background (#424242);
  scale = float(displayHeight)/float(gameheight);
  scale(scale, scale);
  offset = float(displayWidth)/2/scale - float(gamewidth)/2;
  translate(offset, 0, 0);
  rightposition= new PVector(0, 0);
  leftposition= new PVector(0, 0);    
  //add fonts
  fill(#75CDB9);
  titleFont = loadFont("basictitlefont-48.vlw");
  fill(#F7B84B);
  bodyFont = loadFont("Dialog.plain-48.vlw");
  //create additional display image
  pg = createGraphics(displayWidth, displayHeight);
  //sound part
  minim = new Minim(this);
  hit = false;
  eat = minim.loadSample("118649__pyzaist__bump.wav", 512);
  bump = minim.loadSample("35920__altemark__rimshot.wav", 512);
  explode = minim.loadSample("bubble_pop_1.wav", 512);
  bgm = minim.loadFile("bubble_music.wav");
  bgm.play();//start the bgm

  bubbles = new Bubble[numBubbles];

  for (int i = 0; i < numBubbles; i++) {
    bubbles[i] = new Bubble();

    scene = "begin";//begin scene   
    initiate();//initiate the left content
  }
}


void draw() { 
  skeleton.update(oscP5);//refresh control signal 

  //1ST INTRO-SCENE
  if (scene =="begin") {
    println("here");
    background (#424242);
    // DRAW THE BUBBLE   
    for (int i = 0; i < bubbles.length; i++) {//the floating bubble effect
      bubbles[i].update();
      bubbles[i].drawBubs();
      if ( bubbles[i].loc.y < -50) {
        bubbles[i].reset();
      }
    }     
    //DRAW THE TITLE
    fill(#75CDB9);  
    textFont(titleFont, int(72*scale));
    text("O V U M", (width/2)-95*scale, (height/2 -50*scale));
    //WAIT THE KINECT TO BE SETUP
    if (skeleton.isTracking()) { 
      //DRAW THE BODY TEXT
      fill(#FFFFFF);
      textFont(bodyFont, int(12*scale));
      text("press space to begin", (width/2)-55*scale, (height/2)); 

      //press space and start next scene
      if (spaceHit) {
        scene = "instructor";
        spaceHit = false;
      }
    }
  }

  // 2ND INSTROCTOR-SCENE
  else if (scene =="instructor") {
    background (#424242);
    fill(#75CDB9);  
    textFont(titleFont, 50*scale);
    text("I N S T R U C T I O N S", (width/2)-190*scale, (height/2 -150*scale));

    fill(#FFFFFF);
    textFont(bodyFont, int(12*scale));
    text("separate your arms to grow wider\nbring them together to grow thinner\nlift them your arms to go faster \nlower them to go slower", (width/2)-80*scale, (height/2)-100*scale);

    fill(#F7B84B);
    textFont(bodyFont, int(16*scale));
    text("press space to continue", (width/2)-85*scale, height-30*scale);
    if (spaceHit) {
      scene = "prepare";
      spaceHit = false;
    }//switch scene
  }


  // 3RD OTHER-SCENE
  else if ((scene =="prepare")||(scene =="play")||(scene =="end")) {
    //SETUP MOVING CAMERA TO FOLLOW THE JELLY
    float cameraY = jelly.getY();
    cameraY = constrain(cameraY, -gameheight*20, gameheight/2-10);
    camera(gamewidth/2, cameraY, 300.0, gamewidth/2, jelly.getY(), 0.0, 0.0, 1.0, 0.0); 

    background (#424242);
    translate(0, 0, -2);
    world.draw();
    translate(0, 0, 2);
    world.step(); 

    // apply the control part use kinect to detect the hand positions
    Joint lefthand= null;  
    Joint righthand = null;

    lefthand = skeleton.getJoint("lefthand");
    leftposition = lefthand.posScreen;
    righthand = skeleton.getJoint("righthand");
    rightposition = righthand.posScreen;
    //map the data to the gameworld scale
    float leftmovex=map(leftposition.x, 0, 640, 0, gamewidth); 
    float leftmovey=map(leftposition.y, 0, 400, 0, gameheight);
    float rightmovex=map(rightposition.x, 0, 640, 0, gamewidth);
    float rightmovey=map(rightposition.y, 0, 400, 0, gameheight);
    //get the direct control vectors
    PVector shapeControl = new PVector(rightmovex-leftmovex, rightmovey-leftmovey);
    PVector moveControl = new PVector((rightmovex+leftmovex)/2-gamewidth/2, (rightmovey+rightmovey)/2-height/2);

    strokeWeight(1);

    ellipse(leftmovex, leftmovey-gameheight/2+jelly.getY(), 10, 10);
    ellipse(rightmovex, rightmovey-gameheight/2+jelly.getY(), 10, 10);

    // the prepare scene
    if (scene == "prepare") {
      //point to preadjust kinect hands positions
      leftPtx=gamewidth/3;
      leftPty=gameheight/2;
      rightPtx=gamewidth/3*2;
      rightPty=gameheight/2;

      if (waitTime>120) {
        scene="play";
        waitTime=0;
      }//switch the screen

      jelly.getStrech(shapeControl, new PVector(0, 0));//the testing control function

      pg.loadPixels();
      Arrays.fill(pg.pixels, pg.pixels[0]);
      pg.updatePixels(); 
      pg.beginDraw();
      fill(#75CDB9);  
      pg.textFont(titleFont, 50);
      pg.text("level", gamewidth/2-70, gameheight/2);//show the timer count
      pg.text(level, gamewidth/2+50, gameheight/2);
      pg.endDraw();
      image(pg, 0, 0); 
      noFill();
      // the hand position is in the calibrate position
      if (dist(leftmovex, leftmovey-gameheight/2+jelly.getY(), leftPtx, leftPty)<20 && dist(rightmovex, rightmovey-gameheight/2+jelly.getY(), rightPtx, rightPty)<20) {
        waitTime++;
        pg.loadPixels();
        Arrays.fill(pg.pixels, pg.pixels[0]);
        pg.updatePixels(); 
        pg.beginDraw();
        fill(#75CDB9);  
        pg.textFont(titleFont, 50);
        pg.text(3-waitTime/40, gamewidth/2, gameheight/2);//show the timer count
        pg.endDraw();
        image(pg, 0, 0); 
        fill(#75CDB9);
      }
      //DRAW TARGET POSITIONs
      translate(0, 0, 1);
      ellipse(leftPtx, leftPty, 10, 10);
      ellipse(rightPtx, rightPty, 10, 10);
      translate(0, 0, -1);
    }


    // the play scene
    else if (scene == "play") {
      // PROCEDURL GENERATIVE THE LEVEL
      if (((jelly.getY()-tunnel.toprightY <gameheight )|| (jelly.getY()-tunnel.topleftY<gameheight))) {
        tunnel.generate(noise(tunnel.topleftY/(3*gamewidth)), noise(tunnel.toprightY/(3*gamewidth)), random(0, 1), random(0, 1), world);
        //at the same time add an enemy
        if (random(0, 1)>0.1*level) {//the probability to generate a new enemy related to level
          float jellysize = gamewidth/20;
          float positionX = random(tunnel.topleftX+jellysize, tunnel.toprightX-jellysize);
          float positionY = random(tunnel.topleftY, tunnel.toprightY);
          Enemy newEnemy =  new Enemy (jellysize, positionX, positionY);
          enemies.add(newEnemy);
          world.add(newEnemy);
        }
      }
      //the control function
      jelly.getStrech(shapeControl, moveControl);
      if (jelly.getPressure()> 40) {
        jelly.explode = true; 
        explode.trigger();
        scene ="end";
      }//explode and switch to ending
      if (jelly.getY()<-gameheight*21) {
        level++;
        gravity+=1;
        initiate();
      }//next level
    }


    // the ending scene
    else if (scene=="end") {
      explodeAnime();
    }
  }
}


void initiate() {
  Fisica.init(this);//initiate the fisica
  world = new FWorld(-gamewidth, -1000*gameheight, 2*gamewidth, 2*gameheight);
  jellysize =jellysize+1;
  jelly = new Jelly(jellysize, gamewidth/2, gameheight/2);
  jelly.setDamping(0);
  jelly.explode = false;
  tunnel = new Tunnel(gamewidth, gameheight, world);
  world.setGravity(0, gravity);
  world.add(jelly);
  enemies = new ArrayList<Enemy>();
  scene = "prepare";
  hit = false;
}


void explodeAnime() {
  if (waitTime>40) {
    endingText();
  }// show gameove text
  if (jelly.explode) {
    waitTime++;
  }
}


void endingText() {
  background (#424242);
  fill(#75CDB9);  
  textFont(titleFont, 50*scale);
  text("GAME OVER", (width/2)-190*scale, (height/2 -150*scale));

  fill(#F7B84B);
  textFont(bodyFont, int(16*scale));
  text("press space to restart", (width/2)-85*scale, height-30*scale);
  if (spaceHit) {
    initiate();
    scene = "prepare";
    spaceHit = false;
  }  
}

// collision function
void contactStarted(FContact c) {
  FBody star = null;
  FBody wall = null;
  for (Enemy someOne:enemies) {
    if (someOne.getVertexBodies().contains(c.getBody2()) && jelly.getVertexBodies().contains (c.getBody1()))
    {star = someOne;}
    else if (someOne.getVertexBodies().contains(c.getBody1()) && jelly.getVertexBodies().contains (c.getBody2()))
    {star = someOne;}
  }
  if (star == null) {
    if (jelly.getVertexBodies().contains (c.getBody2()) ||jelly.getVertexBodies().contains (c.getBody1())) {
      if (hit ==false) {
        bump.trigger();
        hit = true;
      }
    }
    return;// NOT EAT
  }
  jelly.growUp();//PUNISHMENT
  eat.trigger();
  world.remove(star);
  enemies.remove(star);
}


void contactEnded(FContact c) {
  if ((jelly.getVertexBodies().contains (c.getBody2()) ||jelly.getVertexBodies().contains (c.getBody1()))) {
    hit = false;
  }
}

void keyPressed() {
  if (key == ' ') {
    spaceHit = true;
  }
}

// update kinect
void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

