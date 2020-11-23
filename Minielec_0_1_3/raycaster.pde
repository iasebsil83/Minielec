// ---------------- Initialisation ----------------
float raycast_distance = 0.3;         //between 0.1 and 1.2
float raycast_distanceStep = 0.05;
final float raycast_distanceMin = 0.1;
final float raycast_distanceMax = 1.2;

float toNearestInt(float v){
    return (v >= 0.5) ? (float)(int)(v+1) : (float)(int)v;
}


// ---------------- Execution ----------------
void raycast(){
    float cy = cos(playerAngleY);
    float sy = sin(playerAngleY);
    float sx = sin(-playerAngleX);
    float[] v = {
        playerPosStep*sy,
        playerPosStep*sx,
        -playerPosStep*cy
    };
    selCube[0] = playerPos[0] + raycast_distance*v[0]*bs;
    selCube[1] = playerPos[1] + raycast_distance*v[1]*bs;
    selCube[2] = playerPos[2] + raycast_distance*v[2]*bs;
    for(byte a=0; a < 3; a++){
        selCube[a] = toNearestInt(selCube[a]/bs)-1;
        if(selCube[a] > 7)
            selCube[a] = 7;
        if(selCube[a] < -8)
            selCube[a] = -8;
    }
}
