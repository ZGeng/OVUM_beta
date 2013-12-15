class Enemy extends Jelly{

int ptnumber = 20;
public Enemy(float s,float x,float y) {
    super(s,x,y);
    myColor = color(247,184,75,160);
}
void deform(){
     for (int i=0;i<ptnumber;i+=3){
    float x0=this.getX();
    float y0=this.getY();
    float xp = ((FBody)getVertexBodies().get(i)).getX() ;
    float yp = ((FBody)getVertexBodies().get(i)).getY() ;
    float x = x0-xp;
    float y = y0-yp;
    ((FBody)getVertexBodies().get(i)).addForce(x,y);
  }
}

  void draw(PGraphics applet) {
    applet.fill(this.myColor);
    updatePointsAndRect();
    applet.strokeWeight(2);
    applet.fill(this.myColor);
    applet.beginShape();
    for (int i=0;i<ptnumber;i++){
    applet.vertex(points[i].x, points[i].y);
    }
    applet.vertex(points[0].x,points[0].y);
    applet.endShape();
    super.setNoStroke();
    super.setNoFill();}
}





