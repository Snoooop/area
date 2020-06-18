int closestPersonIndex=0;
int closestDistance=2000;
int selectedPerson=0;

class alien {
  int x, y, xSpeed, ySpeed, s;
  boolean discovered = false;
}

alien[] aliens=new alien[10];

class agent {
  int x, y, xSpeed, ySpeed, s;
}

agent[] agents=new agent[5];

class people {
  int x, y, xSpeed, ySpeed, s;
  boolean discovered = false;
}

people[] peoples=new people[5];

class safeZone {
  int x, y, xSpeed, ySpeed, s;
}

safeZone[] safeZones=new safeZone[1];

void setup() { 
  fullScreen();
  //frameRate(10);
  newLevel();
}

void draw() {
  background(225);
  moveSafeZone();
  drawArea51();
  moveAgents();
  moveAliens();
  movePeople();
  trackPerson();
  killInteruders();
  discoverAliens();
}

void keyPressed() {
  if (key==CODED) {
    if (keyCode== LEFT) {
      peoples[selectedPerson].xSpeed =-5;
    } else if (keyCode==RIGHT) {
      peoples[selectedPerson].xSpeed = 5;
    } else if (keyCode==UP) {
      peoples[selectedPerson].ySpeed =-5;
    } else if (keyCode==DOWN) {
      peoples[selectedPerson].ySpeed = 5;
    }
  } else {   
    if (key=='0' || key=='1' || key=='2' || key=='3' || key=='4'||key=='5'||key=='6'||key=='7'||key=='8'||key=='9') {
      selectedPerson = key-'0'; //minus the ascii value
      println(selectedPerson);
    }
  }
}

void newLevel() {
  makeAgents();
  makeAliens();
  makePeople();
  makeSafeZone();
}

boolean agentTouchPerson(people p, agent a) {
  if (dist(p.x, p.y, a.x, a.y) < p.s/2+a.s/2) {
    return true;
  } else return false;
}

boolean personTouchAlien(people p, alien a) {
  if (dist(p.x, p.y, a.x, a.y) < p.s/2+a.s/2) {
    return true;
  } else return false;
}



void killInteruders() {
  for (int i=0; i<peoples.length; i=i+1) {
    for (int j=0; j<agents.length; j=j+1) {
      if (agentTouchPerson(peoples[i], agents[j]) == true) {
        peoples[i].discovered=true;
      }
    }
  }
}

void trackPerson() {
  for (int i=0; i<agents.length; i=i+1) {
    closestDistance = 2000;
    closestPersonIndex=0;
    for (int j=0; j<peoples.length; j=j+1) {
      if (inSafeZone(peoples[j].x, peoples[j].y)==false) {
        if ((dist(peoples[j].x, peoples[j].y, agents[i].x, agents[i].y))<closestDistance) {
          closestDistance=int(dist(peoples[j].x, peoples[j].y, agents[i].x, agents[i].y));
          closestPersonIndex=j;
        }
      }
    }
    if (peoples[closestPersonIndex].x < agents[i].x) {
      agents[i].x=agents[i].x-2; 
      println("agent",i,"person",closestPersonIndex,"left");
    }
    if (peoples[closestPersonIndex].x > agents[i].x) {
      agents[i].x=agents[i].x+2;
      println("agent",i,"person",closestPersonIndex,"right");
    }
    if (peoples[closestPersonIndex].y < agents[i].y) {
      agents[i].y=agents[i].y-2;
      println("agent",i,"person",closestPersonIndex,"up");
    }
    if (peoples[closestPersonIndex].y > agents[i].y) {
      agents[i].y=agents[i].y+2;
      println("agent",i,"person",closestPersonIndex,"down");
    }
    text(closestPersonIndex, agents[i].x, agents[i].y+10);
  }
}

void discoverAliens() {
  for (int i=0; i<peoples.length; i=i+1) {
    for (int j=0; j<aliens.length; j=j+1) {
      if (personTouchAlien(peoples[i], aliens[j]) == true) {
        aliens[j].discovered = true;
      }
    }
  }
}

void drawArea51() {
  fill(0);
  rect(width*5/8, 0, width*3/8, height);
  fill(255);
  text("Area51",width*8/10, height/2);
}
