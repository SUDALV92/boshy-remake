
// arguments: time, start, change, duration

var _arg0 = argument[0];

if (argument[3] != 0 and argument[0] != 0) { 
    _arg0 = argument[0] / argument[3];
}

return (-argument[2] * _arg0 * (_arg0 - 2) + argument[1]);