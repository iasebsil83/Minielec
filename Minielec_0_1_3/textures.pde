// -------------------- Initialisation --------------------
PImage img_scene; //3D
PImage[] img_wire     = new PImage[2];
PImage[] img_inverter = new PImage[2];
PImage[] img_button   = new PImage[2];
PImage[] img_switch   = new PImage[2];
PImage[] img_lamp     = new PImage[2];
PImage[][] img_box    = new PImage[7][6];
PImage img_selCube;
PImage[] img_startMenu = new PImage[3]; //2D (user interface)
PImage[] img_sound     = new PImage[2];
PImage img_gameUI;
PImage[] img_toolbar  = new PImage[8];
PImage[] img_boxbar   = new PImage[8];
PImage[][] img_boxes  = new PImage[7][2];
PImage[][] img_tools  = new PImage[7][2];
PImage[] img_mouse    = new PImage[6]; //0:neutral, 1:place, 2:break,
                                       //3:rotate, 4:inbox, 5:outbox

void initTextures(){
    
    //3D
    img_scene       = loadImage("sprites/scene.bmp"       );
    img_wire[0]     = loadImage("sprites/wire_off.bmp"    ); //elements
    img_wire[1]     = loadImage("sprites/wire_on.bmp"     );
    img_inverter[0] = loadImage("sprites/inverter_off.bmp");
    img_inverter[1] = loadImage("sprites/inverter_on.bmp" );
    img_button[0]   = loadImage("sprites/button_off.bmp"  );
    img_button[1]   = loadImage("sprites/button_on.bmp"   );
    img_switch[0]   = loadImage("sprites/switch_off.bmp"  );
    img_switch[1]   = loadImage("sprites/switch_on.bmp"   );
    img_lamp[0]     = loadImage("sprites/lamp_off.bmp"    );
    img_lamp[1]     = loadImage("sprites/lamp_on.bmp"     );
    for(byte a=0; a < 7; a++){
        img_box[a][0] = loadImage("sprites/boxes/box" + (a+1) + "Front.bmp" );
        img_box[a][1] = loadImage("sprites/boxes/box" + (a+1) + "Back.bmp"  );
        img_box[a][2] = loadImage("sprites/boxes/box" + (a+1) + "Left.bmp"  );
        img_box[a][3] = loadImage("sprites/boxes/box" + (a+1) + "Right.bmp" );
        img_box[a][4] = loadImage("sprites/boxes/box" + (a+1) + "Top.bmp"   );
        img_box[a][5] = loadImage("sprites/boxes/box" + (a+1) + "Bottom.bmp");
    }
    img_selCube     = loadImage("sprites/selCube.png"     );
    
    //2D (User Interface)
    img_startMenu[0] = loadImage("sprites/UI/startMenu_void.png");
    img_startMenu[1] = loadImage("sprites/UI/startMenu_play.png");
    img_startMenu[2] = loadImage("sprites/UI/startMenu_exit.png");
    img_sound[0] = loadImage("sprites/UI/sound_off.png");
    img_sound[1] = loadImage("sprites/UI/sound_on.png");
    img_gameUI   = loadImage("sprites/UI/gameUI.png");
    for(int a=0; a < 7; a++){
        img_toolbar[a] = loadImage("sprites/UI/toolbar" + a + ".png");
        img_boxbar[a]  = loadImage("sprites/UI/boxbar" + a + ".png" );
    }
    img_toolbar[7]  = loadImage("sprites/UI/toolbar.png");
    img_boxbar[7]   = loadImage("sprites/UI/boxbar.png" );
    img_tools[0][0] = loadImage("sprites/UI/tools/wire_off.bmp"    ); //tools
    img_tools[0][1] = loadImage("sprites/UI/tools/wire_on.bmp"     );
    img_tools[1][0] = loadImage("sprites/UI/tools/inverter_off.bmp");
    img_tools[1][1] = loadImage("sprites/UI/tools/inverter_on.bmp" );
    img_tools[2][0] = loadImage("sprites/UI/tools/button_off.bmp"  );
    img_tools[2][1] = loadImage("sprites/UI/tools/button_on.bmp"   );
    img_tools[3][0] = loadImage("sprites/UI/tools/switch_off.bmp"  );
    img_tools[3][1] = loadImage("sprites/UI/tools/switch_on.bmp"   );
    img_tools[4][0] = loadImage("sprites/UI/tools/lamp_off.bmp"    );
    img_tools[4][1] = loadImage("sprites/UI/tools/lamp_on.bmp"     );
    img_tools[5][0] = loadImage("sprites/UI/tools/tool5_off.bmp"   );
    img_tools[5][1] = loadImage("sprites/UI/tools/tool5_on.bmp"    );
    img_tools[6][0] = loadImage("sprites/UI/tools/tool6_off.bmp"   );
    img_tools[6][1] = loadImage("sprites/UI/tools/tool6_on.bmp"    );
    for(int a=0; a < 7; a++){
        img_boxes[a][0] = loadImage("sprites/UI/boxes/box" + (a+1) + "_off.bmp"); //boxes
        img_boxes[a][1] = loadImage("sprites/UI/boxes/box" + (a+1) + "_on.bmp" );
    }
    img_mouse[0] = loadImage("sprites/UI/cursor/normal.png"   );
    img_mouse[1] = loadImage("sprites/UI/cursor/place.png"    );
    img_mouse[2] = loadImage("sprites/UI/cursor/break.png"    );
    img_mouse[3] = loadImage("sprites/UI/cursor/rotate.png"   );
    img_mouse[4] = loadImage("sprites/UI/cursor/inbox.png" );
    img_mouse[5] = loadImage("sprites/UI/cursor/outbox.png");
}
