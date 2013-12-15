class Tunnel{
  Wall bottomWall;
  ArrayList<Wall> leftWall;
  ArrayList<Wall> rightWall;
  float sDistance;//the standard distance
  float maxDistance;
  float minDistance;
  float increase;//the standared y distance between
  
  float topleftX;
  float topleftY;
  float toprightX;
  float toprightY;
  float middleleftX;
  float middleleftY;
  float middlerightX;
  float middlerightY;
  float bottomleftX;
  float bottomleftY;
  float bottomrightX;
  float bottomrightY;
  float topshiftLX,middleshiftLX,bottomshiftLX;
  float topshiftRX,middleshiftRX,bottomshiftRX;
  float topshiftLY,middleshiftLY,bottomshiftLY;
  float topshiftRY,middleshiftRY,bottomshiftRY;
  
  Tunnel(float gamewidth,float gameheight,FWorld world){
     sDistance = gamewidth/3;
     maxDistance = gamewidth/2;
     minDistance = gamewidth/5;
     leftWall = new ArrayList<Wall>();
     leftWall.add(new Wall(gamewidth/3,0,gamewidth/3,gameheight,gamewidth/3,gameheight,gamewidth/8,gamewidth/8,gamewidth/8,gamewidth/8,true,gamewidth/8));
  
     rightWall = new ArrayList<Wall>();
     rightWall.add(new Wall(gamewidth/3+sDistance,0,gamewidth/3+sDistance,gameheight,
                                       gamewidth/3+sDistance,gameheight,gamewidth/8,gamewidth/8,gamewidth/8,gamewidth/8,false,gamewidth/8));
     
     bottomWall = new Wall(2*gamewidth,2*gameheight,gamewidth,gameheight,gamewidth,gameheight,0,0,gamewidth/8,gamewidth/8,true,gamewidth/8);      
     world.add(bottomWall);   
     world.add(leftWall.get(0));
     world.add(rightWall.get(0));
     
     increase = gameheight/6;
     topleftY = 0;
     toprightY = 0;
     topleftX = gamewidth/3;
     toprightX = gamewidth/3+sDistance;
     middleleftX = gamewidth/3;
     middlerightX = gamewidth/3+sDistance;
     middleleftY=middlerightY=gameheight/2;
     
     topshiftLX = leftWall.get(0).shiftDistTX;
     middleshiftLX = leftWall.get(0).shiftDistMX;
     bottomshiftLX = leftWall.get(0).shiftDistBX;
    
     topshiftRX =rightWall.get(0).shiftDistTX;
     middleshiftRX = rightWall.get(0).shiftDistMX;
     bottomshiftRX = rightWall.get(0).shiftDistBX;
    
     topshiftLY = leftWall.get(0).shiftDistTY;
     middleshiftLY = leftWall.get(0).shiftDistMY;
     bottomshiftLY = leftWall.get(0).shiftDistBY;
     
     topshiftRY =rightWall.get(0).shiftDistTY;
     middleshiftRY = rightWall.get(0).shiftDistMY;
     bottomshiftRY = rightWall.get(0).shiftDistBY;
  }
  
  //PROCEDURAL GENERATION FUNCTION
  void generate(float r1,float r2,float s1,float s2,FWorld world){//four numbers between 0-1
     float leftX;
     leftX=2*r1*sDistance;
     leftX = constrain(leftX,0,gamewidth/2);//constrain the left wall position
     float leftY;
     leftY = topleftY-increase-s1*increase/6;//move up down 0-1/6
     float tempDistance;
     //the tempdistance 
     tempDistance = 0;
     if (sDistance*r2>maxDistance){tempDistance = maxDistance;}
     else if(sDistance*r2<minDistance){tempDistance = minDistance;}
     else{tempDistance = sDistance*r2;}
     
     float rightX;
     rightX = leftX + tempDistance;
     float rightY;
     rightY = toprightY-increase-s2*increase/6;
     
     //shift the polygon
     bottomleftX=(middleleftX+topleftX)/2;
     bottomleftY=(middleleftY+topleftY)/2;
     bottomrightX=(middlerightX+toprightX)/2;
     bottomrightY=(middlerightY+toprightY)/2;
     
     bottomshiftLX = (middleshiftLX+topshiftLX)/2;
     bottomshiftRX = (middleshiftRX+topshiftRX)/2;
     bottomshiftLY = (middleshiftLY+topshiftLY)/2;
     bottomshiftRY = (middleshiftRY+topshiftRY)/2;
     
     middleleftX=topleftX;
     middleleftY=topleftY;
     middlerightX=toprightX;
     middlerightY=toprightY;
     middleshiftLX = topshiftLX;
     middleshiftRX = topshiftRX;
     middleshiftLY = topshiftLY;
     middleshiftRY= topshiftRY;
     
     topleftX=leftX;
     topleftY=leftY;
     toprightX=rightX;
     toprightY=rightY;
     
     Wall templeft = new Wall(topleftX,topleftY,middleleftX,middleleftY,bottomleftX,bottomleftY,
                                    bottomshiftLX,bottomshiftLY,middleshiftLX,middleshiftLY,true,gamewidth/10); 
     Wall tempright = new Wall(toprightX,toprightY,middlerightX,middlerightY,bottomrightX,bottomrightY,
                                    bottomshiftRX,bottomshiftRY,middleshiftRX,middleshiftRY,false,gamewidth/10);
     
     topshiftLX=templeft.shiftDistTX;
     topshiftLY=templeft.shiftDistTY;
     topshiftRX=tempright.shiftDistTX;
     topshiftRY=tempright.shiftDistTY;
     
     templeft.setPosition(leftWall.get(leftWall.size()-1).getX(),leftWall.get(leftWall.size()-1).getY());
     tempright.setPosition(rightWall.get(rightWall.size()-1).getX(),rightWall.get(rightWall.size()-1).getY());
     
     leftWall.add(templeft);
     rightWall.add(tempright);
     world.add(templeft);
     world.add(tempright);
  }

}
