#define ex_audio_class_add_sound
///ex_audio_class_add_sound(soundName, className)

var _sound_name     = argument[0];
var _class_name     = argument[1];
var _sound_list     = global._ex_audio_sounds;
var _classes_list   = global._ex_audio_classes;
var _class_list     = -1;
var _sound_resource = -1;
var _autoincrement  = 0;

// check name column of classes parent grid
_class_list = ex_audio_class_get_index(_class_name);

// get sound resource
_sound_resource = ex_audio_get_asset_index(_sound_name);

// resize audio class list and set autoincrement
if (ds_grid_height(_class_list) <= 0) {
	ds_grid_resize(_class_list, 4, 1);
	ds_grid_clear(_class_list, "");
} else {
    ds_grid_resize(_class_list, 4, ds_grid_height(_class_list)+1);
    _autoincrement = ds_grid_height(_class_list)-1;
}

// add sound to class list
ds_grid_set(_class_list, 0, _autoincrement, _sound_name);     // name
ds_grid_set(_class_list, 1, _autoincrement, _sound_resource); // sound id
ds_grid_set(_class_list, 2, _autoincrement, 0);               // has played
ds_grid_set(_class_list, 3, _autoincrement, 0);               // is latter

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Added sound with name "'+string( _sound_name )+'" to audio class "'+_class_name+'" ['+string( _class_list)+ ', ' +string( _autoincrement )+']'+'');
}

// return grid y position
return _autoincrement;


#define ex_audio_class_count
///ex_audio_class_count()

var _classes_list = global._ex_audio_classes;

if (not ds_exists(_classes_list, ds_type_grid)) {
    return 0;
}

if (ds_grid_height(_classes_list) < 2) {

	if (ds_grid_get(_classes_list, 0, 0) == "") {
		return 0;
	}

}

return ds_grid_height(_classes_list);


#define ex_audio_class_count_sounds
///ex_audio_class_count_sounds(className)

var _name = argument[0];
var _list = ex_audio_class_get_index(_name);

if (not ds_exists(global._ex_audio_classes, ds_type_grid)) {
    return 0;
}

if (_list < 0) {

    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

// ds resize workaround
if (is_string( ds_grid_get(_list, 0, 0) )) {

	if (ds_grid_height(_list) < 2) {
		if (ds_grid_get(_list, 0, 0) == "") {
			return 0;
		}
	}

} else {
	return 0;
}

return ds_grid_height(_list);


#define ex_audio_class_create
///ex_audio_class_create(className)

var _list           = global._ex_audio_classes;
var _list_max_size  = 2;
var _name           = argument[0];
var _class_list     = -1;
var _autoincrement  = 0;

// create or update the classes list
if (ds_exists(_list, ds_type_grid)) {
    
	// workaround
	if (ds_grid_get(_list, 0, 0) == "") {
		
	} else {
	
		ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
		_autoincrement = ds_grid_height(_list)-1;
	
	}
    
} else {
    global._ex_audio_classes = ds_grid_create(_list_max_size, 1);
    _list = global._ex_audio_classes;
}

// create a new class grid
_class_list = ds_grid_create(4, 0);

// add new grid
ds_grid_set(_list, 0, _autoincrement, _name);       // name
ds_grid_set(_list, 1, _autoincrement, _class_list); // class grid

var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _name ));

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Created audio class with name "'+string( _name )+'" ['+string( _y )+']');
}


#define ex_audio_class_destroy
///ex_audio_class_destroy(className)

var _class_name     = argument[0];
var _classes_list   = global._ex_audio_classes;
var _class_list     = -1;

// check name column of classes parent grid

var _y = ds_grid_value_y(_classes_list, 0, 0, 1, ds_grid_height(_classes_list), string( _class_name ));

_class_list = ds_grid_get(_classes_list, 1, _y);

// remove class index
if (ds_grid_height(_classes_list) < 2) {

	ds_grid_clear(_classes_list, "");
	ds_grid_resize(_classes_list, ds_grid_width(_classes_list), 1);
	
} else {
	ex_audio_ds_grid_delete_row(_classes_list, _y);
}

ds_grid_destroy(_class_list);

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Destroyed audio class with name "'+string( _class_name )+'" ['+string( _y )+']');
}

return 1;


#define ex_audio_class_exists
///ex_audio_class_exists(className)

var _name = argument[0];
var _list = ex_audio_class_get_index(_name);

if (_list < 0) {
    return 0;    
} else {
    return 1;
}


#define ex_audio_class_get_index
///ex_audio_class_get_index(className)

var _class_name     = argument[0];
var _classes_list   = global._ex_audio_classes;
var _class_list     = -1;

// check if classes exist first
if (ex_audio_class_count() < 1) {
	return -1;
}

// check name column of classes parent grid
var _cy = ds_grid_value_y(_classes_list, 0, 0, 0, ds_grid_height(_classes_list), string( _class_name ));
if (_cy < 0) {
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find class with name "'+string( _class_name )+'"');
    }
    return -1;
}

// get class list
_class_list = ds_grid_get(_classes_list, 1, _cy);

return _class_list;


#define ex_audio_class_get_name
///ex_audio_class_get_name(index)

var _class_index  = argument[0];
var _classes_list = global._ex_audio_classes;
var _class_list   = "";

if (_classes_list < 0) {
	return "";
}

if (_class_index < 0 or _class_index > ds_grid_height(_classes_list)) {
    return "";
}

// get class list
_class_list = ds_grid_get(_classes_list, 0, _class_index);

return _class_list;


#define ex_audio_class_pause
///ex_audio_class_pause(className)

var _name = argument[0];
var _list = ex_audio_class_get_index(_name);

if (_list < 0) {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all sounds in the group
for (var _i=0; _i < _list_size; _i++) {
    
    _result += 1;
    ex_audio_pause( ds_grid_get(_list, 0, _i) );
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Paused all sounds with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;


#define ex_audio_class_play
///ex_audio_class_play(className, loop)

var _name = argument[0];
var _list = ex_audio_class_get_index(_name);
var _loop = false;

if (argument_count >= 2) {
	_loop = argument[1];
}

if (_list < 0) {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all sounds in the group
for (var _i=0; _i < _list_size; _i++) {
    
    _result += 1;
    ex_audio_play( ds_grid_get(_list, 0, _i), _loop);
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Playing all sounds with class "'+string( _name )+'", '+string( _result )+' in total, looping "'+string(_loop)+'"');
}

return _result;


#define ex_audio_class_play_unique
///ex_audio_class_play_unique(className, pitchMin, pitchMax)

var _name = argument[0];
var _list = ex_audio_class_get_index(_name);

if (_list < 0) {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }

    return 0;
}

//ds resize bug workaround
if (ds_grid_get(_list, 0, 0) == "" and ds_grid_height(_list) < 2) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Warning, no sounds exist in class with name "'+string( _name )+'"');
    }
	
	return 0;
}

var _sounds_list    = global._ex_audio_sounds;
var _list_size      = ds_grid_height(_list);
var _choice         = irandom_range(0, _list_size-1);
var _played         = 0;
var _latter_average = _list_size/3;
var _sound          = -1;
var _pitch_min      = 1.0;
var _pitch_max      = 1.0;

if (_latter_average == 1) {
    _latter_average = 0.5;
}

// too few sounds in the list, just play the single sound
if (_list_size == 1) {
    
    _sound = ds_grid_get(_sounds_list, 0, 0);
    
    // handle cleared list
    if (_sound == -1) { 
        return -1;
    } else {
        ex_audio_play(_sound);
        return _sound;
    }
    
} else if (_list_size < 1) {
    return -1;
}

// check if sound has already been played
for (var _i=0; _i < _list_size; _i++) {
    if (ds_grid_get(_list, 2, _i) == 1) {
        _played += 1;
    }
}

if (_played >= _list_size) {
    for (var _i=0; _i < _list_size; _i++) {
        if (ds_grid_get(_list, 3, _i) == 0) {
            ds_grid_set(_list, 2, _i, 0);
            _played = 0;
        }
    }
}

// if sound has been played, reroll
if (ds_grid_get(_list, 2, _choice) == 1) {
    
    // prevent stack overflow
    if (_played >= _list_size) {
        for (var _i=0; _i < _list_size; _i++) {
            ds_grid_set(_list, 2, _i, 0);
            ds_grid_set(_list, 3, _i, 0);
            _played = 0;
        }
    }
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Re-rolling unique sound from class "'+string( _name )+'"');
    }
    
    ex_audio_class_play_unique(_name);
    
} else {
    // if (x) sounds have played, clear all latter sounds
    if (_played > _latter_average and not((_played + _latter_average) >= _list_size)) {
        for (var _i=0; _i < _list_size; _i++) {
            if (ds_grid_get(_list, 3, _i) == 1) {
                ds_grid_set(_list, 3, _i, 0);
            }
        }
    }
    
    // add choice to latter sounds if eligible
    if (_played+_latter_average >= _list_size) {
        ds_grid_set(_list, 3, _choice, 1);
    }
    
    // get sound
    ds_grid_set(_list, 2, _choice, 1);
    _sound = ds_grid_get(_list, 0, _choice);
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Playing unique sound "'+_sound+'" from class "'+string( _name )+'"');
    }
    
    // set random pitch within range if applicable
    if (argument_count >= 2) {
        ex_audio_set_pitch(_sound, random_range(argument[1], argument[2]));
    }
    
    // play rolled sound
    ex_audio_play(_sound);
    
    return _sound;
}


#define ex_audio_class_remove_sound
///ex_audio_class_remove_sound(soundName, className)

var _sound_name = argument[0];
var _class_name = argument[1];

// get class grid
_list = ex_audio_class_get_index(_class_name);

// check name column
var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _sound_name ));
if (_y < 0) {

    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find class with name "'+string( _class_name )+'"');
    }
    return 0;
    
}

// remove row
if (ds_grid_height(_list) < 2) {
	ds_grid_clear(_list, ""); //ds resize bug workaround
} else {
	ds_grid_set_grid_region(_list, _list, 0, _y+1, ds_grid_width(_list)-1, _y+1, 0, _y);
	ds_grid_resize(_list, ds_grid_width(_list), ds_grid_height(_list)-1);
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Removed sound with name "'+string( _sound_name )+'" from class "'+_class_name+'"');
}

return 1;


#define ex_audio_class_clear
///ex_audio_class_clear(className)

var _name = argument[0];

// get class grid
var _list = ex_audio_class_get_index(_name);

// check if classes exist first
if (_list < 0) {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

ds_grid_clear(_list, "");
ds_grid_resize(_list, ds_grid_width(_list), 1);

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Cleared all sounds from class "'+string( _name )+'"');
}

return 1;


#define ex_audio_class_resume
///ex_audio_class_resume(className)

var _name = argument[0];
var _list = ex_audio_class_get_index(_name);

//ds resize bug workaround
if (ds_grid_get(_list, 0, 0) == "" and ds_grid_height(_list) < 2) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Warning, no sounds exist in class with name "'+string( _name )+'"');
    }
	
	return 0;
}

if (_list < 0) {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all sounds in the group
for (var _i=0; _i < _list_size; _i++) {
    
    _result += 1;
    ex_audio_resume( ds_grid_get(_list, 0, _i) );
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Resumed all sounds with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;


#define ex_audio_class_set_pitch
///ex_audio_class_set_pitch(className, value, duration, easing)

var _name     = argument[0];
var _list     = ex_audio_class_get_index(_name);
var _pitch    = argument[1];
var _duration = 0;
var _easing   = -1;

if (_list < 0) {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// set easing
if (argument_count >= 4) {
    _easing = argument[3];
}

// set duration
if (argument_count >= 3) {
    _duration = argument[2];
}

// loop through all sounds in the group
for (var _i=0; _i < _list_size; _i++) {
    
    _result += 1;
    
    // set pitch with optional arguments
    if (argument_count >= 4) {
        ex_audio_set_pitch( ds_grid_get(_list, 0, _i), _pitch, _duration, _easing );
    } else if (argument_count >= 3) {
        ex_audio_set_pitch( ds_grid_get(_list, 0, _i), _pitch, _duration);
    } else {
        ex_audio_set_pitch( ds_grid_get(_list, 0, _i), _pitch);    
    }
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Setting pitch of all sounds with class "'+string( _name )+'", '+string( _result )+' in total to "'+string( _pitch )+'"');
}

return _result;


#define ex_audio_class_set_volume
///ex_audio_class_set_volume(className, value, duration, easing)

var _name     = argument[0];
var _list     = ex_audio_class_get_index(_name);
var _volume   = argument[1];
var _duration = 0;
var _easing   = -1;

if (_list < 0) {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

//ds resize bug workaround
if (ds_grid_get(_list, 0, 0) == "" and ds_grid_height(_list) < 2) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Warning, no sounds exist in class with name "'+string( _name )+'"');
    }
	
	return 0;
}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// set easing
if (argument_count >= 4) {
    _easing = argument[3];
}

// set duration
if (argument_count >= 3) {
    _duration = argument[2];
}

// loop through all sounds in the group
for (var _i=0; _i < _list_size; _i++) {
    
    _result += 1;
    
    // set volume with optional arguments
    if (argument_count >= 4) {
        ex_audio_set_volume( ds_grid_get(_list, 0, _i), _volume, _duration, _easing );
    } else if (argument_count >= 3) {
        ex_audio_set_volume( ds_grid_get(_list, 0, _i), _volume, _duration);
    } else {
        ex_audio_set_volume( ds_grid_get(_list, 0, _i), _volume);    
    }
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Setting volume of all sounds with class "'+string( _name )+'", '+string( _result )+' in total to "'+string( _volume )+'"');
}

return _result;


#define ex_audio_class_stop
///ex_audio_class_stop(className)

var _name = argument[0];
var _list = ex_audio_class_get_index(_name);

if (_list < 0) {

    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all sounds in the group
for (var _i=0; _i < _list_size; _i++) {
    
    _result += 1;
    ex_audio_stop( ds_grid_get(_list, 0, _i) );
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Stopped all sounds with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;


#define ex_audio_copy
///ex_audio_copy(name, copyName)

var _name      = argument[0];
var _copy_name = argument[1];

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Copying sound with name "'+string( _name )+'" to '+string( _copy_name )+'"');
}

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {

    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, cannot copy sound with "'+string( _name )+'" does not exist');
    }
    
    return 0;
}

// do not copy if sound is external
if (ds_grid_get(_list, 22, _y) == 1) {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, cannot copy sound with "'+string( _name )+'" because original sound is external stream');
    }
    
    return 0;
}

var _list           = global._ex_audio_sounds;
var _list_max_size  = 23;
var _autoincrement  = 0;

// update the sounds list
if (ds_exists(_list, ds_type_grid)) {
    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
    _autoincrement = ds_grid_height(_list)-1;
} else {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, cannot copy sound with "'+string( _name )+'", no loaded sounds exist');
    }
    
    return 0;
}

// create audio emitter
_audio_emitter = audio_emitter_create();

// add sound to the list
ds_grid_set(_list, 0,  _autoincrement, _copy_name);                  // name 
ds_grid_set(_list, 1,  _autoincrement, ds_grid_get(_list, 1, _y));   // resource id
ds_grid_set(_list, 2,  _autoincrement, _audio_emitter);              // emitter id
ds_grid_set(_list, 3,  _autoincrement, ds_grid_get(_list, 3, _y));   // length
ds_grid_set(_list, 4,  _autoincrement, ds_grid_get(_list, 4, _y));   // priority
ds_grid_set(_list, 5,  _autoincrement, ds_grid_get(_list, 5, _y));   // volume
ds_grid_set(_list, 6,  _autoincrement, ds_grid_get(_list, 6, _y));   // pitch
ds_grid_set(_list, 7,  _autoincrement, ds_grid_get(_list, 7, _y));   // x
ds_grid_set(_list, 8,  _autoincrement, ds_grid_get(_list, 8, _y));   // y
ds_grid_set(_list, 9,  _autoincrement, ds_grid_get(_list, 9, _y));   // z
ds_grid_set(_list, 10, _autoincrement, ds_grid_get(_list, 10, _y));  // falloff ref
ds_grid_set(_list, 11, _autoincrement, ds_grid_get(_list, 11, _y));  // falloff max
ds_grid_set(_list, 12, _autoincrement, ds_grid_get(_list, 12, _y));  // falloff factor
ds_grid_set(_list, 13, _autoincrement, ds_grid_get(_list, 13, _y));  // is suspended
ds_grid_set(_list, 14, _autoincrement, ds_grid_get(_list, 14, _y));  // is paused
ds_grid_set(_list, 15, _autoincrement, ds_grid_get(_list, 15, _y));  // is looping
ds_grid_set(_list, 16, _autoincrement, ds_grid_get(_list, 16, _y));  // velocity x
ds_grid_set(_list, 17, _autoincrement, ds_grid_get(_list, 17, _y));  // velocity y
ds_grid_set(_list, 18, _autoincrement, ds_grid_get(_list, 18, _y));  // velocity z
ds_grid_set(_list, 19, _autoincrement, ds_grid_get(_list, 19, _y));  // last started time
ds_grid_set(_list, 20, _autoincrement, ds_grid_get(_list, 20, _y));  // channel id
ds_grid_set(_list, 21, _autoincrement, ds_grid_get(_list, 21, _y));  // audiogroup
ds_grid_set(_list, 22, _autoincrement, ds_grid_get(_list, 22, _y));  // external

// update audio classes
var _classes        = ex_audio_get_classes(_name);
var _classes_number = ex_audio_get_classes_number(_name);

for (var _i=0; _i < _classes_number; _i++) {
    ex_audio_class_add_sound(_copy_name, _classes[_i]);
}

    
if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Updated classes of copied sound "'+string( _copy_name )+'"');
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Finished copying sound with name "'+string( _name )+'" to '+string( _copy_name )+'"');
}

// return grid y position
return _autoincrement;


#define ex_audio_count
///ex_audio_count()

var _list = global._ex_audio_sounds;

if (not ds_exists(_list, ds_type_grid)) {
	return 0;
}

if (ds_grid_height(_list) < 2) {

	if (ds_grid_get(_list, 0, 0) == "") {
		return 0;
	}

}

return ds_grid_height(_list);


#define ex_audio_exists
///ex_audio_exists(name)

var _name = argument[0];
var _list = ex_audio_get_index(_name);

if (_list < 0) {
    return 0;    
} else {
    return 1;
}


#define ex_audio_get_asset_index
///ex_audio_get_asset_index(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;
var _sound = -1;

var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return 0;
}

// get sound resource
_sound = ds_grid_get(_list, 1, _y);
return _sound;


#define ex_audio_get_asset_name
///ex_audio_get_asset_name(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;
var _sound = "";

var _y = ex_audio_get_index(_name);
if (_y < 0) {
    return "";
}

_sound = audio_get_name( ds_grid_get(_list, 1, _y) );
return _sound;


#define ex_audio_get_channel
///ex_audio_get_channel(name)

var _name    = argument[0];
var _list    = global._ex_audio_sounds;
var _channel = -1;

var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return -1;
}

// get channel
_channel = ds_grid_get(_list, 20, _y);

return _channel;


#define ex_audio_get_channel_number
///ex_audio_get_channel_number()

if (audio_system() == audio_new_system) {

    return global._ex_audio_channel_number;

} else {

    return 128;
    
}


#define ex_audio_get_classes
///ex_audio_get_classes(name)

var _sound_name        = argument[0];
var _classes_list      = global._ex_audio_classes;
var _classes_list_size = ds_grid_height(_classes_list);
var _class_list        = -1;
var _class_name        = -1;

var _classes_array;

_classes_array[0] = "";

var _classes_array_index = 0;

for (var _i=0; _i < _classes_list_size; _i++) {
    
    _class_name = ds_grid_get(_classes_list, 0, _i);
    _class_list = ds_grid_get(_classes_list, 1, _i);

    var _class_list_size = ds_grid_height(_class_list);
    
    for (var _i2=0; _i2 < _class_list_size; _i2++) {
    
        var _current_sound_name = ds_grid_get(_class_list, 0, _i2);
        
        if (_sound_name == _current_sound_name) {
            
            _classes_array[_classes_array_index] = _class_name;
            _classes_array_index += 1;
            
        }
    
    }

}

return _classes_array;


#define ex_audio_get_classes_number
///ex_audio_get_classes_number(name)

var _sound_name        = argument[0];
var _classes_list      = global._ex_audio_classes;
var _classes_list_size = ds_grid_height(_classes_list);
var _class_list        = -1;

var _result = 0;

for (var _i=0; _i < _classes_list_size; _i++) {
    
    _class_list = ds_grid_get(_classes_list, 1, _i);

    var _class_list_size = ds_grid_height(_class_list);
    
    for (var _i2=0; _i2 < _class_list_size; _i2++) {
    
        var _current_sound_name = ds_grid_get(_class_list, 0, _i2);
        
        if (_sound_name == _current_sound_name) {
            
            _result += 1;
            
        }
    
    }

}

return _result;


#define ex_audio_get_debug_mode
///ex_audio_get_debug_mode()

return global._ex_audio_debug_mode;


#define ex_audio_get_emitter
///ex_audio_get_emitter(name)

var _name    = argument[0];
var _list    = global._ex_audio_sounds;
var _emitter = -1;

var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return -1;
}

// get emitter
_emitter = ds_grid_get(_list, 2, _y);

return _emitter;


#define ex_audio_get_falloff_factor
///ex_audio_get_falloff_factor(name)

var _list = global._ex_audio_sounds;
var _name = argument[0];

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return 0;
}

// return property
return ds_grid_get(_list, 12, _y);


#define ex_audio_get_falloff_max
///ex_audio_get_falloff_max(name)

var _list = global._ex_audio_sounds;
var _name = argument[0];

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return 0;
}

// return property
return ds_grid_get(_list, 11, _y);


#define ex_audio_get_falloff_model
///ex_audio_get_falloff_model()

return global._ex_audio_falloff_model;


#define ex_audio_get_falloff_ref
///ex_audio_get_falloff_ref(name)

var _list = global._ex_audio_sounds;
var _name = argument[0];

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return 0;
}

// return property
return ds_grid_get(_list, 10, _y);


#define ex_audio_get_group
///ex_audio_get_group(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;
var _sound = "";

var _y = ex_audio_get_index(_name);
if (_y < 0) {
    return -1;
}

// get audiogroup
_sound = ds_grid_get(_list, 21, _y);

return _sound;


#define ex_audio_get_index
///ex_audio_get_index(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;

// check if sounds exist first
if (ex_audio_count() < 1) {
	return -1;
}

var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _name ));
if (_y < 0) {
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
    _y = -1;
}

return _y;


#define ex_audio_get_pitch
///ex_audio_get_pitch(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;
var _sound = -1;

var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return 0;
}

// get pitch
_sound = ds_grid_get(_list, 6, _y);

return _sound;


#define ex_audio_get_position_x
///ex_audio_get_position_x(name)

var _list = global._ex_audio_sounds;
var _name = argument[0];

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return 0;
}

// return property
return ds_grid_get(_list, 7, _y);


#define ex_audio_get_position_y
///ex_audio_get_position_y(name)

var _list = global._ex_audio_sounds;
var _name = argument[0];

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return 0;
}

// return property
return ds_grid_get(_list, 8, _y);


#define ex_audio_get_position_z
///ex_audio_get_position_z(name)

var _list = global._ex_audio_sounds;
var _name = argument[0];

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return 0;
}

// return property
return ds_grid_get(_list, 9, _y);


#define ex_audio_get_priority
///ex_audio_get_priority(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;
var _sound = -1;

var _y = ex_audio_get_index(_name);
if (_y < 0) {
	return 0;
}

// get priority
_sound = ds_grid_get(_list, 4, _y);

return _sound;


#define ex_audio_get_track_duration
///ex_audio_get_track_duration(name)

var _name   = argument[0];
var _list   = global._ex_audio_sounds;

var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get length
return audio_sound_length(ds_grid_get(_list, 1, _y));


#define ex_audio_get_track_position
///ex_audio_get_track_position(name)

var _name    = argument[0];
var _list    = global._ex_audio_sounds;
var _channel = -1;

var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound channel
_channel = ds_grid_get(_list, 20, _y);

if (audio_system() == audio_new_system) {
    return audio_sound_get_track_position(_channel);
} else {
    return 0;
}


#define ex_audio_get_velocity_x
///ex_audio_get_velocity_x(name)

var _list = global._ex_audio_sounds;
var _name = argument[0];

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// return property
return ds_grid_get(_list, 16, _y);


#define ex_audio_get_velocity_y
///ex_audio_get_velocity_y(name)

var _list = global._ex_audio_sounds;
var _name = argument[0];

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// return property
return ds_grid_get(_list, 17, _y);


#define ex_audio_get_velocity_z
///ex_audio_get_velocity_z(name)

var _list = global._ex_audio_sounds;
var _name = argument[0];

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// return property
return ds_grid_get(_list, 18, _y);


#define ex_audio_get_volume
///ex_audio_get_volume(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;
var _sound = -1;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get volume
_sound = ds_grid_get(_list, 5, _y);

return _sound;


#define ex_audio_group_get_load_progress
///ex_audio_group_get_load_progress(audioGroup)

return audio_group_load_progress(argument[0]);


#define ex_audio_group_is_loaded
///ex_audio_group_is_loaded(audioGroup)

if (audio_group_is_loaded(argument[0])) {
    return 1;
} else {
    return 0;
}


#define ex_audio_group_unload
///ex_audio_group_unload(audioGroup)

var _list = global._ex_audio_sounds;

if (ex_audio_count() < 1) {
	
	if (ex_audio_get_debug_mode()) {
		show_debug_message('exAudio: No loaded sounds exist to unload');
	}
	
	return 0;
}

var _list_size  = ds_grid_height(_list);
var _audiogroup = argument[0];

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Started complete unloading of audio group "'+string( _audiogroup )+'"');
}

// loop through all sounds and unload those who depend on the audio group
for (var _i=0; _i < _list_size; _i++) {
    
    var _current_name = ds_grid_get(_list, 0, _i);
    var _current_audiogroup = ds_grid_get(_list, 21, _i);
    
    if (_current_audiogroup == _audiogroup) {
        ex_audio_unload(_current_name);
        _i -= 1;
    }
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Finished complete unloading of audio group "'+string( _audiogroup )+'"');
}

return 1;


#define ex_audio_has_class
///ex_audio_has_class(soundName, className)

var _sound_name     = argument[0];
var _class_name     = argument[1];
var _classes_list   = global._ex_audio_classes;
var _class_list     = -1;

// check name column
_class_list = ex_audio_class_get_index(_class_name);

var _y = ds_grid_value_y(_class_list, 0, 0, 1, ds_grid_height(_class_list), string( _sound_name ));
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _sound_name )+'"');
    }
	
	return 0;
}

return 1;


#define ex_audio_init
///ex_audio_init()

global._ex_audio_sounds  = -1;
global._ex_audio_classes = -1;

global._ex_audio_listener[0] = 0;
global._ex_audio_listener[1] = 0;
global._ex_audio_listener[2] = 0;
global._ex_audio_listener[3] = 0;
global._ex_audio_listener[4] = 0;
global._ex_audio_listener[5] = 0;
global._ex_audio_listener[6] = 0;
global._ex_audio_listener[7] = 0;
global._ex_audio_listener[8] = 0;
global._ex_audio_listener[9] = 0;
global._ex_audio_listener[10] = 0;
global._ex_audio_listener[11] = 0;

global._ex_audio_channel_number = 128;
global._ex_audio_debug_mode     = 0;
global._ex_audio_falloff_model  = 0;

if (audio_system() == audio_new_system) {
    audio_falloff_set_model(audio_falloff_linear_distance);
    global._ex_audio_falloff_model = audio_falloff_linear_distance;
}


#define ex_audio_is_loaded
///ex_audio_is_loaded(name)

var _name       = argument[0];
var _list       = global._ex_audio_sounds;
var _audiogroup = -1;

// check name column
var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _name ));
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get audiogroup
_audiogroup = ds_grid_get(_list, 21, _y);

// return playing state
if (audio_system() == audio_new_system) {
    
    if (audio_group_is_loaded(_audiogroup)) {
        return 1;
    } else {
        return 0;
    }
    
} else {

    return 1;
    
}


#define ex_audio_is_looping
///ex_audio_is_looping(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// return loop state
return ds_grid_get(_list, 15, _y);


#define ex_audio_is_paused
///ex_audio_is_paused(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// return paused state
return ds_grid_get(_list, 14, _y);


#define ex_audio_is_playing
///ex_audio_is_playing(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;
var _sound = -1;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound resource
_sound = ds_grid_get(_list, 1, _y);

// return playing state
if (audio_system() == audio_new_system) {
    
    return audio_is_playing(_sound);
    
} else {
    
    return sound_isplaying(_sound);
    
}


#define ex_audio_is_suspended
///ex_audio_is_suspended(name)

var _name = argument[0];
var _list = global._ex_audio_sounds;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// return suspended state
return ds_grid_get(_list, 13, _y);


#define ex_audio_listener_get_orientation_lookat_x
///ex_audio_listener_get_orientation_lookat_x()

return global._ex_audio_listener[3];


#define ex_audio_listener_get_orientation_lookat_y
///ex_audio_listener_get_orientation_lookat_y()

return global._ex_audio_listener[4];


#define ex_audio_listener_get_orientation_lookat_z
///ex_audio_listener_get_orientation_lookat_z()

return global._ex_audio_listener[5];


#define ex_audio_listener_get_orientation_up_x
///ex_audio_listener_get_orientation_up_x()

return global._ex_audio_listener[6];


#define ex_audio_listener_get_orientation_up_y
///ex_audio_listener_get_orientation_up_y()

return global._ex_audio_listener[7];


#define ex_audio_listener_get_orientation_up_z
///ex_audio_listener_get_orientation_up_z()

return global._ex_audio_listener[8];


#define ex_audio_listener_get_position_x
///ex_audio_listener_get_position_x()

return global._ex_audio_listener[0];


#define ex_audio_listener_get_position_y
///ex_audio_listener_get_position_y()

return global._ex_audio_listener[1];


#define ex_audio_listener_get_position_z
///ex_audio_listener_get_position_z()

return global._ex_audio_listener[2];


#define ex_audio_listener_get_velocity_x
///ex_audio_listener_get_velocity_x()

return global._ex_audio_listener[9];


#define ex_audio_listener_get_velocity_y
///ex_audio_listener_get_velocity_y()

return global._ex_audio_listener[10];


#define ex_audio_listener_get_velocity_z
///ex_audio_listener_get_velocity_z()

return global._ex_audio_listener[11];


#define ex_audio_listener_reset
///ex_audio_listener_reset()

audio_listener_position(0, 0, 0);
audio_listener_velocity(0, 0, 0);
audio_listener_orientation(0, 0, 0, 0, 0, 0);

global._ex_audio_listener[0] = 0;
global._ex_audio_listener[1] = 0;
global._ex_audio_listener[2] = 0;
global._ex_audio_listener[3] = 0;
global._ex_audio_listener[4] = 0;
global._ex_audio_listener[5] = 0;
global._ex_audio_listener[6] = 0;
global._ex_audio_listener[7] = 0;
global._ex_audio_listener[8] = 0;
global._ex_audio_listener[9] = 0;
global._ex_audio_listener[10] = 0;
global._ex_audio_listener[11] = 0;

return 1;


#define ex_audio_listener_set_orientation
///ex_audio_listener_set_orientation(lookatX, lookatY, lookatZ, upX, upY, upZ)

var _orientation_lookat_x = argument[0];
var _orientation_lookat_y = argument[1];
var _orientation_lookat_z = argument[2];
var _orientation_up_x     = argument[3];
var _orientation_up_y     = argument[4];
var _orientation_up_z     = argument[5];

audio_listener_orientation(
    _orientation_lookat_x,
    _orientation_lookat_y,
    _orientation_lookat_z,
    _orientation_up_x,
    _orientation_up_y,
    _orientation_up_z
);

global._ex_audio_listener[3] = _orientation_lookat_x;
global._ex_audio_listener[4] = _orientation_lookat_y;
global._ex_audio_listener[5] = _orientation_lookat_z;
global._ex_audio_listener[6] = _orientation_up_x;
global._ex_audio_listener[7] = _orientation_up_y;
global._ex_audio_listener[8] = _orientation_up_z;


#define ex_audio_listener_set_position
///ex_audio_listener_set_position(x, y, z)

var _position_x = argument[0];
var _position_y = argument[1];
var _position_z = argument[2];

audio_listener_position(
    _position_x,
    _position_y,
    _position_z
);

global._ex_audio_listener[0] = _position_x;
global._ex_audio_listener[1] = _position_y;
global._ex_audio_listener[2] = _position_z;


#define ex_audio_listener_set_velocity
///ex_audio_listener_set_velocity(x, y, z)

var _velocity_x = argument[0];
var _velocity_y = argument[1];
var _velocity_z = argument[2];

audio_listener_position(
    _velocity_x,
    _velocity_y,
    _velocity_z
);

global._ex_audio_listener[9] = _velocity_x;
global._ex_audio_listener[10] = _velocity_y;
global._ex_audio_listener[11] = _velocity_z;


#define ex_audio_load
///ex_audio_load(name, sound, classes, priority, audiogroup)

var _list           = global._ex_audio_sounds;
var _list_max_size  = 23;
var _autoincrement  = 0;
var _audio_name     = argument[0];
var _audio_resource = argument[1];
var _audio_classes  = "";
var _audio_emitter  = -1;
var _audio_length   = 0;
var _audio_priority = 0;
var _audio_group    = 0;
var _audio_external = 0;

// create or update the sounds list
if (ds_exists(_list, ds_type_grid)) {
    
	// workaround
	if (ds_grid_get(_list, 0, 0) == "") {
		
	} else {
	
		ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
		_autoincrement = ds_grid_height(_list)-1;
	
	}

} else {
    global._ex_audio_sounds = ds_grid_create(_list_max_size, 0);
    _list = global._ex_audio_sounds;
    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
}

// check if sound with the same name exists
var _y = ds_grid_value_y(_list, 0, 0, ds_grid_width(_list), ds_grid_height(_list), string( _audio_name ));
if (_y > -1) {
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, sound name "'+string( _audio_name )+'" already exists, sound names must be unique');
    }
    return -1;
}

// set audio priority
if (argument_count >= 4) {
    _audio_priority = argument[3];
}

// set audio group
if (argument_count >= 5) {
    _audio_group = argument[4];
}

// create audio emitter
_audio_emitter = audio_emitter_create();

// get audio duration
if (audio_system() == audio_new_system) {
    _audio_length = audio_sound_length(_audio_resource);
}

// check if external (if provided a string)
if (is_string(_audio_resource)) {
    
    _audio_external = 1;
    
    // create stream and pass it as resource
    _audio_resource = audio_create_stream(_audio_resource);
    
    // not using audio group
    _audio_group = 0;
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Created stream from sound "'+string( _audio_name )+'"');
    }
}

// add sound to the list
ds_grid_set(_list, 0,  _autoincrement, _audio_name);                 // name 
ds_grid_set(_list, 1,  _autoincrement, _audio_resource);             // resource id
ds_grid_set(_list, 2,  _autoincrement, _audio_emitter);              // emitter id
ds_grid_set(_list, 3,  _autoincrement, _audio_length);               // length
ds_grid_set(_list, 4,  _autoincrement, _audio_priority);             // priority
ds_grid_set(_list, 5,  _autoincrement, 1.0);                         // volume
ds_grid_set(_list, 6,  _autoincrement, 1.0);                         // pitch
ds_grid_set(_list, 7,  _autoincrement, 0);                           // x
ds_grid_set(_list, 8,  _autoincrement, 0);                           // y
ds_grid_set(_list, 9,  _autoincrement, 0);                           // z
ds_grid_set(_list, 10, _autoincrement, 50);                          // falloff ref
ds_grid_set(_list, 11, _autoincrement, 100);                         // falloff max
ds_grid_set(_list, 12, _autoincrement, 1);                           // falloff factor
ds_grid_set(_list, 13, _autoincrement, 0);                           // is suspended
ds_grid_set(_list, 14, _autoincrement, 0);                           // is paused
ds_grid_set(_list, 15, _autoincrement, 0);                           // is looping
ds_grid_set(_list, 16, _autoincrement, 0);                           // velocity x
ds_grid_set(_list, 17, _autoincrement, 0);                           // velocity y
ds_grid_set(_list, 18, _autoincrement, 0);                           // velocity z
ds_grid_set(_list, 19, _autoincrement, 0);                           // last started time
ds_grid_set(_list, 20, _autoincrement, -1);                          // channel id
ds_grid_set(_list, 21, _autoincrement, _audio_group);                // audiogroup
ds_grid_set(_list, 22, _autoincrement, _audio_external);             // external

if (ex_audio_get_debug_mode()) {
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _audio_name ));
	show_debug_message('exAudio: Created sound with name "'+string( _audio_name )+'" ['+string( _y )+']');
}

if (_audio_group != 0 and _audio_external == 0) {

    if (not audio_group_is_loaded(_audio_group)) {
        if (ex_audio_get_debug_mode()) {
            show_debug_message('exAudio: Loading audio group "'+string( _audio_group )+'"');
        }
        audio_group_load(_audio_group);
    }

}

// set audio classes (separated by space)
if (argument_count >= 3) {
    
    if (argument[2] != "") {
        
		if (ex_audio_class_count() > 0) {
		
			_audio_classes = argument[2];
			
			// add sound to each class
			var _audio_classes_array = ex_audio_string_split(_audio_classes, " ");
			var _audio_classes_array_size = array_length_1d(_audio_classes_array);
			
			for (var _i=0; _i < _audio_classes_array_size; _i++) {
				if (ex_audio_class_exists(_audio_classes_array[_i])) {
					ex_audio_class_add_sound(_audio_name, _audio_classes_array[_i]);
					if (ex_audio_get_debug_mode()) {
						show_debug_message('exAudio: Added sound "'+string( _audio_name )+'" under audio class "'+_audio_classes_array[_i]+'"');
					}
				} else {
					if (ex_audio_get_debug_mode()) {
						show_debug_message('exAudio: Cannot add sound "'+string( _audio_name )+'" to non-existent class "'+_audio_classes_array[_i]+'", you need to create that class first before adding the sound');
					}
				}
			}
		
		}
        
    }
    
}

// return grid y position
return _autoincrement;


#define ex_audio_pause
///ex_audio_pause(name)

var _name    = argument[0];
var _list    = global._ex_audio_sounds;
var _sound   = -1;
var _emitter = -1;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound resource
_sound = ds_grid_get(_list, 1, _y);

// pause sound and set state
if (audio_system() == audio_new_system) {
    
    ds_grid_set(_list, 14, _y, 1);
    audio_pause_sound(_sound);
    
} else {

    // legacy audio system doesn't support pause, stop instead
    ds_grid_set(_list, 14, _y, 0);
    ds_grid_set(_list, 15, _y, 0);
    sound_stop(_sound);

}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Pausing sound "'+string( _name )+'"');
}


#define ex_audio_pause_all
///ex_audio_pause_all()

var _list       = global._ex_audio_sounds;
var _list_size  = ds_grid_height(_list);

// check if any sounds exist at all
if (ex_audio_count() < 1) {
    if (ex_audio_get_debug_mode()) {
		show_debug_message('exAudio: Warning, no sounds in exAudio database');
	}
	return 0;
}

// loop through all sounds
for (var _i=0; _i < _list_size; _i++) {
    
    var _current_name = ds_grid_get(_list, 0, _i);
    ex_audio_pause(_current_name);
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Paused all sounds');
}


#define ex_audio_play
///ex_audio_play(name, loop)

var _name    = argument[0];
var _list    = global._ex_audio_sounds;
var _sound   = -1;
var _emitter = -1;
var _channel = -1;
var _priority = 0;
var _loop    = false;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound resource
_sound = ds_grid_get(_list, 1, _y);

// get sound emitter
_emitter = ds_grid_get(_list, 2, _y);

// get sound priority
_priority = ds_grid_get(_list, 4, _y);

// get audiogroup
_audiogroup = ds_grid_get(_list, 21, _y);

// get loop
if (argument_count >= 2) {
    _loop = argument[1];
}

// play sound, set loop flag and update channel id
if (audio_system() == audio_new_system) {
    
    if (not audio_group_is_loaded(_audiogroup)) {
        
        if (ex_audio_get_debug_mode()) {
            show_debug_message('exAudio: Error, trying to play sound "'+string( _name )+'", but audio group "'+string( _audiogroup )+'" is not loaded');
        }
        
        return -1;
    }

    _channel = audio_play_sound_on(_emitter, _sound, _loop, _priority);
    ds_grid_set(_list, 20, _y, _channel);
    ds_grid_set(_list, 15, _y, _loop);
    
} else {
    
    if (_loop == true) {
        sound_loop(_sound);
    } else {
        sound_play(_sound);
    }
    
    ds_grid_set(_list, 15, _y, _loop);
    
    // legacy audio system doesn't return channels, so default to -1
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Playing sound "'+string( _name )+'", looping "'+string( _loop )+'"');
}

return _channel;


#define ex_audio_rename
///ex_audio_rename(name, newName)

var _name     = argument[0];
var _new_name = argument[1];
var _list     = global._ex_audio_sounds;


if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Renaming sound with name "'+string( _name )+'" to "'+string( _new_name )+'"');
}

// check name column
var _cy = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _new_name ));
if (_cy >= 0) {
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, cannot rename "'+string( _name )+'" to "'+string( _new_name )+'", name already exists');
    }
    return 0;
}

var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _name ));
if (_y < 0) {
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
    return 0;
}

// set name
ds_grid_set(_list, 0, _y, _new_name);

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Finished renaming sound with name "'+string( _name )+'" to "'+string( _new_name )+'"');
}

return 1;


#define ex_audio_restore_all
///ex_audio_restore_all()

if (audio_system() != audio_new_system) {
    return 0;
}

var _list      = global._ex_audio_sounds;
var _list_size = ds_grid_height(_list);
var _result    = 0;

// check if any sounds exist at all
if (ex_audio_count() < 1) {
    if (ex_audio_get_debug_mode()) {
		show_debug_message('exAudio: Warning, no sounds in exAudio database');
	}
	return 0;
}

// loop through all sounds
for (var _i=0; _i < _list_size; _i++) {
    
    var _current_name = ds_grid_get(_list, 0, _i);
    var _current_sound = ds_grid_get(_list, 1, _i);
    
	if (ds_grid_get(_list, 13, _i) == 1) {
		_result += 1;
	}
	
    if (ds_grid_get(_list, 14, _i) == 0) {
        audio_resume_sound(_current_sound);
        ds_grid_set(_list, 13, _i, 0);
    }
    
}

if (_result > 0) {
	if (ex_audio_get_debug_mode()) {
		show_debug_message('exAudio: Restored all suspended sounds');
	}
}

return 1;


#define ex_audio_resume
///ex_audio_resume(name)

var _name    = argument[0];
var _list    = global._ex_audio_sounds;
var _sound   = -1;
var _emitter = -1;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound resource
_sound = ds_grid_get(_list, 1, _y);

// pause sound and set state
if (audio_system() == audio_new_system) {
    
	if (ds_grid_get(_list, 14, _y) == 0) {
		
		if (ex_audio_get_debug_mode()) {
			show_debug_message('exAudio: Tried to resume sound "'+string( _name )+'", but it is not paused');
		}
		
		return 0;
	} else {
		ds_grid_set(_list, 14, _y, 0);
		audio_resume_sound(_sound);
	}
    
} else {

    // legacy audio system doesn't support resume, play instead
    var _loop = ds_grid_get(_list, 15, _y);
    
    if (_loop == true) {
        sound_loop(_sound);
    } else {
        sound_play(_sound);
    }

}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Resuming sound "'+string( _name )+'"');
}

return 1;


#define ex_audio_resume_all
///ex_audio_resume_all()

var _list       = global._ex_audio_sounds;
var _list_size  = ds_grid_height(_list);

// check if any sounds exist at all
if (ex_audio_count() < 1) {
    if (ex_audio_get_debug_mode()) {
		show_debug_message('exAudio: Warning, no sounds in exAudio database');
	}
	return 0;
}

// loop through all sounds
for (var _i=0; _i < _list_size; _i++) {
    
    var _current_name = ds_grid_get(_list, 0, _i);
    ex_audio_resume(_current_name);
    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Resumed all sounds');
}

return 1;


#define ex_audio_set_channel_number
///ex_audio_set_channel_number(value)

var _channels = argument[0];

if (audio_system() == audio_new_system) {

    audio_channel_num(_channels);
    global._ex_audio_channel_number = _channels;
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Setting channel max number to '+string( _channels )+'');
    }
    
    return 1;
} else {
    return 0;
}


#define ex_audio_set_debug_mode
///ex_audio_set_debug_mode(enabled)

global._ex_audio_debug_mode = argument[0];


#define ex_audio_set_falloff
///ex_audio_set_falloff(name, falloffRef, falloffMax, falloffFactor)

var _name           = argument[0];
var _falloff_ref    = argument[1];
var _falloff_max    = argument[2];
var _falloff_factor = argument[3];
var _list           = global._ex_audio_sounds;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound emitter
var _emitter = ds_grid_get(_list, 2, _y);

audio_emitter_falloff(_emitter, _falloff_ref, _falloff_max, _falloff_factor);

// set falloff
ds_grid_set(_list, 10, _y, _falloff_ref);
ds_grid_set(_list, 11, _y, _falloff_max);
ds_grid_set(_list, 12, _y, _falloff_factor);

return 1;


#define ex_audio_set_falloff_model
///ex_audio_set_falloff_model(falloffModel)

global._ex_audio_falloff_model = argument[0];


#define ex_audio_set_pitch
///ex_audio_set_pitch(name, value, duration, easing)

var _name     = argument[0];
var _pitch    = argument[1];
var _list     = global._ex_audio_sounds;
var _emitter  = -1;
var _time     = 0;
var _ease     = -1;


// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound emitter
_emitter = ds_grid_get(_list, 2, _y);

// destroy exAudio objects if they perform the same operation
with (obj_ex_audio) {
    if (_sound_name == _name and _mode == "pitch") {
        instance_destroy();
    }
}

// set easing
if (argument_count >= 4) {
    _ease = argument[3];
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Setting pitch of sound with name "'+string( _name )+'" to "'+string( _pitch )+'"');
}

// fade in or out
if (argument_count >= 3) {

    _time = argument[2];
    if (_time < 1) {
        _time = 1;
    }

    // create exAudio object to handle fading
    with (instance_create(0, 0, obj_ex_audio)) {
        
        _mode             = "pitch";
        _sound_name       = _name;
        _sound            = ds_grid_get(_list, 1, _y);
        _sound_y          = _y;
        _sound_emitter    = _emitter;
        _value_start      = ex_audio_get_pitch(_name);
        _value_end        = _pitch;
        _duration         = _time;
        _easing           = _ease;
        
        if (ex_audio_get_debug_mode()) {
            show_debug_message('exAudio: Created exAudio instance with ID "'+string( id )+'" to handle pitch fade');
        }
        
        
        return id;
        
    }

} else {

    // instantly set pitch
    if (audio_system() == audio_new_system) {
        audio_emitter_pitch(_emitter, argument[1]);
        ds_grid_set(global._ex_audio_sounds, 6, _y, argument[1]);
        return noone;
    } else {
        sound_volume(_sound, argument[1]);
        ds_grid_set(global._ex_audio_sounds, 6, _y, argument[1]);
        return noone;
    }
    
}


#define ex_audio_set_pitch_all
///ex_audio_set_pitch_all(value, duration, easing)

var _list       = global._ex_audio_sounds;
var _list_size  = ds_grid_height(_list);
var _pitch      = argument[0];
var _duration   = 0;
var _easing     = -1;

// set easing
if (argument_count >= 3) {
    _easing = argument[2];
}

// set duration
if (argument_count >= 2) {
    _duration = argument[1];
}

// check if any sounds exist at all
if (ex_audio_count() < 1) {
    if (ex_audio_get_debug_mode()) {
		show_debug_message('exAudio: Warning, no sounds in exAudio database');
	}
	return 0;
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Setting pitch of all sounds to "'+string( _pitch )+'"');
}

// loop through all sounds
for (var _i=0; _i < _list_size; _i++) {
    
    var _current_name = ds_grid_get(_list, 0, _i);
    
    // set pitch with optional arguments
    if (argument_count >= 3) {
        ex_audio_set_pitch( _current_name, _pitch, _duration, _easing );
    } else if (argument_count >= 2) {
        ex_audio_set_pitch( _current_name, _pitch, _duration);
    } else {
        ex_audio_set_pitch( _current_name, _pitch);    
    }

}


#define ex_audio_set_position
///ex_audio_set_position(name, x, y, z)

var _name       = argument[0];
var _position_x = argument[1];
var _position_y = argument[2];
var _position_z = argument[3];
var _list       = global._ex_audio_sounds;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound emitter
var _emitter = ds_grid_get(_list, 2, _y);

audio_emitter_position(_emitter, _position_x, _position_y, _position_z);

// set position
ds_grid_set(_list, 7, _y, _position_x);
ds_grid_set(_list, 8, _y, _position_y);
ds_grid_set(_list, 9, _y, _position_z);

return 1;


#define ex_audio_set_track_position
///ex_audio_set_track_position(name, position)

var _name     = argument[0];
var _list     = global._ex_audio_sounds;
var _channel  = -1;
var _position = argument[1];

var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound channel
_channel = ds_grid_get(_list, 20, _y);

if (audio_system() == audio_new_system) {
    audio_sound_set_track_position(_channel, _position);
    return 1;
} else {
    return 0;
}


#define ex_audio_set_velocity
///ex_audio_set_velocity(name, velocityX, velocityY, velocityZ)

var _name       = argument[0];
var _velocity_x = argument[1];
var _velocity_y = argument[2];
var _velocity_z = argument[3];
var _list       = global._ex_audio_sounds;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound emitter
var _emitter = ds_grid_get(_list, 2, _y);

audio_emitter_velocity(_emitter, _velocity_x, _velocity_y, _velocity_z);

// set velocity
ds_grid_set(_list, 16, _y, _velocity_x);
ds_grid_set(_list, 17, _y, _velocity_y);
ds_grid_set(_list, 18, _y, _velocity_z);

return 1;


#define ex_audio_set_volume
///ex_audio_set_volume(name, value, duration, easing)

var _name     = argument[0];
var _volume   = argument[1];
var _list     = global._ex_audio_sounds;
var _emitter  = -1;
var _time     = 0;
var _ease     = -1;


// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound emitter
_emitter = ds_grid_get(_list, 2, _y);

// destroy exAudio objects if they perform the same operation
with (obj_ex_audio) {
    if (_sound_name == _name and _mode == "volume") {
        instance_destroy();
    }
}

// set easing
if (argument_count >= 4) {
    _ease = argument[3];
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Setting volume of sound with name "'+string( _name )+'" to "'+string( _volume )+'"');
}

// fade in or out
if (argument_count >= 3) {

    _time = argument[2];
    if (_time < 1) {
        _time = 1;
    }
    
    // create exAudio object to handle fading
    with (instance_create(0, 0, obj_ex_audio)) {
        
        _mode             = "volume";
        _sound_name       = _name;
        _sound            = ds_grid_get(_list, 1, _y);
        _sound_y          = _y;
        _sound_emitter    = _emitter;
        _value_start      = ex_audio_get_volume(_name);
        _value_end        = _volume;
        _duration         = _time;
        _easing           = _ease;
        
        if (ex_audio_get_debug_mode()) {
            show_debug_message('exAudio: Created exAudio instance with ID "'+string( id )+'" to handle volume fade');
        }
        
        
        return id;
        
    }

} else {

    // instantly set volume
    if (audio_system() == audio_new_system) {
        audio_emitter_gain(_emitter, argument[1]);
        ds_grid_set(global._ex_audio_sounds, 5, _y, argument[1]);
        return noone;
    } else {
        sound_volume(_sound, argument[1]);
        ds_grid_set(global._ex_audio_sounds, 5, _y, argument[1]);
        return noone;
    }
    
}


#define ex_audio_set_volume_all
///ex_audio_set_volume_all(value, duration, easing)

var _list       = global._ex_audio_sounds;
var _list_size  = ds_grid_height(_list);
var _volume     = argument[0];
var _duration   = 0;
var _easing     = -1;

// set easing
if (argument_count >= 3) {
    _easing = argument[2];
}

// set duration
if (argument_count >= 2) {
    _duration = argument[1];
}

// check if any sounds exist at all
if (ex_audio_count() < 1) {
    if (ex_audio_get_debug_mode()) {
		show_debug_message('exAudio: Warning, no sounds in exAudio database');
	}
	return 0;
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Setting volume of all sounds to "'+string( _volume )+'"');
}

// loop through all sounds
for (var _i=0; _i < _list_size; _i++) {
    
    var _current_name = ds_grid_get(_list, 0, _i);
    
    // set volume with optional arguments
    if (argument_count >= 3) {
        ex_audio_set_volume( _current_name, _volume, _duration, _easing );
    } else if (argument_count >= 2) {
        ex_audio_set_volume( _current_name, _volume, _duration);
    } else {
        ex_audio_set_volume( _current_name, _volume);    
    }

}


#define ex_audio_stop
///ex_audio_stop(name)

var _name    = argument[0];
var _list    = global._ex_audio_sounds;
var _sound   = -1;
var _channel = -1;

// check name column
var _y = ex_audio_get_index(_name);
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

// get sound resource
_sound = ds_grid_get(_list, 1, _y);

// get sound channel
_channel = ds_grid_get(_list, 20, _y);

// stop sound and reset track position, looping and paused state
ds_grid_set(_list, 14, _y, 0);
ds_grid_set(_list, 15, _y, 0);

if (audio_system() == audio_new_system) {
    
    audio_stop_sound(_sound);
    audio_sound_set_track_position(_channel, 0);
    
} else {

    sound_stop(_sound);

}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Stopping sound "'+string( _name )+'"');
}


#define ex_audio_stop_all
///ex_audio_stop_all()

var _list      = global._ex_audio_sounds;
var _list_size = ds_grid_height(_list);

// check if any sounds exist at all
if (ex_audio_count() < 1) {
    if (ex_audio_get_debug_mode()) {
		show_debug_message('exAudio: Warning, no sounds in exAudio database');
	}
	return 0;
}

// loop through all sounds
for (var _i=0; _i < _list_size; _i++) {
    
    var _current_name = ds_grid_get(_list, 0, _i);
    ex_audio_stop(_current_name);

}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Stopped all sounds');
}


#define ex_audio_string_split
///ex_audio_string_split(string, delimiter)

// for internal use

var _ea_string = argument[0], _ea_delimiter = argument[1];
var _ea_position = string_pos(_ea_delimiter, _ea_string);
var _ea_array;

if (_ea_position == 0) {
    _ea_array[0] = _ea_string; 
    return _ea_array;
}

var _ea_delimiter_length = string_length(_ea_delimiter);
var _ea_array_length = 0;

while (true) {

    _ea_array[_ea_array_length++] = string_copy(_ea_string, 1, _ea_position - 1);
    _ea_string = string_copy(_ea_string, _ea_position + _ea_delimiter_length, string_length(_ea_string) - _ea_position - _ea_delimiter_length + 1);
    _ea_position = string_pos(_ea_delimiter, _ea_string);
    
    if (_ea_position == 0) {
        _ea_array[_ea_array_length] = _ea_string;
        return _ea_array;
    }
}

#define ex_audio_ds_grid_delete_row
///ex_audio_ds_grid_delete_row(grid, row)

// for internal use

var _ea_grid = argument[0];
var _ea_row = argument[1];

var _ea_gw = ds_grid_width(_ea_grid);
var _ea_gh = ds_grid_height(_ea_grid);

ds_grid_set_grid_region(_ea_grid, _ea_grid, 0, _ea_row+1, _ea_gw-1, _ea_row+1, 0, _ea_row);
ds_grid_resize(_ea_grid, _ea_gw, _ea_gh-1);



#define ex_audio_suspend_all
///ex_audio_suspend_all()

if (audio_system() != audio_new_system) {
    return 0;
}

var _list      = global._ex_audio_sounds;
var _list_size = ds_grid_height(_list);

// check if any sounds exist at all
if (ex_audio_count() < 1) {
    if (ex_audio_get_debug_mode()) {
		show_debug_message('exAudio: Warning, no sounds in exAudio database');
	}
	return 0;
}

// loop through all sounds
for (var _i=0; _i < _list_size; _i++) {
    
    var _current_name = ds_grid_get(_list, 0, _i);
    var _current_sound = ds_grid_get(_list, 1, _i);

    if (ds_grid_get(_list, 14, _i) == 0) {
        audio_pause_sound(_current_sound);
        ds_grid_set(_list, 13, _i, 1);
    }

    
}

if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Suspended all sounds');
}


#define ex_audio_unload
///ex_audio_unload(soundName)

var _name          = argument[0];
var _list          = global._ex_audio_sounds;
var _sound         = -1;
var _audiogroup    = -1;
var _audio_emitter = -1;
var _external      = 0;

// check name column
var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _name ));
if (_y < 0) {
	
	if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, could not find sound with name "'+string( _name )+'"');
    }
	
	return 0;
}

ex_audio_stop(_name);

// get resource
_sound = ds_grid_get(_list, 1, _y);

// get emitter
_audio_emitter = ds_grid_get(_list, 2, _y);

// get audiogroup
_audiogroup = ds_grid_get(_list, 21, _y);

// get external
_external = ds_grid_get(_list, 22, _y);

// destroy audio emitter
audio_emitter_free(_audio_emitter);

// remove class index
if (ds_grid_height(_list) < 2) {

	ds_grid_clear(_list, "");
	ds_grid_resize(_list, ds_grid_width(_list), 1);
	
} else {
	ex_audio_ds_grid_delete_row(_list, _y);
}


if (ex_audio_get_debug_mode()) {
    show_debug_message('exAudio: Removed sound with name "'+string( _name )+'"');
}

// check audio groups and unload if not needed anymore
var _gy = ds_grid_value_y(_list, 20, 0, 21, ds_grid_height(_list), _audiogroup);
if (_gy < 0) {
    
    if (_audiogroup != 0 and audio_group_is_loaded(_audiogroup) and _external == 0) {
    
        audio_group_unload(_audiogroup);
        
        if (ex_audio_get_debug_mode()) {
            show_debug_message('exAudio: Unloaded audio group "'+string( _audiogroup )+'" since it is not needed anymore by any sounds');
        }
    
    }
    
}

// check for stream
if (_external == 1) {
    audio_destroy_stream(_sound);
    
    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Destroyed stream of "'+_name+'"');
    }
}

return 1;


#define ex_audio_class_set_position
///ex_audio_class_set_position(className, x, y, z)

var _name = argument[0];
var _position_x = argument[1];
var _position_y = argument[2];
var _position_z = argument[3];
var _list = ex_audio_class_get_index(_name);

if (_list < 0) {

    if (ex_audio_get_debug_mode()) {
        show_debug_message('exAudio: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all sounds in the group
for (var _i=0; _i < _list_size; _i++) {
    
	// get sound emitter
	var _emitter = ds_grid_get(_list, 2, _i);

	audio_emitter_position(_emitter, _position_x, _position_y, _position_z);

	// set position
	ds_grid_set(_list, 7, _i, _position_x);
	ds_grid_set(_list, 8, _i, _position_y);
	ds_grid_set(_list, 9, _i, _position_z);
    
}

return 1;


#define ex_audio_get_name
///ex_audio_get_name(index)

var _sound_index = argument[0];
var _sounds_list = global._ex_audio_sounds;
var _out_name  = "";

if (_sounds_list < 0) {
	return "";
}

if (_sound_index < 0 or _sound_index > ds_grid_height(_sounds_list)) {
    return "";
}

// get sound name
_out_name = ds_grid_get(_sounds_list, 0, _sound_index);

return _out_name;