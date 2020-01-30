ex_audio_pause(World.music);
be = instance_create(x,y,BloodEmitter);
if(Player.speed > other.speed) 
{
 be.bloodSpeed = Player.speed;
 be.direction = Player.direction+180;
}
else 
{
 be.bloodSpeed = other.speed;
 be.direction = point_direction(other.x,other.y,other.x+other.hspeed,other.y+other.vspeed);
}

if (instance_exists(Player)) {
    with (Player) {
        instance_destroy();
    }
}

audio_play_sound(sndDeath1,0,0);
if(view_visible[0])
 instance_create(view_xview[0], view_yview[0], GameOver);
else if(view_visible[1])
 instance_create(view_xview[1], view_yview[1], GameOver);

with(Player)
    instance_destroy()

with(ShakeScreen)
    alarm[0] = 2;

global.death+=1
writeRoomCaption()
SaveGame(true) //Dying Save
