
// arguments: time, start, change, duration

var _arg0 = argument[0] / argument[3];

if (_arg0 < (1 / 2.75)) {
    
    return argument[2] * (7.5625 * _arg0 * _arg0) + argument[1];
    
} else if (_arg0 < (2 / 2.75)) {
    
    _arg0 -= (1.5 / 2.75);
    return argument[2] * (7.5625 * _arg0 * _arg0 + 0.75) + argument[1];
    
} else if (_arg0 < (2.5 / 2.75)) {

    _arg0 -= (2.25 / 2.75);
    return argument[2] * (7.5625 * _arg0 * _arg0 + 0.9375) + argument[1];
    
} else {

    _arg0 -= ( 2.625 / 2.75 );
    return argument[2] * (7.5625 * _arg0 * _arg0 + 0.984375) + argument[1];
    
}
