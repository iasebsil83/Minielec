// ---------------- Functions -----------------
void move(float x, float y, float z){
    float a = PI*(playerAngleY+3.2)/3.2;
    float c = cos(a);
    float s = sin(a);
    playerPos[0] +=   z*s - x*c;
    playerPos[1] += y;
    playerPos[2] += -(z*c + x*s);
    raycast();
}



// ---------------- Execution ----------------
void keyEvents(){
    switch(menu){
        case START:
            if(keyPressed){
                switch(key){
                    case 's':
                    case 'S':
                        snd_on = !snd_on;
                        soundCheck();
                        delay(100);
                    break;
                }
            }
        break;
        case GAME:
            if(keyPressed){
                byte s = -1;
                switch(key){ //WARNING : working on AZERTY keyboard only !
                    case '&': //toolbar/boxbar select 1
                        s = 0;
                    break;
                    case 'é': //toolbar/boxbar select 2
                        s = 1;
                    break;
                    case '"': //toolbar/boxbar select 3
                        s = 2;
                    break;
                    case '\'': //toolbar/boxbar select 4
                        s = 3;
                    break;
                    case '(': //toolbar/boxbar select 5
                        s = 4;
                    break;
                    case '-': //toolbar/boxbar select 6
                        s = 5;
                    break;
                    case 'è': //toolbar/boxbar select 7
                        s = 6;
                    break;
                    case 'à': //swap boxbar/toolbar
                        toolsSelected = !toolsSelected;
                        delay(100);
                    break;
                    case ' ': //move up
                        move(0,-playerPosStep,0);
                    break;
                    case 'w': //move down
                        move(0,playerPosStep,0);
                    break;
                    case 'd': //move right
                        move(playerPosStep,0,0);
                    break;
                    case 'q': //move left
                        move(-playerPosStep,0,0);
                    break;
                    case 'z': //move forward
                        move(0,0,-playerPosStep);
                    break;
                    case 's': //move backward
                        move(0,0,playerPosStep);
                    break;
                    case '<': //toggle sound
                        snd_on = !snd_on;
                        soundCheck();
                        delay(400);
                    break;
                    case '=': //take screenshot
                        //screenshot sound
                        snd_scrshot.rewind();
                        snd_scrshot.play();
                        
                        //take screenshot
                        save("screenshots/MiniElec_Screenshot" + screenshotNbr + ".png");
                        screenshotNbr++;
                        display_screenshotCnt = 15;
                    break;
                    case 'm': //go bac to start_menu
                        menu = menu_names.START;
                        cursor(img_mouse[0]);
                        r0t.mouseMove(width_2,height_2);
                        soundCheck();
                        delay(100);
                    break;
                    case 'g': //get saved scene
                        BufferedReader reader = createReader("scene.sav");
                        String line = null;
                        try{
                            byte a = -1;
                            byte z = -1; byte y = -1;
                            while( (line = reader.readLine()) != null){
                                if(line.contains("a")){
                                    z = -1; y = -1;
                                    a++; continue;
                                }
                                if(line.contains("z")){
                                    y = -1;
                                    z++; continue;
                                }
                                y++;
                                if(y > 15){ //security
                                    println("Unable to load save file");
                                    break;
                                }
                                String[] pieces = split(line, ",");
                                if(pieces.length == 0){
                                    println("Unable to load save file");
                                    break;
                                }
                                for(byte x=0; x < pieces.length-1; x++)
                                    boxes[a][z][y][x] = Byte.parseByte(pieces[x]);
                            }
                            reader.close();
                        }catch(IOException e){
                          println("Unable to load save file");
                        }
                        delay(100);
                    break;
                    case 't': //save scene
                        PrintWriter f = createWriter("scene.sav");
                        for(byte a=0; a < 8; a++){
                            f.println("a");
                            for(byte z=0; z < 16; z++){
                                f.println("z");
                                for(byte y=0; y < 16; y++){
                                    String L = "";
                                    for(byte x=0; x < 16; x++)
                                        L += (String)(boxes[a][z][y][x] + ",");
                                    f.println(L);
                                }
                            }
                        }
                        f.flush();
                        f.close();
                        println("Scene saved !");
                        delay(100);
                    break;
                }
                //tool or box selection
                if(s >= 0){
                    if(toolsSelected)
                        toolbarSel = s;
                    else
                        boxbarSel = s;
                    delay(100);
                }
            }
        break;
    }
}
