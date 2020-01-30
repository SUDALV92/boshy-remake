
// arguments: time, start, change, duration

var _arg0 = argument[0] / argument[3] * 0.5;

if (_arg0 < 1) {
    return argument[2] * 0.5 * (1 - sqrt(1 - _arg0 * _arg0)) + argument[1];
}

_arg0 -= 2;
return argument[2] * 0.5 * (sqrt(1 - _arg0 * _arg0) + 1) + argument[1];
