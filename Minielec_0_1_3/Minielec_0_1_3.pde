/* ================ Minielec [0.1.3] ================
    Minielec is a 3D game where you can easily create
    3D binary systems with basic electrical elements
    (wire, inverter, button, lamp, ...).

    You can also store your systems in little boxes
    and then use it several times in another system !
    You can communicate with a little box through his
    faces.
    Powering a face of a box will generate power inside
    of it on the entier wall.
    Thus, if you power a wall inside a box, the
    corresponding face at the outside of the wall will
    generate power.

    Thanks for downloading ! Now, enjoy !

    This game is made for ISEN Challenge 2019
    ISEN Challenge is an association of the ISEN Toulon,
    an Yncrea Mediterranee engineering school :
                        www.isen.fr

    Please report any bug at : i.a.sebsi83@gmail.com
    
                                            By I.A.
   
    Versions :

    12/11/2019 > [0.0.1] :
        - Created display, keys, mouse, textureLoader,
          and raycaster code files
        - 3D space with element storage and display
        - Function cube( int(x6), PImage(x6) ) created
        - 3D element textures imported
        - 2D user interface textures imported
        - Toolbar and boxbar selection
        - Camera rotations (x, y and z axis)
        - Camera movements (only x, y and z axis)

    14/11/2019 > [0.0.2] :
        - Music and sounds added (code and data files)
        - Game UI texture imported
        - Cursor textures imported

    20/11/2019 > [0.0.3] :
        - Rebuilding camera rotation on y axis to
          have the real y axis player angle
        - Player movements (front/back, left/right)
        - Screenshot taking in game
        - Mouse tools code made except for actions
        - File with the list of all current controls
        - Fixing a lot of details on sprites and delay

    21/11/2019 > [0.0.4] :
        - Selection cube imported
        - Start menu finalizations
        - Raycast with adjustable distance (mouse wheel)
          for selection cube (x axis locked)

    24/11/2019 > [0.0.5] : 
        - Unlocked x axis in raycasting
        - Swap the left and right click in game
        - Music and sounds (changing for library minim)
        - 3D tube creation available
        - Enable elements rotations
        - 3D shapes of button and switch done

    26/11/2019 > [0.0.6] :
        - Rotations top/bottom make also turn left the
          element (Necessary for tubes)
        - Wire + not wire elements linking
        - Separate textures for each box
        - Full inbox/outbox with anti-recursion system
        - Sounds for mouse interactions added
        - Screenshot animation + sound
        - Added limits to mouse in x axis rotation
          (limits in y for the mouse)
        - 3D cone creation available
        - 3D shape of inverter

    04/12/2019 > [0.1.1] :
        - Signal propagation for wires and inverters

    05/12/2019 > [0.1.2] :
        - Signal propagation for lamps
        - Save/load scene from save file

    05/12/2019 > [0.1.3] :
        - Signal propagation for boxes (only first direction)
    
    TO DO : - Game UI image
            - Keys definition image

    BUGS : - Ugly button and switch in rotations top/bottom
******************************************************************************************

    LICENCE :

    Minielec
    Copyright (C) 2019  Sebastien SILVANO
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.

    If not, see <https://www.gnu.org/licenses/>.

   ================================================== */



// ---------------- Importations ----------------
import peasy.*;
import ddf.minim.*;
import java.awt.Robot;



// ---------------- Functions ----------------
byte byteCast(boolean b){
    if(b)
        return 1;
    return 0;
}
byte getID(byte e){
    return (byte)(e&31); //between 0 and 31
}

byte getDir(byte e){
    return (byte)( (e>>5)&7 ); //between 0 and 7
}

byte setElement(int id, int dir){
    return (byte)( (dir<<5)+id );
}

void initRobot(){
    try{
        r0t = new Robot();
    }catch(Throwable e){}
}



// ---------------- Initialisation ----------------
//functional
byte bs = 90; //bs:boxsize (for 3D elements, for textures)
enum menu_names{
    START,
    GAME
};
menu_names menu = menu_names.START;
Robot r0t;
int timedUpdate;
int screenshotNbr;
final float PIdiv2 = PI/2;
final float PImul2 = 2*PI;
final short width_2  = 640;
final short height_2 = 360;
boolean display_on = true;

//mouse tools
enum cursor_tools{
    PLACE, BREAK, ROTATE,
    INBOX, OUTBOX
}
cursor_tools mouse_tool = cursor_tools.PLACE;

//elements
byte boxSel = 0;
boolean[][] inBoxData = new boolean[7][7];
byte boxSelCnt = 0;
byte[][][][] boxes = new byte[8][16][16][16]; //1 main box + 7 little boxes
float[] selCube = new float[3];

//player
boolean toolsSelected = true;
byte toolbarSel; //0:wire, 1:inverter, 2:button, 3:switch, 4:lamp, 5:tool5, 6:tool6
byte boxbarSel;  //n:box_n
PeasyCam cam;
float[] playerPos = {0,0,0};
float playerAngleX = 0; //between -PIdiv2 and PIdiv2
float playerAngleY = 0; //between -PI and PI
float playerPosStep = 10;
float playerAngleStep = 0.004;

//setup
void setup(){
    
    //functional
    size(1280,720,P3D);
    width = 1280;
    height = 720;
    fill(255);
    stroke(0);
    strokeWeight(1);
    scale(2*bs);
    textureMode(NORMAL);
    initTextures();
    initSounds();
    initRobot();
    resetSignals();
    cursor(img_mouse[0]); //normal
    menu = menu_names.START;
    
    //elements
    //storage system :
    //    e = ABCD EFGH => {000D EFGH:item, 0000 0ABC:direction}
    //    items = { 0:void,    1:wire,  2:inverter,  3:button,
    //              4:switch,  5:lamp,  6:tool5,     7:tool6,
    //              8:box0,    9:box1, 10:box2,     11:box3,
    //             12:box4,   13:box5, 14:box6}
    //    directions = {0:front, 1:back, 2:left,
    //                  3:right, 4:up,   5:down}
    //init : void cube
    for(byte a=0; a < 8; a++)
        for(byte z=0; z < 16; z++)
            for(byte y=0; y < 16; y++)
                for(byte x=0; x < 16; x++)
                    boxes[boxSel][z][y][x] = 0;
    
    //boxes data (anti-recursion system)
    for(byte a=0; a < 7; a++)
        for(byte b=0; b < 7; b++)
            inBoxData[a][b] = false;
    
    //player
    cam = new PeasyCam(this,10);
    cam.setMinimumDistance(50);
    cam.setMaximumDistance(5000);
    cam.setActive(false);
    translate(0,-8*bs,0);
}



// ---------------- Execution ----------------
void draw(){
    
    //events update
    if(display_on)
        display();
    else
        display_on = true;
    keyEvents();
    mouseEvents();
    
    //timed updates
    timedUpdate++;
    if(timedUpdate == 2000){
        soundCheck();
        timedUpdate = 0;
    }
}
