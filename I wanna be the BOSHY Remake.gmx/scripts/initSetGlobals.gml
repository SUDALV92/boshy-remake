//Set Global Data Here

//First Stage
global.firstStage = rLevel01;
//Game Caption
global.roomCaptionDef = "I wanna be the BOSHY Remake by SUDALV";
global.save = external_define("IWannaSaver.dll","Save",dll_cdecl,ty_real,7,ty_real,ty_real,ty_real,ty_real,ty_real,ty_real,ty_real);
global.load = external_define("IWannaSaver.dll","Load",dll_cdecl,ty_real,1,ty_string);
