if (instance_number(Bullet) < 5) {
    instance_create(x,y,Bullet);
    audio_play_sound(sndShoot,0,0);
}
