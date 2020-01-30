dyingSave = argument0

if(!dyingSave)
{
 external_call(global.save,global.death, global.time, 0, x, y, room, jumpMode);
 audio_play_sound(sndFuckYea,0,0);
}
else
{
 external_call(global.save,global.death, global.time, 1, 0, 0, 0, 0);
}
