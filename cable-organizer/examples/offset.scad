include <../utp-cable-organizer.scad>

// Example D1: Double-sided usage with offset cable holder
settings_cables_dia = [[4.5,4.5,4.5,4.5,4.5, 1.5,1.5,1.5],[6,4,6]];
settings_mirror_x = [false,true];
settings_cable_spacing = [[0,0,0,0, 5,2,2], undef];
settings_cable_spacing_length = "b";
// sum(cables_dia[i]) + sum(cable_spacing[j] + wall_thickness) to move last 'i' positions and with 'j' spacers (j = i-1) - if spacer is none use 0 for spacing[j]
settings_translation = [[((3*1.5) + ((5 + default_wall_thickness) + (2 + default_wall_thickness) + (2 + default_wall_thickness)))/2,0,0],[0,0,0]];
