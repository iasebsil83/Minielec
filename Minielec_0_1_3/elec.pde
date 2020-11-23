// ---------------- Initialisation ----------------
boolean[][][][] elec_signals = new boolean[8][16][16][16];
boolean[][][][] elec_updated = new boolean[8][16][16][16];
boolean[][][] elec_findUpdated = new boolean[16][16][16];

void resetSignals(){
    for(byte a=0; a < 8; a++){
        for(byte z=0; z < 16; z++){
            for(byte y=0; y < 16; y++){
                for(byte x=0; x < 16; x++){
                    elec_signals[a][z][y][x] = false;
                    elec_updated[a][z][y][x] = false;
                }
            }
        }
    }
}

void resetSignalUpdates(byte b){
    for(byte z=0; z < 16; z++)
        for(byte y=0; y < 16; y++)
            for(byte x=0; x < 16; x++)
                elec_updated[b][z][y][x] = false;
}

void resetFindUpdates(){
    for(byte z=0; z < 16; z++)
        for(byte y=0; y < 16; y++)
            for(byte x=0; x < 16; x++)
                elec_findUpdated[z][y][x] = false;
}



// ---------------- Execution ----------------
boolean findWireSource(byte b, int dir, byte x, byte y, byte z){ //dir is the WANTED direction for the source
    //no sources outside the box
    if(x < 0 || x > 15 || //if outside of the box
       y < 0 || y > 15 ||
       z < 0 || z > 15)
           return false;
    
    //inverter well oriented and not powered
    byte i = getID(boxes[b][z][y][x]);
    byte d = getDir(boxes[b][z][y][x]);
    if(i == 2 && d == dir && !elec_signals[b][z][y][x])
        return true;
    
    //eliminate useless cases
    if(elec_findUpdated[z][y][x])
        return false;
    elec_findUpdated[z][y][x] = true;
    
    //wire spreading
    if(i == 1){
        boolean[] links = isLinked(b,i,d,x,y,z);
        boolean result = false;
        if(links[0])
            result |= findWireSource(b,0,(byte)(x-1),y,z);
        if(links[1])
            result |= findWireSource(b,1,(byte)(x+1),y,z);
        if(links[2])
            result |= findWireSource(b,2,x,y,(byte)(z+1));
        if(links[3])
            result |= findWireSource(b,3,x,y,(byte)(z-1));
        if(links[4])
            result |= findWireSource(b,4,x,(byte)(y+1),z);
        if(links[5])
            result |= findWireSource(b,5,x,(byte)(y-1),z);
        return result;
    }
    return false;
}

void spreadSignal(byte b, byte x, byte y, byte z, boolean state){
    byte i = getID(boxes[b][z][y][x]);
    byte d = getDir(boxes[b][z][y][x]);
    if(i != 1 || elec_findUpdated[z][y][x])
        return;
    elec_findUpdated[z][y][x] = true;
    elec_signals[b][z][y][x] = state;
    
    //wire spreading
    boolean[] links = isLinked(b,i,d,x,y,z);
    if(links[0] && x != 0)
        spreadSignal(b,(byte)(x-1),y,z, state);
    if(links[1] && x != 15)
        spreadSignal(b,(byte)(x+1),y,z, state);
    if(links[2] && z != 15)
        spreadSignal(b,x,y,(byte)(z+1), state);
    if(links[3] && z != 0)
        spreadSignal(b,x,y,(byte)(z-1), state);
    if(links[4] && y != 15)
        spreadSignal(b,x,(byte)(y+1),z, state);
    if(links[5] && y != 0)
        spreadSignal(b,x,(byte)(y-1),z, state);
}

void updateSignalsAround(byte b, byte x, byte y, byte z){
    updateSignal(b, x,y,z);
    resetSignalUpdates(b);
    updateSignal(b, (byte)(x-1),y,z);
    resetSignalUpdates(boxSel);
    updateSignal(b, (byte)(x+1),y,z);
    resetSignalUpdates(b);
    updateSignal(b, x,(byte)(y-1),z);
    resetSignalUpdates(b);
    updateSignal(b, x,(byte)(y+1),z);
    resetSignalUpdates(b);
    updateSignal(b, x,y,(byte)(z-1));
    resetSignalUpdates(b);
    updateSignal(b, x,y,(byte)(z+1));
    resetSignalUpdates(b);
}

boolean setOnState(byte b, int dir, byte x, byte y, byte z){ //if state set ON : return true
    byte i,d;
    switch(dir){
        case 0: //front
            if(x != 0){
                i = getID(boxes[b][z][y][x-1]);
                d = getDir(boxes[b][z][y][x-1]);
                if(i == 1){
                    if(findWireSource(b,0,(byte)(x-1),y,z)){
                        elec_signals[b][z][y][x] = true;
                        return true;
                    }else{
                        resetFindUpdates();
                        spreadSignal(b,(byte)(x-1),y,z, false);
                    }
                }else if(i == 2 && d == 0 && !elec_signals[b][z][y][x-1]){
                    elec_signals[b][z][y][x] = true;
                    return true;
                }
            }
        break;
        case 1: //back
            if(x != 15){
                i = getID(boxes[b][z][y][x+1]);
                d = getDir(boxes[b][z][y][x+1]);
                if(i == 1){
                    if(findWireSource(b,1,(byte)(x+1),y,z)){
                        elec_signals[b][z][y][x] = true;
                        return true;
                    }else{
                        resetFindUpdates();
                        spreadSignal(b,(byte)(x+1),y,z, false);
                    }
                }else if(i == 2 && d == 1 && !elec_signals[b][z][y][x+1]){
                    elec_signals[b][z][y][x] = true;
                    return true;
                }
            }
        break;
        case 2: //left
            if(z != 15){
                i = getID(boxes[b][z+1][y][x]);
                d = getDir(boxes[b][z+1][y][x]);
                if(i == 1){
                    if(findWireSource(b,2,x,y,(byte)(z+1))){
                        elec_signals[b][z][y][x] = true;
                        return true;
                    }else{
                        resetFindUpdates();
                        spreadSignal(b,x,y,(byte)(z+1), false);
                    }
                }else if(i == 2 && d == 2 && !elec_signals[b][z+1][y][x]){
                    elec_signals[b][z][y][x] = true;
                    return true;
                }
            }
        break;
        case 3: //right
            if(z != 0){
                i = getID(boxes[b][z-1][y][x]);
                d = getDir(boxes[b][z-1][y][x]);
                if(i == 1){
                    if(findWireSource(b,3,x,y,(byte)(z-1))){
                        elec_signals[b][z][y][x] = true;
                        return true;
                    }else{
                        resetFindUpdates();
                        spreadSignal(b,x,y,(byte)(z-1), false);
                    }
                }else if(i == 2 && d == 3 && !elec_signals[b][z-1][y][x]){
                    elec_signals[b][z][y][x] = true;
                    return true;
                }
            }
        break;
        case 4: //top
            if(y != 15){
                i = getID(boxes[b][z][y+1][x]);
                d = getDir(boxes[b][z][y+1][x]);
                if(i == 1){
                    if(findWireSource(b,4,x,(byte)(y+1),z)){
                        elec_signals[b][z][y][x] = true;
                        return true;
                    }else{
                        resetFindUpdates();
                        spreadSignal(b,x,(byte)(y+1),z, false);
                    }
                }else if(i == 2 && d == 4 && !elec_signals[b][z][y+1][x]){
                    elec_signals[b][z][y][x] = true;
                    return true;
                }
            }
        break;
        case 5: //bottom
            if(y != 0){
                i = getID(boxes[b][z][y-1][x]);
                d = getDir(boxes[b][z][y-1][x]);
                if(i == 1){
                    if(findWireSource(b,5,x,(byte)(y-1),z)){
                        elec_signals[b][z][y][x] = true;
                        return true;
                    }else{
                        resetFindUpdates();
                        spreadSignal(b,x,(byte)(y-1),z, false);
                    }
                }else if(i == 2 && d == 5 && !elec_signals[b][z][y-1][x]){
                    elec_signals[b][z][y][x] = true;
                    return true;
                }
            }
        break;
    }
    return false;
}

void setOnStatesAroundBox(byte b, byte x, byte y, byte z, boolean[] states){
    //front
    if(states[0] && x != 0){
        byte i = getID(boxes[b][z][y][x-1]);
        //unactivated wire
        if(i == 1 && !elec_signals[b][z][y][x-1])
            spreadSignal(b,(byte)(x-1),y,z, true);
        //inverter
        else if(i == 2){
            byte d = getDir(boxes[b][z][y][x-1]);
            if(d == 1)
                elec_signals[b][z][y][x-1] = true;
        }
    }
    
    //back
    resetFindUpdates();
    if(states[1] && x != 15){
        byte i = getID(boxes[b][z][y][x+1]);
        //unactivated wire
        if(i == 1 && !elec_signals[b][z][y][x+1])
            spreadSignal(b,(byte)(x+1),y,z, true);
        //inverter
        else if(i == 2){
            byte d = getDir(boxes[b][z][y][x+1]);
            if(d == 0)
                elec_signals[b][z][y][x+1] = true;
        }
    }
    
    //left
    resetFindUpdates();
    if(states[2] && z != 15){
        byte i = getID(boxes[b][z+1][y][x]);
        //unactivated wire
        if(i == 1 && !elec_signals[b][z+1][y][x])
            spreadSignal(b,x,y,(byte)(z+1), true);
        //inverter
        else if(i == 2){
            byte d = getDir(boxes[b][z+1][y][x]);
            if(d == 3)
                elec_signals[b][z+1][y][x] = true;
        }
    }
    
    //right
    resetFindUpdates();
    if(states[3] && z != 0){
        byte i = getID(boxes[b][z-1][y][x]);
        //unactivated wire
        if(i == 1 && !elec_signals[b][z-1][y][x])
            spreadSignal(b,x,y,(byte)(z-1), true);
        //inverter
        else if(i == 2){
            byte d = getDir(boxes[b][z-1][y][x]);
            if(d == 2)
                elec_signals[b][z-1][y][x] = true;
        }
    }
    
    //top
    resetFindUpdates();
    if(states[4] && y != 15){
        byte i = getID(boxes[b][z][y+1][x]);
        //unactivated wire
        if(i == 1 && !elec_signals[b][z][y+1][x])
            spreadSignal(b,x,(byte)(y+1),z, true);
        //inverter
        else if(i == 2){
            byte d = getDir(boxes[b][z][y+1][x]);
            if(d == 5)
                elec_signals[b][z][y+1][x] = true;
        }
    }
    
    //bottom
    resetFindUpdates();
    if(states[5] && y != 0){
        byte i = getID(boxes[b][z][y-1][x]);
        //unactivated wire
        if(i == 1 && !elec_signals[b][z][y-1][x])
            spreadSignal(b,x,(byte)(y-1),z, true);
        //inverter
        else if(i == 2){
            byte d = getDir(boxes[b][z][y-1][x]);
            if(d == 4)
                elec_signals[b][z][y-1][x] = true;
        }
    }
}

boolean[] updateInsideBox(byte i, boolean[] in){
    boolean[] out = {
        false,false,false,
        false,false,false
    };
    
    //create backup box
    byte[][][] saveBox = new byte[16][16][16];
    boolean[][][] saveSignals = new boolean[16][16][16];
    for(byte z=0; z < 16; z++){
        for(byte y=0; y < 16; y++){
            for(byte x=0; x < 16; x++){
                saveBox[z][y][x] = boxes[i][z][y][x];
                saveSignals[z][y][x] = elec_signals[i][z][y][x];
            }
        }
    }
    
    //updating box
    if(in[0]){ //front
        for(byte y=0; y < 16; y++){
            for(byte z=0; z < 16; z++)
                updateSignal(i,(byte)0,y,z);
        }
    }
    if(in[1]){ //back
        for(byte y=0; y < 16; y++){
            for(byte z=0; z < 16; z++)
                updateSignal(i,(byte)15,y,z);
        }
    }
    if(in[2]){ //left
        for(byte y=0; y < 16; y++){
            for(byte x=0; x < 16; x++)
                updateSignal(i,x,y,(byte)15);
        }
    }
    if(in[3]){ //left
        for(byte y=0; y < 16; y++){
            for(byte x=0; x < 16; x++)
                updateSignal(i,x,y,(byte)0);
        }
    }
    if(in[4]){ //top
        for(byte x=0; x < 16; x++){
            for(byte z=0; z < 16; z++)
                updateSignal(i,x,(byte)0,z);
        }
    }
    if(in[5]){ //bottom
        for(byte x=0; x < 16; x++){
            for(byte z=0; z < 16; z++)
                updateSignal(i,x,(byte)15,z);
        }
    }
    
    //get states
    for(byte y=0; y < 16; y++)
        for(byte z=0; z < 16; z++)
            out[0] |= setOnState(i,0,(byte)0,y,z);
    for(byte y=0; y < 16; y++)
        for(byte z=0; z < 16; z++)
            out[1] |= setOnState(i,1,(byte)15,y,z);
    for(byte y=0; y < 16; y++)
        for(byte x=0; x < 16; x++)
            out[2] |= setOnState(i,2,x,y,(byte)15);
    for(byte y=0; y < 16; y++)
        for(byte x=0; x < 16; x++)
            out[3] |= setOnState(i,3,x,y,(byte)0);
    for(byte x=0; x < 16; x++)
        for(byte z=0; z < 16; z++)
            out[4] |= setOnState(i,4,x,(byte)0,z);
    for(byte x=0; x < 16; x++)
        for(byte z=0; z < 16; z++)
            out[5] |= setOnState(i,5,x,(byte)15,z);
    
    //reset the box
    for(byte z=0; z < 16; z++){
        for(byte y=0; y < 16; y++){
            for(byte x=0; x < 16; x++){
                boxes[i][z][y][x] = saveBox[z][y][x];
                elec_signals[i][z][y][x] = saveSignals[z][y][x];
            }
        }
    }
    
    return out;
}

void updateSignal(byte b, byte x, byte y, byte z){
    //end of update detecting
    if(x < 0 || x > 15 || //if outside of the box (security)
       y < 0 || y > 15 ||
       z < 0 || z > 15 ||
       elec_updated[b][z][y][x]) //if already updated
           return;
    byte id = getID(boxes[b][z][y][x]);
    if(id == 0 || id == 3 || id == 4) //if void, button or switch
        return;
    
    //update marking
    elec_updated[b][z][y][x] = true;
    
    //modificating state
    resetFindUpdates();
    byte dir = getDir(boxes[b][z][y][x]);
    
    //for boxes
    if(id > 7 && id < 15){
        boolean[] states = {
            false,false,false,
            false,false,false
        };
        for(byte a=0; a < 6; a++){
            states[a] = setOnState(b,a,x,y,z);
            resetFindUpdates();
        }
        states = updateInsideBox((byte)(id-7),states);
        setOnStatesAroundBox(b,x,y,z,states);
    
    //for wires and inverters
    }else{
        boolean[] links = isLinked(b,id,dir,x,y,z);
        boolean stateSet = false;
        switch(id){
            case 1: //wire
                for(byte a=0; a < 6; a++){
                    if(links[a]){
                        elec_signals[b][z][y][x] = findWireSource(b,a,x,y,z);
                        stateSet = true;
                        break;
                    }
                }
                if(!stateSet)
                    elec_signals[b][z][y][z] = false;
            break;
            case 2: //inverter
                if(!setOnState(b,(int)dir,x,y,z))
                    elec_signals[b][z][y][x] = false;
            break;
            case 5: //lamp
                switch(dir){
                    case 0: //front
                    case 1: //back
                        if(!setOnState(b,0,x,y,z) && !setOnState(b,1,x,y,z))
                            elec_signals[b][z][y][x] = false;
                    break;
                    case 2: //left
                    case 3: //right
                        if(!setOnState(b,2,x,y,z) && !setOnState(b,3,x,y,z))
                            elec_signals[b][z][y][x] = false;
                    break;
                    case 4: //top
                    case 5: //bottom
                        if(!setOnState(b,4,x,y,z) && !setOnState(b,5,x,y,z))
                            elec_signals[b][z][y][x] = false;
                    break;
                }
            break;
        }
    }
    
    //spreading update
    updateSignal(b, (byte)(x+1),y,z);
    updateSignal(b, (byte)(x-1),y,z);
    updateSignal(b, x,y,(byte)(z-1));
    updateSignal(b, x,y,(byte)(z+1));
    updateSignal(b, x,(byte)(y-1),z);
    updateSignal(b, x,(byte)(y+1),z);
}
