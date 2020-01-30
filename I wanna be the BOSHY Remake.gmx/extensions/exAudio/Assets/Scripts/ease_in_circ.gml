
// arguments: time, start, change, duration

var _arg0 = argument[0] / argument[3];

return argument[2] * (1 - sqrt(1 - _arg0 * _arg0)) + argument[1];