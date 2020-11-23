// ---------------- Initialisation ----------------
byte display_dir;
float[] display_origin = new float[3];
byte display_screenshotCnt;



// ---------------- Functions ----------------
boolean[] isLinked(byte b, byte id, byte dir, byte x, byte y, byte z){
    //front element  : boxes[b][z][y][x-1]
    //back element   : boxes[b][z][y][x+1]
    //left element   : boxes[b][z+1][y][x]
    //right element  : boxes[b][z-1][y][x]
    //bottom element : boxes[b][z][y+1][x]
    //top element    : boxes[b][z][y-1][x]
    byte i,d;
    boolean[] result = {false,false,false,
                        false,false,false};
    if(id != 0){
        
        //get the links of a wire element
        if(id == 1){
            if(z != 15){ //left
                i = getID(boxes[b][z+1][y][x]);
                d = getDir(boxes[b][z+1][y][x]);
                if(i != 0){
                    if(i > 7 && i < 15) //other element is a box
                        result[2] = true;
                    else if(i == 1 || d == 2 || d == 3)
                        result[2] = true;
                }
            }
            if(z != 0){ //right
                i = getID(boxes[b][z-1][y][x]);
                d = getDir(boxes[b][z-1][y][x]);
                if(i != 0){
                    if(i > 7 && i < 15) //other element is a box
                        result[3] = true;
                    else if(i == 1 || d == 2 || d == 3)
                        result[3] = true;
                }
            }
            if(x != 0){ //front
                i = getID(boxes[b][z][y][x-1]);
                d = getDir(boxes[b][z][y][x-1]);
                if(i != 0){
                    if(i > 7 && i < 15) //other element is a box
                        result[0] = true;
                    else if(i == 1 || d == 0 || d == 1)
                        result[0] = true;
                }
            }
            if(x != 15){ //back
                i = getID(boxes[b][z][y][x+1]);
                d = getDir(boxes[b][z][y][x+1]);
                if(i != 0){
                    if(i > 7 && i < 15) //other element is a box
                        result[1] = true;
                    else if(i == 1 || d == 0 || d == 1)
                        result[1] = true;
                }
            }
            if(y != 0){ //bottom
                i = getID(boxes[b][z][y-1][x]);
                d = getDir(boxes[b][z][y-1][x]);
                if(i != 0){
                    if(i > 7 && i < 15) //other element is a box
                        result[5] = true;
                    else if(i == 1 || d == 4 || d == 5)
                        result[5] = true;
                }
            }
            if(y != 15){ //top
                i = getID(boxes[b][z][y+1][x]);
                d = getDir(boxes[b][z][y+1][x]);
                if(i != 0){
                    if(i > 7 && i < 15) //other element is a box
                        result[4] = true;
                    else if(i == 1 || d == 4 || d == 5)
                        result[4] = true;
                }
            }
        }
        
        //get the links of a not-wire element
        else{
            switch(dir){
                case 0: //front
                case 1: //back
                    if(x != 0){ //front
                        i = getID(boxes[b][z][y][x-1]);
                        d = getDir(boxes[b][z][y][x-1]);
                        if(i != 0){
                            if(id == 2 && i > 7 && i < 15) //inverter into box
                                result[0] = true;
                            else if(i == 1 || d == 0 || d == 1)
                                result[0] = true;
                        }
                    }
                    if(x != 15){ //back
                        i = getID(boxes[b][z][y][x+1]);
                        d = getDir(boxes[b][z][y][x+1]);
                        if(i != 0){
                            if(id == 2 && i > 7 && i < 15) //inverter into box
                                result[1] = true;
                            else if(i == 1 || d == 0 || d == 1)
                                result[1] = true;
                        }
                    }
                break;
                case 2: //left
                case 3: //right
                    if(z != 15){ //left
                        i = getID(boxes[b][z+1][y][x]);
                        d = getDir(boxes[b][z+1][y][x]);
                        if(i != 0){
                            if(id == 2 && i > 7 && i < 15) //inverter into box
                                result[2] = true;
                            else if(i == 1 || d == 2 || d == 3)
                                result[2] = true;
                        }
                    }
                    if(z != 0){ //right
                        i = getID(boxes[b][z-1][y][x]);
                        d = getDir(boxes[b][z-1][y][x]);
                        if(i != 0){
                            if(id == 2 && i > 7 && i < 15) //inverter into box
                                result[3] = true;
                            else if(i == 1 || d == 2 || d == 3)
                                result[3] = true;
                        }
                    }
                break;
                case 4: //top
                case 5: //bottom
                    if(y != 0){ //bottom
                        i = getID(boxes[b][z][y-1][x]);
                        d = getDir(boxes[b][z][y-1][x]);
                        if(i != 0){
                            if(id == 2 && i > 7 && i < 15) //inverter into box
                                result[5] = true;
                            else if(i == 1 || d == 4 || d == 5)
                                result[5] = true;
                        }
                    }
                    if(y != 15){ //top
                        i = getID(boxes[b][z][y+1][x]);
                        d = getDir(boxes[b][z][y+1][x]);
                        if(i != 0){
                            if(id == 2 && i > 7 && i < 15) //inverter into box
                                result[4] = true;
                            else if(i == 1 || d == 4 || d == 5)
                                result[4] = true;
                        }
                    }
                break;
            }
        }
    }
    return result;
}

void vertexDir(float x, float y, float z, float u, float v){
    switch(display_dir){
        case 0: //front
            vertex(
                display_origin[0] + x,
                display_origin[1] + y,
                display_origin[2] + z,
            u,v);
        break;
        case 1: //back
            vertex(
                display_origin[0] + bs-x,
                display_origin[1] + y,
                display_origin[2] + bs-z,
            u,v);
        break;
        case 2: //left
            vertex(
                display_origin[0] + z,
                display_origin[1] + y,
                display_origin[2] + bs-x,
            u,v);
        break;
        case 3: //right
            vertex(
                display_origin[0] + bs-z,
                display_origin[1] + y,
                display_origin[2] + x,
            u,v);
        break;
        case 4: //top
            vertex(
                display_origin[0] + z,
                display_origin[1] + bs-x,
                display_origin[2] + bs-y,
            u,v);
        break;
        case 5: //bottom
            vertex(
                display_origin[0] + z,
                display_origin[1] + x,
                display_origin[2] + y,
            u,v);
        break;
    }
}
void create_cube(float mx, float Mx,
          float my, float My,
          float mz, float Mz,
          PImage front, PImage back,
          PImage left,  PImage right,
          PImage top,   PImage bottom){
    Mx -= mx; My -= my; Mz -= mz;
    mx *= bs; my *= bs; mz *= bs;
    Mx *= bs; My *= bs; Mz *= bs;
    display_origin[0] = mx;
    display_origin[1] = my;
    display_origin[2] = mz;
    //front face
    beginShape(QUADS);
    texture(front);
    vertexDir( 0,  0, Mz, 0,0);
    vertexDir(Mx,  0, Mz, 1,0);
    vertexDir(Mx, My, Mz, 1,1);
    vertexDir( 0, My, Mz, 0,1);
    endShape();
    //back face
    beginShape(QUADS);
    texture(back);
    vertexDir(Mx,  0,  0, 0,0);
    vertexDir( 0,  0,  0, 1,0);
    vertexDir( 0, My,  0, 1,1);
    vertexDir(Mx, My,  0, 0,1);
    endShape();
    //left face
    beginShape(QUADS);
    texture(left);
    vertexDir( 0,  0,  0, 0,0);
    vertexDir( 0,  0, Mz, 1,0);
    vertexDir( 0, My, Mz, 1,1);
    vertexDir( 0, My,  0, 0,1);
    endShape();
    //right face
    beginShape(QUADS);
    texture(right);
    vertexDir(Mx,  0, Mz, 0,0);
    vertexDir(Mx,  0,  0, 1,0);
    vertexDir(Mx, My,  0, 1,1);
    vertexDir(Mx, My, Mz, 0,1);
    endShape();
    //top face
    beginShape(QUADS);
    texture(top);
    vertexDir( 0,  0,  0, 0,0);
    vertexDir(Mx,  0,  0, 1,0);
    vertexDir(Mx,  0, Mz, 1,1);
    vertexDir( 0,  0, Mz, 0,1);
    endShape();
    //bottom face
    beginShape(QUADS);
    texture(bottom);
    vertexDir( 0, My, Mz, 0,0);
    vertexDir(Mx, My, Mz, 1,0);
    vertexDir(Mx, My,  0, 1,1);
    vertexDir( 0, My,  0, 0,1);
    endShape();
}

void create_sphere(float x, float y, float z,
                   float r, PImage all){
    noStroke();
    translate(x*bs,y*bs,z*bs);
    PShape s = createShape(SPHERE, r*bs/2);
    s.setTexture(all);
    shape(s);
    stroke(0);
    translate(-x*bs,-y*bs,-z*bs);
}

void create_tube(float x, float y, float z,
                 float r, float ml, float Ml,
                 PImage startDisk, PImage endDisk,
                 PImage lathed){
    x *= bs; y *= bs; z *= bs;
    r *= bs; ml *= bs; Ml *= bs;
    display_origin[0] = x;
    display_origin[1] = y;
    display_origin[2] = z;
    noStroke();
    //startDisk
    beginShape(TRIANGLE);
    texture(startDisk);
    for(float a=0; a < PImul2; a += 0.5){
        vertexDir(
            ml,
            bs/2 + r*cos(a),
            bs/2 + r*sin(a),
        0,0);
        vertexDir(
            ml,
            bs/2 + r*cos(a+0.5),
            bs/2 + r*sin(a+0.5),
        1,0);
        vertexDir(ml, bs/2, bs/2, 0,1);
    }
    endShape();
    //endDisk
    beginShape(TRIANGLE);
    texture(endDisk);
    for(float a=0; a < PImul2; a += 0.5){
        vertexDir(
            Ml,
            bs/2 + r*cos(a),
            bs/2 + r*sin(a),
        0,0);
        vertexDir(
            Ml,
            bs/2 + r*cos(a+0.5),
            bs/2 + r*sin(a+0.5),
        1,0);
        vertexDir(Ml, bs/2, bs/2, 0,1);
    }
    endShape();
    //lathed surface
    beginShape(QUADS);
    texture(lathed);
    for(float a=0; a < PImul2-0.5; a += 0.5){
        vertexDir(
            ml,
            bs/2 + r*cos(a),
            bs/2 + r*sin(a),
        0,0);
        vertexDir(
            Ml,
            bs/2 + r*cos(a),
            bs/2 + r*sin(a),
        0,0);
        vertexDir(
            Ml,
            bs/2 + r*cos(a+0.5),
            bs/2 + r*sin(a+0.5),
        1,0);
        vertexDir(
            ml,
            bs/2 + r*cos(a+0.5),
            bs/2 + r*sin(a+0.5),
        1,1);
    }
    endShape();
    stroke(0);
}

void create_cone(float x, float y, float z,
                 float r, float ml, float Ml,
                 PImage startDisk, PImage lathed){
    x *= bs; y *= bs; z *= bs;
    r *= bs; ml *= bs; Ml *= bs;
    display_origin[0] = x;
    display_origin[1] = y;
    display_origin[2] = z;
    noStroke();
    //startDisk
    beginShape(TRIANGLE);
    texture(startDisk);
    for(float a=0; a < PImul2; a += 0.5){
        vertexDir(
            ml,
            bs/2 + r*cos(a),
            bs/2 + r*sin(a),
        0,0);
        vertexDir(
            ml,
            bs/2 + r*cos(a+0.5),
            bs/2 + r*sin(a+0.5),
        1,0);
        vertexDir(ml, bs/2, bs/2, 0,1);
    }
    endShape();
    //lathed surface
    beginShape(TRIANGLE);
    texture(lathed);
    for(float a=0; a < PImul2-0.5; a += 0.5){
        vertexDir(
            ml,
            bs/2 + r*cos(a),
            bs/2 + r*sin(a),
        0,0);
        vertexDir(
            Ml,
            bs/2,
            bs/2,
        0,1);
        vertexDir(
            ml,
            bs/2 + r*cos(a+0.5),
            bs/2 + r*sin(a+0.5),
        1,0);
    }
    endShape();
    stroke(0);
}

void wireConnector(byte x, byte y, byte z, byte dir, byte state){
    display_dir = dir;
    create_tube(
        x, y, z,
        0.08, 0, 0.5,
        img_wire[state], img_wire[state],
        img_wire[state]
    );
}

void drawObject(byte id, byte dir, byte x, byte y, byte z, byte state){
    display_dir = dir;
    boolean[] links = new boolean[6];
    switch(id){
        case 1: //wire
            create_sphere(
                x+0.5, y+0.5, z+0.5,
                0.167, img_wire[state]
            );
            links = isLinked(
                boxSel,id, dir,
                (byte)(x+8),
                (byte)(y+8),
                (byte)(z+8)
            );
            for(byte a=0; a < 6; a++)
                if(links[a])
                    wireConnector(x,y,z,a,state);
        break;
        case 2: //inverter
            create_tube(
                x, y, z,
                0.08, 0, 0.4,
                img_wire[state], img_wire[state],
                img_wire[state]
            );
            create_cone(
                x, y, z,
                0.3, 0.41, 0.7,
                img_inverter[state],
                img_inverter[state]
            );
            if(state == 0)
                state = 1;
            else
                state = 0;
            create_tube(
                x, y, z,
                0.08, 0.6, 1,
                img_wire[state], img_wire[state],
                img_wire[state]
            );
        break;
        case 3: //button
            create_tube(
                x, y, z,
                0.08, 0, 0.4,
                img_wire[state], img_wire[state],
                img_wire[state]
            );
            create_tube(
                x, y, z,
                0.08, 0.6, 1,
                img_wire[state], img_wire[state],
                img_wire[state]
            );
            create_cube( //base of button
                x+0.333,x+0.667,
                y+0.35,y+0.4,
                z+0.4,z+0.6,
                img_button[state], img_button[state],
                img_button[state], img_button[state],
                img_button[state], img_button[state]
            );
            create_cube(
                x+0.45,x+0.55,
                y+0.3,y+0.35,
                z+0.45,z+0.55,
                img_button[state], img_button[state],
                img_button[state], img_button[state],
                img_button[state], img_button[state]
            );
            create_cube( //top of button
                x+0.42,x+0.58,
                y+0.28,y+0.3,
                z+0.42,z+0.58,
                img_button[state], img_button[state],
                img_button[state], img_button[state],
                img_button[state], img_button[state]
            );
        break;
        case 4: //switch
            create_tube(
                x, y, z,
                0.08, 0, 0.4,
                img_wire[state], img_wire[state],
                img_wire[state]
            );
            create_tube(
                x, y, z,
                0.08, 0.6, 1,
                img_wire[state], img_wire[state],
                img_wire[state]
            );
            create_cube(
                x+0.333,x+0.667,
                y+0.35,y+0.4,
                z+0.4,z+0.6,
                img_switch[state], img_switch[state],
                img_switch[state], img_switch[state],
                img_switch[state], img_switch[state]
            );
        break;
        case 5: //lamp
            create_tube(
                x, y, z,
                0.08, 0, 0.1,
                img_wire[state], img_wire[state],
                img_wire[state]
            );
            create_tube(
                x, y, z,
                0.08, 0.9, 1,
                img_wire[state], img_wire[state],
                img_wire[state]
            );
            create_sphere(
                x+0.5, y+0.5, z+0.5,
                0.95, img_lamp[state]
            );
        break;
        case 6: //tool5
        break;
        case 7: //tool6
        break;
        case 8:  //box1
        case 9:  //box2
        case 10: //box3
        case 11: //box4
        case 12: //box5
        case 13: //box6
        case 14: //box7
            create_cube(
                x,x+1, y,y+1, z,z+1,
                img_box[id-8][0], img_box[id-8][1],
                img_box[id-8][2], img_box[id-8][3],
                img_box[id-8][4], img_box[id-8][5]
            );
        break;
    }
}



//---------------- Execution ----------------
void display(){
    switch(menu){
        case START:
        
            //2D (user interface)
            cam.beginHUD();
            
            //mouse on play button
            if(mouseY > 435 && mouseY < 480)
                if(mouseX > 420 && mouseX < 715)
                    image(img_startMenu[1],0,0); //play
                else
                    image(img_startMenu[0],0,0); //neutral
            
            //mouse on exit button
            else if(mouseY > 565 && mouseY < 605)
                if(mouseX > 525 && mouseX < 825)
                    image(img_startMenu[2],0,0); //exit
                else
                    image(img_startMenu[0],0,0); //neutral
            else
                image(img_startMenu[0],0,0); //neutral
            
            //sound switch
            if(snd_on)
                image(img_sound[1],920,565);
            else
                image(img_sound[0],920,565);
            cam.endHUD();
            
        break;
        case GAME:
        
            //3D start building
            background(0);
            cam.rotateY(-playerAngleY);
            cam.rotateX(-playerAngleX);
            translate(-playerPos[0], -playerPos[1], -playerPos[2]);
            
            //elements
            create_cube( //biggest box
                -8,8, -8,8, -8,8,
                img_scene, img_scene,
                img_scene, img_scene,
                img_scene, img_scene
            );
            for(byte z=0; z < 16; z++)
                for(byte y=0; y < 16; y++)
                    for(byte x=0; x < 16; x++)
                        drawObject(
                            getID( boxes[boxSel][z][y][x]),
                            getDir(boxes[boxSel][z][y][x]),
                            (byte)(x-8),
                            (byte)(y-8),
                            (byte)(z-8),
                            byteCast(elec_signals[boxSel][z][y][x])
                        );
            
            //selection cube
            create_cube(
                selCube[0], selCube[0]+1,
                selCube[1], selCube[1]+1,
                selCube[2], selCube[2]+1,
                img_selCube, img_selCube,
                img_selCube, img_selCube,
                img_selCube, img_selCube
            );
            
            //3D end building
            translate(playerPos[0], playerPos[1], playerPos[2]);
            cam.rotateX(playerAngleX);
            cam.rotateY(playerAngleY);
            
            //2D (user interface)
            cam.beginHUD();
            if(display_screenshotCnt > 0){
                //taking screenshot
                background(255,255,255);
                display_screenshotCnt--;
                
            }else{
                //gameUI
                //image(img_gameUI,0,0);
                
                //toolbar and boxbar
                if(toolsSelected){
                    image(img_boxbar[7],0,180);
                    image(img_toolbar[toolbarSel],1200,180);
                    for(int a=0; a < 7; a++){
                        image(img_boxes[a][0], 5, 190+a*46);
                        if(a == toolbarSel)
                            image(img_tools[a][1], 1236, 190+a*46);
                        else
                            image(img_tools[a][0], 1236, 190+a*46);
                    }
                }else{
                    image(img_toolbar[7],1200,180);
                    image(img_boxbar[boxbarSel],0,180);
                    for(int a=0; a < 7; a++){
                        image(img_tools[a][0], 1236, 190+a*46);
                        if(a == boxbarSel)
                            image(img_boxes[a][1], 5, 190+a*46);
                        else
                            image(img_boxes[a][0], 5, 190+a*46);
                    }
                }
                
                //sound icon
                if(snd_on)
                    image(img_sound[1],1240,680);
                else
                    image(img_sound[0],1240,680);
            }
            cam.endHUD();
            
        break;
    }
}
