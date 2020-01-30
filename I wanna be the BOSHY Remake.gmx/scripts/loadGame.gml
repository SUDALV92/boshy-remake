global.loadFlag = 1
r = external_call(global.load,"ROOM");
if(r < 2)
{
 
 global.loadFlag = 0;
 global.death = 0;
 global.time = 0;
 r = 2;
 room_goto(r);
}
else
{
 global.death = external_call(global.load,"DEATH");
 global.time = external_call(global.load,"TIME");
 room_goto(r);
}
