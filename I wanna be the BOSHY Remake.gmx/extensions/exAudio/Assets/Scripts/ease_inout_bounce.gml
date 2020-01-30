
// arguments: time, start, change, duration
if (argument[0] < argument[3] * 0.5) {
    return (ease_in_bounce(argument[0] * 2, 0, argument[2], argument[3]) * 0.5 + argument[1]);
}

return (ease_out_bounce(argument[0] * 2 - argument[3], 0, argument[2], argument[3]) * 0.5 + argument[2] * 0.5 + argument[1]);