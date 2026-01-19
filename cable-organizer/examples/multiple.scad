include <../utp-cable-organizer.scad>

// Example E1: Multiple cable holders
create_cable_holder_automatically = false;

for(i = [0:2]) {

    // CAREFUL! If using settings_* DIRECTLY as it is global an will be used for all other cable_holder calls even if not passed as parameter!!!
    // Might be better to name the variables differently to avoid confusion
    cables_dia = [[i+2, i+3, i+3, i+2]];
    translate([0, i*50, 0]){
        cable_holder(settings_cables_dia_param=cables_dia);
    };
}
