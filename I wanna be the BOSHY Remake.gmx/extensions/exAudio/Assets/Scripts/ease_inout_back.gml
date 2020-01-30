
// arguments: time, start, change, duration
var _s = 1.70158;
var _arg0 = argument[0] / argument[3];
_arg0 *= 2;

if ((argument[0]) < 1) {
    _s *= (1.525);
    return argument[2] * 0.5 * (_arg0 * _arg0 * ((_s + 1) * _arg0 - _s)) + argument[1];
}

_arg0 -= 2;
_s *= 1.525;

return argument[2] * 0.5 * ((_arg0) * _arg0 * ((_s + 1) * _arg0 + _s) + 2) + argument[1];