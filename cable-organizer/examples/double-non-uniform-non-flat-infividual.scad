include <../utp-cable-organizer.scad>

// Example B4: Non-uniform length, non-flat_[back|front] cable holder with individual uniform_width settings
// uniform_width only works with flat_front!!!
settings_cables_dia = [[3,2,2,2,5,2],[6,4,6]];
settings_mirror_x = [false,true];
settings_uniform_width = [[true, false, /*undef value == default value*/], true];
settings_flat_back = true;
settings_flat_front = [[false, true, true, true, false, /*undef value == default value*/],true];
