class Jelly extends FBlob{//Jelly extends from FBlob 

  float size;
  int ptnumber = 20;
  float xpos;
  float ypos;
  float[] xp;
  float[] yp;
  RPoint[] points;
  RPolygon polygon;
  RPolygon eye;
  float col;
  boolean explode =false;
  color myColor;
  boolean eat;

  Jelly(float s,float x,float y){
    super();
    xpos = x;
    ypos = y;
    size = s;
    this.setAsCircle(xpos,ypos,size,ptnumber);
    xp = new float[ptnumber];
    yp = new float[ptnumber];
    points = new RPoint[ptnumber];
    col = 255; 
    myColor = color(#beed6c);
    eat = false;
   }
  
  void updatePointsAndRect(){
    for (int i = 0; i<ptnumber;i++){
      RPoint pointT = new RPoint(((FBody)getVertexBodies().get(i)).getX(),((FBody)getVertexBodies().get(i)).getY());
      points[i]=pointT;
      xp[i]=pointT.x;
      yp[i]=pointT.y;
    }
    polygon=new RPolygon(points);
    eye = RPolygon.createRing(getX(),getY()-15,5,10);
    return;
  }
          
  void updateColor(){
     col = map(jelly.getPressure(),10,21,0,255);
   }
  
  
  //CENTER POSITION 
  float getY(){
    float sum = 0;
    for(int i=0;i<ptnumber;i++){
      sum += ((FBody)getVertexBodies().get(i)).getY();
    }  
    return (sum/ptnumber); 
  }
        
  float getX(){
    float sum = 0;
    for(int i=0;i<ptnumber;i++){
      sum += ((FBody)getVertexBodies().get(i)).getX();        
     }  
    return (sum/ptnumber);
  }
                        
  float getPressure(){
    float sum = 0;
    for(int i=0;i<ptnumber;i++){
      sum +=sqrt(sq(((FBody)getVertexBodies().get(i)).getX()-this.getX())+sq(((FBody)getVertexBodies().get(i)).getY()-this.getY()));
    }
    return (sum/ptnumber); 
  }
  
  void growUp(){
    float x = getX();
    float y = getY();
    for (int i=0;i<ptnumber;i++){
      float distance=((FBody)getVertexBodies().get(i)).getX()-this.getX();
      float force = distance*100;
      ((FBody)getVertexBodies().get(i)).addForce(force,0);
    }
  }
  
  
  //CONTROLLER      
  void getStrech(PVector hands,PVector handscenter){
    float mag = hands.mag();
    super.addForce(handscenter.x/10,handscenter.y/10);
    hands.normalize();
    float a = hands.x;
    float b = hands.y;
    float x0=this.getX() ;
    float y0=this.getY();
    for (int i=0;i<ptnumber;i++){
      float xp = ((FBody)getVertexBodies().get(i)).getX();
      float yp = ((FBody)getVertexBodies().get(i)).getY();
      float x1 = (a*b*(y0-yp)+a*a*(x0-xp))/(a*a+b*b+1);
      float y1 = (b*b*(y0-yp)+a*b*(x0-xp))/(a*a+b*b+1);
      ((FBody)getVertexBodies().get(i)).addForce((gamewidth/3-mag)*x1/2,(gameheight/3-mag)*y1/2);
    }  
  }  
  
  void drawExplode(PGraphics applet){
    for (int i = 0;i<=ptnumber;i+=3){
      applet.ellipseMode(CENTER);
      float r = 3000/dist(xp[i],yp[i],this.getX(),this.getY());
      applet.ellipse(xp[i],yp[i],r,r);
      xp[i] = this.getX()+(xp[i]-this.getX())*1.1;
      yp[i] = this.getY()+(yp[i]-this.getY())*1.1;  
    }
  }
  
  void draw(PGraphics applet) {
      applet.fill(this.myColor);
      if (explode==false){
      drawMonster(applet);
      super.setNoStroke();
      super.setNoFill();}
      else{this.drawExplode(applet);}
    }
    
    void drawMonster(PGraphics applet){
      updateColor();
      updatePointsAndRect();
      applet.stroke(#b0e94c);
      applet.strokeWeight(20);
      
      applet.fill(this.myColor);
      PVector center = new PVector(getX(),getY());
      PVector pE = PVector.lerp(new PVector(points[18].x,points[16].y),center,0.7);
      PVector p0 = PVector.lerp(new PVector(points[12].x,points[12].y), center, 1.0/8);
      PVector p1 = PVector.lerp(new PVector(points[11].x,points[11].y), center, 1.0/8);
      PVector p2 = PVector.lerp(new PVector(points[10].x,points[10].y), center, 2.0/8);
      PVector p3 = PVector.lerp(new PVector(points[9].x,points[9].y), center, 3.0/8);
      PVector p4 = PVector.lerp(new PVector(points[10].x,points[10].y),center, 4.0/8);
      PVector p5 = PVector.lerp(new PVector(points[11].x,points[11].y), center, 4.0/8);
      PVector p6 = PVector.lerp(new PVector(points[12].x,points[12].y), center, 4.0/8);
      PVector p7 = PVector.lerp(new PVector(points[13].x,points[13].y), center, 4.0/8);
      PVector p8 = PVector.lerp(new PVector(points[14].x,points[14].y), center, 3.0/8);
      PVector p9 = PVector.lerp(new PVector(points[15].x,points[15].y), center, 2.0/8);
      PVector p10 = PVector.lerp(new PVector(points[16].x,points[16].y), center, 1.0/8);
       float rE = PVector.dist(pE,p9);
      int number = 11;
      PVector[] pts={p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10};
      
      applet.beginShape();
      textFont(bodyFont,12);
      for (int i=0;i<ptnumber-6;i++){applet.vertex(points[i].x, points[i].y);}
      for (int i=0;i<number;i++){applet.vertex(pts[i].x,pts[i].y);}
      for (int i=ptnumber-3;i<ptnumber;i++){applet.vertex(points[i].x, points[i].y);}
      applet.vertex(points[0].x,points[0].y);
      applet.endShape();
      
      PVector up = PVector.sub(center, new PVector(points[0].x,points[0].y));
      float angle = PI-PVector.angleBetween(up, new PVector(0,1));
      applet.fill(#7fb05b);
      applet.strokeWeight(5);
      applet.ellipse(pE.x,pE.y,rE,rE);
      applet.translate(pE.x, pE.y);
      applet.rotateZ(angle);
      applet.stroke(#4d854f);
      applet.fill(#3c5f3e);
      applet.ellipse(0,0,rE,6);
      applet.fill(this.myColor);
      applet.noStroke();
      applet.ellipse(-rE/2.0+2,0,2,2);
      applet.rotateZ(-angle);
      applet.translate(-pE.x, -pE.y);
      
      PVector dot1 = PVector.lerp(new PVector(points[19].x,points[19].y), center, 3.0/8);
      PVector dot2 = PVector.lerp(new PVector(points[1].x,points[1].y), center, 2.0/8);
      PVector dot3 = PVector.lerp(new PVector(points[4].x,points[4].y), center, 3.0/8);
      PVector dot4 = PVector.lerp(new PVector(points[6].x,points[6].y), center, 3.0/8);
      PVector dot5 = PVector.lerp(new PVector(points[8].x,points[8].y), center, 3.0/8);
      applet.stroke(#7fb05b);
      applet.fill(#3c5f3e);
      applet.strokeWeight(0);
      applet.ellipse(dot1.x,dot1.y,2,2);
      applet.strokeWeight(7);
      applet.ellipse(dot2.x,dot2.y,8,8);
      applet.strokeWeight(3);
      applet.ellipse(dot3.x,dot3.y,4,4);
      applet.strokeWeight(15);
      applet.ellipse(dot4.x,dot4.y,10,10);
      applet.strokeWeight(2);
      applet.ellipse(dot5.x,dot5.y,3,3);
    }
  }
  
  
  class Bubble{
      PVector loc;
      float   speed;
      float   radius;
       
      Bubble(){
          loc = new PVector( random(width), random(height) );
          speed = random(0.5, 2);
          radius = random( 5, 20 );
      }
       
      void update(){
          loc.y -= speed;
      }
       
      void drawBubs(){
          fill(#f7b84b,130);
          noStroke();
          for (int i = 1; i < 3; i++) {
              ellipse( loc.x, loc.y, i*radius*2-7, i*radius*2-7 );
          }
      }
       
      void reset(){
          loc.x = random(width);
          loc.y = height + 50;
          speed = random(0.5, 2);
          radius = random( 5*scale, 10*scale );
      }
       
  }
