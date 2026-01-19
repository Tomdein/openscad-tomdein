include <../utp-cable-organizer.scad>

// Example E2: Multiple cable holders
create_cable_holder_automatically = false;

for(k = [2,3,4,5]){
    for(i = [0:3]) {
        // CAREFUL! If using settings_* DIRECTLY as it is global an will be used for all other cable_holder calls even if not passed as parameter!!!
        // Might be better to name the variables differently to avoid confusion
        cables_dia = [[for(j = [0:i+3]) k]];
        translate([75*(k-3.5), i*50, 0]){
            cable_holder(settings_cables_dia_param=cables_dia);
        };
    }
}