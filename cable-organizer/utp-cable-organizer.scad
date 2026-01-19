$fn = $preview ? 16 : 64;

function add(v, i = 0, r = 0) = i < len(v) ? add(v, i + 1, r + v[i]) : r;

wall_thickness = 1.2;

// // TOP cables
// cables_dia_top = [6,6,6,6];
// cables_dia_bottom = [3,5,5.5,5.5,5.5,5];
// union(){
//     translate([0, -wall_thickness/2, 0]){cable_holder(cables_dia_top, wall_thickness=wall_thickness);}
//     translate([-(cables_dia_bottom[0] + wall_thickness)/2, wall_thickness/2, 0]){cable_holder(cables_dia_bottom, mirror_x=true, wall_thickness=wall_thickness, cable_entry_percentage=0.80, center=true, uniform_width=true);}
// }

cables_dia_top = [5,5,5,5,5];
// cables_dia_bottom = [5,5,5];

union(){
    translate([0, -wall_thickness/2, 0]){cable_holder(cables_dia_top, wall_thickness=wall_thickness);}
    translate([0, wall_thickness/2, 0]){cable_holder(cables_dia_bottom, mirror_x=true, wall_thickness=wall_thickness, cable_entry_percentage=0.80, center=true, uniform_width=true);}
}

// double_cable_holder(cables_dia_top, wall_thickness=wall_thickness);

// module double_cable_holder(cables_dia_top, cables_dia_bottom, wall_thickness=1.6){
//     union(){
//         translate([0, -wall_thickness/2, 0]){cable_holder(cables_dia_top, wall_thickness=wall_thickness);}
//         translate([0, wall_thickness/2, 0]){cable_holder(cables_dia_bottom, mirror_x=true, wall_thickness=wall_thickness);}
//     }
// }

// uniform_width - if you mix diameters the ends won't lign up properly -> use this to set the ends to width of the biggest dia
module cable_holder(cables_dia=[6,7,7,6], height=8, wall_thickness=1.6, cable_entry_percentage=0.80, center=true, mirror_x=false,
 uniform_width=true, flat_back = true, flat_front = true){

num_cables = len(cables_dia);
max_dia = max(cables_dia);
sum_cable = add(cables_dia);
width = sum_cable + (num_cables+1) * wall_thickness;
cum_width = [for(i=0, cum_w=0; i <= num_cables; i=i+1, cum_w=cum_w + (cables_dia[i-1] == undef ? 0 : cables_dia[i-1]) + wall_thickness) cum_w];

mirror([0,mirror_x == true ? 1 : 0, 0]){
translate([center == true ? -width/2 : 0, 0, 0]){
for(i=[0:num_cables-1]){
    dia = cables_dia[i];
    width_half = wall_thickness + dia/2;
    opening_width = cable_entry_percentage*dia;
    center_y = dia/2 + wall_thickness;
    max_length = max_dia + 2*wall_thickness;
    length = (uniform_width == true ? max_length : dia + 2*wall_thickness);

    prev_dia = (i == 0) ? 0 : cables_dia[i-1];
    next_dia = (i == num_cables-1) ? 0 : cables_dia[i+1];

    difference(){
        union(){
            // Back left part
            difference(){
                if(flat_back == true && i != 0) {
                    translate([cum_width[i], 0, 0]){cube([width_half, length/2, height], center=false);}
                } else {
                    translate([cum_width[i] + width_half, center_y, 0]){cylinder(h=height, d=dia+2*wall_thickness);};
                }
                translate([cum_width[i] + width_half, center_y, -height]){cylinder(h=height*3, d=dia);};
            } // Back left part

            // Back right part
            difference(){
                if(flat_back == true && i != num_cables-1) {
                    translate([cum_width[i] + width_half, 0, 0]){cube([width_half, length/2, height], center=false);}
                } else {
                    translate([cum_width[i] + width_half, center_y, 0]){cylinder(h=height, d=dia+2*wall_thickness);};
                }
                translate([cum_width[i] + width_half, center_y, -height]){cylinder(h=height*3, d=dia);};
            } // Back right part

            // Front left part
            intersection(){
                difference(){
                    translate([cum_width[i], center_y, 0]){cube([width_half, length - dia/2 - wall_thickness, height], center=false);}
                    translate([cum_width[i] + width_half, center_y, -height]){cylinder(h=height*3, d=dia);};
                } // Front left part
                if(flat_front == true) {
                    if(i == 0){
                        translate([cum_width[i] + width_half, length - width_half, 0]){cylinder(h=height, d=dia+2*wall_thickness);}
                        translate([cum_width[i], 0, 0]){cube([width_half, length - dia/2 - wall_thickness, height], center=false);}
                    } else {
                        translate([cum_width[i], 0, 0]){cube([width_half, length, height], center=false);}
                    }
                } else {
                    translate([cum_width[i] + width_half, center_y, -height]){cylinder(h=height*3, d=dia + 2*wall_thickness);};
                }
            }

            // Front right part
            intersection(){
                difference(){
                    translate([cum_width[i] + width_half, center_y, 0]){cube([width_half, length - dia/2 - wall_thickness, height], center=false);}
                    translate([cum_width[i] + width_half, center_y, -height]){cylinder(h=height*3, d=dia);};
                } // Front right part
                if(flat_front == true) {
                    if(i == num_cables-1){
                        translate([cum_width[i] + width_half, length - width_half, 0]){cylinder(h=height, d=dia+2*wall_thickness);}
                        translate([cum_width[i] + width_half, 0, 0]){cube([width_half, length - dia/2 - wall_thickness, height], center=false);}
                    } else {
                        translate([cum_width[i] + width_half, 0, 0]){cube([width_half, length, height], center=false);}
                    }
                } else {
                    translate([cum_width[i] + width_half, center_y, -height]){cylinder(h=height*3, d=dia + 2*wall_thickness);};
                }
            }
        }

        // Cut opening
        translate([cum_width[i] + width_half, dia/2 + wall_thickness + max_length/2, 0]){cube([opening_width, max_length, height*3], center=true);}

        // Cut Front Chamfer
        for(j=[-1:1]){
            if(i + j >= 0 && i + j < num_cables) {
                translate([cum_width[i] + width_half - j*(dia + wall_thickness/2), length, height])
                {
                    rotate(a=45, v=[0, 0, 1])
                    {
                        w = (dia) / sqrt(2);
                        cube([w, w, height*3], center=true);
                    }
                }
            }
        }

        // Cut Top/Bottom Chamfer
        for(j=[0, 1]){
            translate([cum_width[i] + width_half, dia/2 + wall_thickness + max_length/2, j*height])
            {
                rotate(a=45, v=[0, 1, 0])
                {
                    w = (dia) / sqrt(2);
                    cube([w, length, w], center=true);
                }
            }
        }
    }

}
}
}
}
