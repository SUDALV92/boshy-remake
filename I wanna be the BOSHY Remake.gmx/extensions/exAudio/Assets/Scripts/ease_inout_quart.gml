
// arguments: time, start, change, duration

var _arg0 = argument[0] / argument[3] * 0.5;

if (_arg0 < 1) {
    return argument[2] * 0.5 * power(_arg0, 4) + argument[1];
}

return -argument[2] * 0.5 * (power(_arg0 - 2, 4) - 2) + argument[1];