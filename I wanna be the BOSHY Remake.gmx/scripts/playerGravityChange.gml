if(place_meeting(x, y+1, block) || place_meeting(x,y-1,block) || onPlatform)
{
 if(gravity_direction == 270)
 {
  gravity_direction = 90;
  image_yscale = -abs(image_yscale);
  vspeed = -maxVspeed;
 }
 else 
 {
  gravity_direction = 270;
  image_yscale = abs(image_yscale);
  vspeed = maxVspeed;
 }
}
