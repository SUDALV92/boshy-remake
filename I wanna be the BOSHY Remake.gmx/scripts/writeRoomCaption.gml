
var t, strHms;

strHms = global.roomCaptionDef;
strHms += " --- Death[" + string(global.death) + "]";

t = global.time;
strHms += " Time["
strHms  += string(floor(t/3600))+":";    t = t mod 3600;
strHms += string(floor(t/ 600))    ;    t = t mod  600;
strHms += string(floor(t/  60))+":";    t = t mod   60;
strHms += string(floor(t/  10))    ;    t = t mod   10;
strHms += string(floor(t     ))    ;
strHms += "]";

window_set_caption(strHms)
//window_set_caption(program_directory);
