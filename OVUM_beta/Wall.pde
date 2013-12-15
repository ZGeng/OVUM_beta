class Wall extends FPoly{
  //sidewall of a tunnel
  float topX;
  float topY;
  float middleX;
  float middleY;
  float bottomX;
  float bottomY;
  boolean isLeft;
  float shiftDistBX;//bottomshift
  float shiftDistTX;//topshift
  float shiftDistMX;//middleshift
  float shiftDistBY;
  float shiftDistTY;
  float shiftDistMY;
  float edgeX;
  float shiftD;
  RPolygon polygon;
  
  Wall(float tX,float tY,float mX,float mY,float bX,float bY,float shiftBX,float shiftBY,float shiftMX,float shiftMY,boolean isL,float shift){
     topX = tX;
     topY = tY;
     middleX = mX;
     middleY = mY;
     bottomX = bX;
     bottomY = bY;
     if (isL){edgeX = -gamewidth/3;shiftD=shift;}else{edgeX = 4*gamewidth/3;shiftD = -shift;}
     shiftDistBX = shiftBX;
     shiftDistTX = noise(tX)*shiftD;
     shiftDistMX = shiftMX;
     shiftDistBY = shiftBY;
     shiftDistTY = (noise(tY)-.5)*shiftD;
     shiftDistMY = shiftMY;
     isLeft = isL;
     //setup the properties
     this.vertex(topX,topY);
     this.vertex(middleX,middleY);
     this.vertex(bottomX,bottomY);
     this.vertex(edgeX,bottomY);
     this.vertex(edgeX,middleY);
     this.vertex(edgeX,topY);//setup the value   
     super.setStatic(true);
     setStatic(true);
     setFill(#74B4A6);  
  }
  
  
  
  void draw(PGraphics applet) {
      super.setNoStroke();
      super.draw(applet);
      preDraw(applet);
      applet.fill(#323246);
      applet.noStroke();
      applet.translate(0,0,-200);
      applet.beginShape();
      applet.vertex(topX+shiftDistTX, topY+shiftDistTY);
      applet.vertex(middleX+shiftDistMX,middleY+shiftDistMY);
      applet.vertex(bottomX+shiftDistBX, bottomY+shiftDistBY);
      applet.vertex(edgeX,bottomY);
      applet.vertex(edgeX,middleY);
      applet.vertex(edgeX, topY);
     
      applet.endShape();
      applet.stroke(#FFFFFF);
      applet.strokeWeight(5);
      applet.translate(0,0,200);
      
      line(bottomX,bottomY,middleX,middleY);
      line(middleX,middleY,topX,topY);
      postDraw(applet);
      
    }
     
     
}
