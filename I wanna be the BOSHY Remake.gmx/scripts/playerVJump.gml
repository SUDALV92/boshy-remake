if(gravity_direction == 270)
{
    if (vspeed < 0) vspeed *= 0.45;
}
else if (gravity_direction == 90 && vspeed > 0) 
    vspeed *= 0.45;
