//Asteroids sound gen 2!!
import java.util.Iterator;

ArrayList<Obs> objects;
PlayerObject player;
boolean newGame;
boolean playingGame;

//movement booleans
boolean a;
boolean s;
boolean d;
boolean w;
boolean mouseheld;

int gunclock;

void setup(){
 size(500, 500); 
 newGame = true;
 playingGame = false;
 gunclock = 0;
 
}

void tick(){
  
  if(mouseheld && gunclock%10 == 0){
     BulletObject k = new BulletObject(player.x, player.y, 5, player.rotation);
     objects.add(k); 
     gunclock = 0;
   }
   gunclock++;
  //collision calling
  for(int i = 0; i < objects.size(); i++){
   Obs temp1 = objects.get(i);
   for(int i2 = i+1; i2<objects.size(); i2++){
    Obs temp2 = objects.get(i2);
    if(Math.pow(temp1.x-temp2.x, 2)+Math.pow(temp1.y-temp2.y, 2) < Math.pow(temp1.radius+temp2.radius, 2)){
     temp1.collision(temp2);
     temp2.collision(temp1);
    }
   }  
  }
  
  
  //Checks removal, and update
 Iterator<Obs> iter = objects.iterator();
 while (iter.hasNext()){
  Obs looking = iter.next();
   if(looking.toremove){
    iter.remove();
   }
  looking.update(); 
 }
}

void draw(){
  //repaint background as black
  background(0);
  
  //checks new game boolean (for restart and stuff)
  if(newGame){
    newGame = false;
    playingGame = true;
    objects = new ArrayList<Obs>();
    player = new PlayerObject(width/2, height/2, 1.0, 0.0);
    objects.add(player);
    
  }else if(playingGame){
    //tick
    tick();
    
    //drawing
    for(Obs obj : objects){
      obj.display();
    }
  }
}

void keyPressed(){
 if(key == 'a'){
  a = true;
 } 
 if(key == 's'){
  s = true; 
 }
 if(key == 'd'){
  d = true; 
 }
 if(key == 'w'){
  w = true; 
 }
 
 //Testing keys
 if(key == 'v'){
  AsteroidObject asteroid = new AsteroidObject(width/2, height/2, 1, 0, .1, 10);
  objects.add(asteroid);
 }
}
void keyReleased(){
 if(key == 'a'){
  a = false;
 } 
 if(key == 's'){
  s = false; 
 }
 if(key == 'd'){
  d = false; 
 }
 if(key == 'w'){
  w = false; 
 } 
}

void mousePressed(){
 mouseheld = true;
 gunclock = 0;
}
void mouseReleased(){
 mouseheld = false; 
}

//Seperate Classes

abstract class Obs{
  float x;
  float xacc;
  float y;
  float yacc;
  float speed;
  float rotation;
  float radius;
  boolean toremove;
  void display(){}
  void update(){}
  void collision(Obs a){}
}

class AsteroidObject extends Obs{
  float rotospeed;
  float initrot;
  AsteroidObject(float a, float b, float sp,float r, float rspeed, float rad){
   this.x = a;
   this.y = b;
   this.speed = sp;
   this.rotation = r;
   this.initrot = r;
   this.rotospeed = rspeed; 
   this.radius = rad;
   this.toremove = false;
  }
  void update(){
   this.x+=Math.cos(initrot)*speed;
   this.y+=Math.sin(initrot)*speed;
   
   if(this.x < 0.0f){
     this.x+=width; 
    }
    if(this.y < 0.0f){
     this.y+=height; 
    }
    this.y%=height;
    this.x%=width;
   rotation+=rotospeed;
  }
  void display(){
   pushMatrix();
    translate(this.x, this.y);
    rotate(this.rotation);
    stroke(255);
    ellipse(0,0,2*radius,2*radius);
   popMatrix(); 
  }
  void collision(Obs a){
    if(a instanceof BulletObject){
     this.toremove = true; 
    }
  }
}
class BulletObject extends Obs{
 BulletObject(float a, float b, float sp, float r){
  this.x = a;
  this.radius = 2;
  this.y = b;
  this.speed = sp;
  this.rotation = r;
  toremove = false;
 } 
 void update(){
   this.x+=Math.cos(rotation)*speed;
   this.y+=Math.sin(rotation)*speed;
   
   if(this.x < 0.0f){
     toremove = true;
   }
   if(this.y < 0.0f){
     toremove = true;
   }
   if(this.x > width){
     toremove = true;
   }
   if(this.y > height){
     toremove = true;
   }
 }
 void display(){
   pushMatrix();
    translate(this.x, this.y);
    rotate(this.rotation);
    stroke(255);
    ellipse(0,0,2,2);
    popMatrix();
 }
 void collision(Obs a){
   if(a instanceof AsteroidObject){
     this.toremove = true;
   }
 }
}

class PlayerObject extends Obs{
  float ACCELERATION = .09;
  
  PlayerObject(float a, float b, float sp, float r){
   this.x = a;
   this.y = b;
   this.speed = sp;
   this.rotation = r; 
   this.radius = 6;
  }
  void update(){
    //move function
    move();
    //if over the edge of map
    if(this.x < 0.0f){
     this.x+=width; 
    }
    if(this.y < 0.0f){
     this.y+=height; 
    }
    this.y%=height;
    this.x%=width;
    //mouse pointing
    if(mouseX - this.x > 0){
      rotation =(float) Math.atan(( mouseY-this.y)/(( mouseX- this.x)));
    }else{
      rotation =(float) (Math.atan((( mouseY-this.y)/( mouseX- this.x)))+Math.PI );
    }if(mouseX-this.x == 0){
      if(mouseY - this.y >0){
       rotation = (float)Math.PI/2;
      } else{
       rotation =(float) -Math.PI/2; 
      }
    }
    //acceleration
    x+=xacc;
    y+=yacc;
    
    
  }
  void move(){
     //adds player accerleration
    if(a){
     this.xacc-=ACCELERATION;
    }
    if(s){
     this.yacc+=ACCELERATION; 
    }
    if(d){
     this.xacc+=ACCELERATION;
    }
    if(w){
     this.yacc-=ACCELERATION;
    }
    //decerleration
    this.yacc*=.990;
    this.xacc*=.990;
  }
  void display(){
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.rotation);
    stroke(255);
    if(mousePressed){
     stroke(230, 100, 100); 
    }
    line(-10, -8, 10, 0);
    line(-10, 8, 10, 0);
    line(-6, -6, -6, 6);
    popMatrix();
  }
}
