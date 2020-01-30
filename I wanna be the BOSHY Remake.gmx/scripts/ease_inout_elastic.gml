
// arguments: time, start, change, duration

var _s = 1.70158;
var _p = 0;
var _a = argument[2];

if (argument[0] == 0 or _a == 0) {
    return argument[1];
}

var _arg0 = argument[0] / (argument[3] * 0.5);

if (_arg0 == 2) {
    return argument[1] + argument[2]; 
}

if (!_p) {
    _p = argument[3] * (0.3 * 1.5);
}

if (_a < abs(argument[2])) { 
    _a = argument[2]; 
    _s = _p * 0.25; 
} else {
    _s = _p / (2 * pi) * arcsin(argument[2] / _a);
}

if (_arg0 < 1) {
    return -0.5 * (_a * power(2, 10 * (--_arg0)) * sin((_arg0 * argument[3] - _s) * (2 * pi) / _p)) + argument[1];
}

return _a * power(2, -10 * (--_arg0)) * sin((_arg0 * argument[3] - _s) * (2 * pi) / _p) * 0.5 + argument[2] + argument[1];
