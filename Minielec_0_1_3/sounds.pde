// ---------------- Initialisation ----------------
Minim minim;
AudioPlayer snd_menu;
AudioPlayer[] snd_game = new AudioPlayer[4];
AudioPlayer[] snd_mouse = new AudioPlayer[5]; //0:place, 1:break, 2:rotate,
                                              //3:inbox, 4:outbox
AudioPlayer snd_scrshot;
byte musicSel = (byte)random(4);
boolean snd_on = true;

void initSounds(){
    minim = new Minim(this);
    //sounds
    snd_mouse[0] = minim.loadFile("sounds/sounds/place.mp3" );
    snd_mouse[1] = minim.loadFile("sounds/sounds/break.mp3" );
    snd_mouse[2] = minim.loadFile("sounds/sounds/rotate.mp3");
    snd_mouse[3] = minim.loadFile("sounds/sounds/inbox.mp3" );
    snd_mouse[4] = minim.loadFile("sounds/sounds/outbox.mp3");
    snd_scrshot  = minim.loadFile("sounds/sounds/screenshot.mp3");
    for(byte a=0; a < 5; a++)
        snd_mouse[a].setGain(10);
    
    //musics
    snd_menu = minim.loadFile("sounds/musics/menu.mp3");
    for(byte a=0; a < 4; a++){
        snd_game[a] = minim.loadFile("sounds/musics/game" + a + ".mp3");
        snd_game[a].setGain(-5);
    }
    snd_menu.loop();
}



// ---------------- Execution ----------------
void soundCheck(){
    if(snd_on){
        switch(menu){
            case START:
                if(!snd_menu.isPlaying()){
                    snd_menu.rewind();
                    snd_menu.loop();
                }
                if(snd_game[musicSel].isPlaying())
                    snd_game[musicSel].pause();
            break;
            case GAME:
                if(!snd_game[musicSel].isPlaying()){
                    musicSel = (byte)random(snd_game.length);
                    snd_game[musicSel].rewind();
                    snd_game[musicSel].play();
                }
                if(snd_menu.isPlaying())
                    snd_menu.pause();
            break;
        }
    }else{
        if(snd_menu.isPlaying())
            snd_menu.pause();
        for(byte a=0; a < snd_game.length; a++)
            if(snd_game[a].isPlaying())
                snd_game[a].pause();
    }
}
