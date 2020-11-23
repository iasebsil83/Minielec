// ---------------- Initialisation ----------------
float mouse_wheel;
float mouse_YRef = -1; //void value
float playerAngleX_Ref;
boolean mouse_stopListenningX = false;
boolean mouse_movesCamera = true;



// ---------------- Functions ----------------
void checkInBoxData(){
    byte i;
    for(byte a=0; a < 7; a++){ //for each little box
        //reset inBoxData[a]
        for(byte b=0; b < 7; b++)
            inBoxData[a][b] = false;
        
        //for each element
        for(byte z=0; z < 16; z++){
            for(byte y=0; y < 16; y++){
                for(byte x=0; x < 16; x++){
                    i = getID(boxes[a+1][z][y][x]);
                    if(i > 7 && i < 15) //if this is a box
                        inBoxData[a][i-8] = true;
                }
            }
        }
    }
    println("inBoxData :");
    for(byte a=0; a < 7; a++)
        println(
            inBoxData[a][0] + "," + inBoxData[a][1] + "," + inBoxData[a][2] + "," +
            inBoxData[a][3] + "," + inBoxData[a][4] + "," + inBoxData[a][5] + "," +
            inBoxData[a][6]
        );
}

boolean searchForBox(byte source, byte destination){ //anti-recursion system for boxes
    boolean[] boxFoundAround = new boolean[7];
    for(byte a=0; a < 7; a++)
        if(a != destination){
            if(inBoxData[source][a])
                boxFoundAround[a] = searchForBox(a,destination);
            else
                boxFoundAround[a] = false;
        }
    boxFoundAround[destination] = false;
    boolean otherOk = true;
    for(byte a=0; a < 7; a++)
        if(boxFoundAround[a])
            otherOk = false;
    if(!otherOk)
        return true;
    return inBoxData[source][destination];
}



// ---------------- Execution -----------------
void mouseWheel(MouseEvent e){
    mouse_wheel = e.getCount();
    if(mouse_movesCamera)
        raycast();
}

void mouseMoved(){
    raycast();
}

void mouseEvents(){
    switch(menu){
        case START:
            if(mousePressed && mouseButton == LEFT){
                
                //play button
                if(mouseY > 435 && mouseY < 480){
                    if(mouseX > 420 && mouseX < 715){
                        menu = menu_names.GAME;
                        noCursor();
                        r0t.mouseMove(width_2,height_2);
                        for(byte a=0; a < 3; a++)
                            playerPos[a] = 0;
                        playerAngleX = 0;
                        playerAngleY = 0;
                        soundCheck();
                        delay(1000);
                    }
                
                //mouse on exit button
                }else if(mouseY > 565 && mouseY < 605){
                    if(mouseX > 525 && mouseX < 825)
                        exit();
                    else if(mouseX > 920 && mouseX < 960){ //sound switch
                        snd_on = !snd_on;
                        soundCheck();
                        delay(100);
                    }
                }
            }
        break;
        case GAME:
        
            //toggle mouse action (camera or tools)
            if(mousePressed && mouseButton == RIGHT){
                if(mouse_movesCamera){
                    switch(mouse_tool){
                        case PLACE:
                            cursor(img_mouse[1]); //place
                        break;
                        case BREAK:
                            cursor(img_mouse[2]); //break
                        break;
                        case ROTATE:
                            cursor(img_mouse[3]); //rotate
                        break;
                        case INBOX:
                            cursor(img_mouse[4]); //inbox
                        break;
                        case OUTBOX:
                            cursor(img_mouse[5]); //outbox
                        break;
                    }
                    delay(100);
                }else
                    noCursor();
                mouse_movesCamera = !mouse_movesCamera;
                delay(100);
            }
            
            //camera movements
            if(mouse_movesCamera){
                
                //y axis rotation
                if(mouse_stopListenningX)
                    mouse_stopListenningX = false;
                else
                    playerAngleY += playerAngleStep*(mouseX-pmouseX);
                if(mouseX <= 10 || mouseX >= width-10){
                    mouse_stopListenningX = true;
                    r0t.mouseMove(width_2,mouseY);
                    //19.02 is a parameter to set to increase the accuracy
                    playerAngleX_Ref -= 19.02*playerAngleStep;
                    display_on = false;
                }
                if(playerAngleY < -PI)
                    playerAngleY += PImul2;
                else if(playerAngleY > PI)
                    playerAngleY -= PImul2;
                
                //x axis rotation
                if(mouseY < 10)
                    r0t.mouseMove(width_2,60);
                if(mouseY > height)
                    r0t.mouseMove(width_2,height);
                if(mouse_YRef == -1){
                    mouse_YRef = mouseY;
                    playerAngleX_Ref = playerAngleX;
                }
                playerAngleX = playerAngleX_Ref - playerAngleStep*(mouseY-mouse_YRef);
                if(playerAngleX < -PIdiv2)
                    playerAngleX = -PIdiv2;
                else if(playerAngleX > PIdiv2)
                    playerAngleX = PIdiv2;
                
                //raycast distance
                if(mouse_wheel > 0){
                    raycast_distance -= raycast_distanceStep;
                    if(raycast_distance < raycast_distanceMin)
                        raycast_distance = raycast_distanceMin;
                    mouse_wheel = 0;
                    delay(100);
                }else if(mouse_wheel < 0){
                    raycast_distance += raycast_distanceStep;
                    if(raycast_distance > raycast_distanceMax)
                        raycast_distance = raycast_distanceMax;
                    mouse_wheel = 0;
                    delay(100);
                }
            
            }else{ //mouse tools actions
                
                //actions
                if(mousePressed && mouseButton == LEFT){
                    byte x = (byte)(selCube[0]+8);
                    byte y = (byte)(selCube[1]+8);
                    byte z = (byte)(selCube[2]+8);
                    byte i,d;
                    switch(mouse_tool){
                        case PLACE:
                            if(toolsSelected){
                                //place sound
                                snd_mouse[0].rewind();
                                snd_mouse[0].play();
                                
                                //place tool
                                boxes[boxSel][z][y][x] = (byte)(toolbarSel+1); //dir=0 => element=id
                                updateSignalsAround(boxSel,x,y,z);
                                
                            }else{
                                if(boxSel == 0){ //if in main box
                                    //place sound
                                    snd_mouse[0].rewind();
                                    snd_mouse[0].play();
                                    
                                    //place box
                                    boxes[boxSel][z][y][x] = (byte)(boxbarSel+8); //dir=0 => element=id
                                    updateSignalsAround(boxSel,x,y,z);
                                
                                }else if(boxSel != boxbarSel+1){ //if not in main box nor the same id as the actual box
                                    if(!searchForBox(
                                        boxbarSel,
                                        (byte)(boxSel-1)
                                    )){
                                        //place sound
                                        snd_mouse[0].rewind();
                                        snd_mouse[0].play();
                                        
                                        //place box
                                        boxes[boxSel][z][y][x] = (byte)(boxbarSel+8);
                                        checkInBoxData();
                                        updateSignalsAround(boxSel,x,y,z);
                                    }
                                }
                            }
                        break;
                        case BREAK:
                            //break sound
                            snd_mouse[1].rewind();
                            snd_mouse[1].play();
                            
                            //break element
                            boxes[boxSel][z][y][x] = 0; //air, dir=0
                            updateSignalsAround(boxSel,x,y,z);
                        break;
                        case ROTATE:
                            //rotate sound
                            snd_mouse[2].rewind();
                            snd_mouse[2].play();
                            
                            //rotate element
                            d = (byte)(getDir(boxes[boxSel][z][y][x])+1);
                            if(d == 6)
                                d = 0;
                            i = getID(boxes[boxSel][z][y][x]);
                            boxes[boxSel][z][y][x] = setElement(i,d);
                            updateSignalsAround(boxSel,x,y,z);
                        break;
                        case INBOX:
                            d = getID(boxes[boxSel][z][y][x]);
                            if(d > 7 && d < 15){ //if this is a box
                                //inbox sound
                                snd_mouse[3].rewind();
                                snd_mouse[3].play();
                            
                                boxSel = (byte)(d-7);
                            }
                        break;
                        case OUTBOX:
                            if(boxSel != 0){
                                //outbox sound
                                snd_mouse[4].rewind();
                                snd_mouse[4].play();
                                
                                boxSel = 0;
                            }
                        break;
                    }
                    delay(100);
                
                //mouse tool selection (rolling)
                }else if(mouse_wheel > 0){
                    switch(mouse_tool){
                        case PLACE:
                            mouse_tool = cursor_tools.BREAK;
                            cursor(img_mouse[2]); //break
                        break;
                        case BREAK:
                            mouse_tool = cursor_tools.ROTATE;
                            cursor(img_mouse[3]); //rotate
                        break;
                        case ROTATE:
                            mouse_tool = cursor_tools.INBOX;
                            cursor(img_mouse[4]); //inbox
                        break;
                        case INBOX:
                            mouse_tool = cursor_tools.OUTBOX;
                            cursor(img_mouse[5]); //outbox
                        break;
                        case OUTBOX:
                            mouse_tool = cursor_tools.PLACE;
                            cursor(img_mouse[1]); //place
                        break;
                    }
                    mouse_wheel = 0;
                    delay(100);
                }else if(mouse_wheel < 0){
                    switch(mouse_tool){
                        case PLACE:
                            mouse_tool = cursor_tools.OUTBOX;
                            cursor(img_mouse[5]); //outbox
                        break;
                        case BREAK:
                            mouse_tool = cursor_tools.PLACE;
                            cursor(img_mouse[1]); //place
                        break;
                        case ROTATE:
                            mouse_tool = cursor_tools.BREAK;
                            cursor(img_mouse[2]); //break
                        break;
                        case INBOX:
                            mouse_tool = cursor_tools.ROTATE;
                            cursor(img_mouse[3]); //rotate
                        break;
                        case OUTBOX:
                            mouse_tool = cursor_tools.INBOX;
                            cursor(img_mouse[4]); //inbox
                        break;
                    }
                    mouse_wheel = 0;
                    delay(100);
                }
            }
        break;
    }
}
