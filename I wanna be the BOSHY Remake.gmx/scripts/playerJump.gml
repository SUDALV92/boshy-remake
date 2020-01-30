if(gravity_direction == 270)
{
 if (place_meeting(x, y+1, block) || onPlatform) 
 {
    vspeed = -jump;
    audio_play_sound(sndJump,0,0);
    djump = true;
 }
 else if(djump == true) 
 {
    vspeed = -jump2;
    audio_play_sound(sndDJump,0,0)
    djump = false;
 }
}
else if(gravity_direction == 90)
{
 if(place_meeting(x,y-1,block) || onPlatform)
 {
  vspeed = jump;
  audio_play_sound(sndJump,0,0);
  djump = true;
 }
 else if(djump == true)
 {
  vspeed = jump2;
  audio_play_sound(sndDJump,0,0);
  djump = false;
 }
}
