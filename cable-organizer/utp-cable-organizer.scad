$fn = $preview ? 16 : 64;

function add(v, i = 0, r = 0) = i < len(v) ? add(v, i + 1, r + v[i]) : r;

cables_dia_top = [6,6,6,6];
cables_dia_bottom = [1,5.5,5.5,5,5.5,5.5,2];

wall_thickness = 1.2;

//chamfer(){cable_holder(cables_dia_top);}

union(){
    //cable_holder(cables_dia_top, wall_thickness=wall_thickness);
    cable_holder(cables_dia_bottom, mirror_x=true, wall_thickness=wall_thickness, cable_entry_percentage=0.85, center=false);
}

// Center back works only if remove_back is true
// uniform_width - if you mix diameters the ends won't lign up properly -> use this to set the ends to width of the biggest dia
module cable_holder(cables_dia=[6,7,7,6], height=8, wall_thickness=1.6, cable_entry_percentage=0.90, center=true, mirror_x=false, remove_back=true, center_back=true, uniform_width=true ){

num_cables = len(cables_dia);
max_dia = max(cables_dia);
sum_cable = add(cables_dia);
width = sum_cable + (num_cables+1) * wall_thickness;
cum_width = [for(i=0, cum_w=cables_dia[0]/2 + wall_thickness; i < num_cables; i=i+1, cum_w=cum_w + cables_dia[i-1]/2 + cables_dia[i]/2 + wall_thickness) cum_w];

mirror([0,mirror_x == true ? 1 : 0,0]){
translate([center == true ? (-cum_width[num_cables-1]-cables_dia[num_cables-1]/2 - wall_thickness)/2 : 0, remove_back && center_back ? -wall_thickness/2 : 0, 0]){
for(i=[0:num_cables-1]){
    dia = cables_dia[i];
    echo(cum_width[i])
    //translate([cum_width[num_cables-1] + cables_dia[num_cables-1]/2 + wall_thickness , 0, 0]){cube([cables_dia[num_cables-1] + wall_thickness + 0.01, 2*(max_dia + 2*wall_thickness + 0.01), height*2+0.01], center=true);}; // Remove right part of cube
    
    //cube([cables_dia[0] + 2*wall_thickness + 0.01, 2*(cables_dia[0] + 2*wall_thickness + 0.01), height*2+0.01], center=true); // Remove left part of cube
    difference(){
        translate([cum_width[i], cables_dia[i]/2 + wall_thickness, 0]){
            difference(){
                translate([-dia/2 - wall_thickness, -dia/2 - wall_thickness, 0]){cube([dia + 2*wall_thickness, (uniform_width == true ? max_dia : dia) + 2*wall_thickness, height]);};
                cylinder(h=height*3, d=dia, center=true); // Remove center
                translate([-dia*cable_entry_percentage/2, 0, -height]){cube([dia*cable_entry_percentage,max_dia*2,height*2+0.01]);}; // Remove entry
            }
        }
        cube([cables_dia[0] + wall_thickness + 0.01, 2*(cables_dia[0] + 2*wall_thickness + 0.01), height*2+0.01], center=true); // Remove left part of cube
        translate([cum_width[num_cables-1] + cables_dia[num_cables-1]/2 + wall_thickness , 0, 0]){cube([cables_dia[num_cables-1] + wall_thickness + 0.01, 2*(max_dia + 2*wall_thickness + 0.01), height*2+0.01], center=true);}; // Remove right part of cube
        if(remove_back == true) cube([(cum_width[num_cables-1] + cables_dia[num_cables-1]/2 + wall_thickness)*2, wall_thickness, height*3], center=true);
    }

    translate([cum_width[i], cables_dia[i]/2 + wall_thickness, 0]){
        difference(){
            cylinder(h=height, d=dia+2*wall_thickness);
            cylinder(h=height*3, d=dia, center=true); // Remove center
            translate([-dia*cable_entry_percentage/2, 0, -height]){cube([dia*cable_entry_percentage,max_dia*2,height*2+0.01]);}; // Remove entry
        }
    }
}
//extendedEdge(dia=cables_dia[0], length=(uniform_width == true) ? max_dia/2 + wall_thickness : undef, wall_thickness=wall_thickness, cable_entry_percentage=0.85, height=8);
//translate([cum_width[num_cables-1], 0, 0]){
//extendedEdge(dia=cables_dia[num_cables-1], length=(uniform_width == true) ? max_dia/2 + wall_thickness : undef, wall_thickness=wall_thickness, cable_entry_percentage=0.85, height=8, left=false);
//}
}
}
}

mirror([0,1,0]){extendedEdge(dia=2, max_dia=5, wall_thickness=wall_thickness, cable_entry_percentage=0.85, height=8);}
module extendedEdge(dia, max_dia, left=true, wall_thickness, cable_entry_percentage, height){
    x_width = wall_thickness + (1-cable_entry_percentage)*dia/2;
    y_center = dia/2 + wall_thickness;
    y_length = (max_dia == undef) ? (dia + 2*wall_thickness - (dia/2 + wall_thickness)) : max_dia/2 + wall_thickness;
//    translate([(left == true)? 0 : dia + wall_thickness, y_center, 0]){
//        cube([x_width, y_length, height]);
//    }
////    difference(){
////        translate([0, dia/2 + wall_thickness, 0]){cube([wall_thickness + (1-cable_entry_percentage)*dia/2, (length == undef) ? (dia + 2*wall_thickness - (dia/2 + wall_thickness)) : length, height]);}   
////    }
//    
//      difference(){
//        intersection(){
//            translate([(left == true)? 0 : dia + wall_thickness, dia/2 + wall_thickness, 0]){cube([wall_thickness + (1-cable_entry_percentage)*dia/2, (length == undef) ? (dia + 2*wall_thickness - (dia/2 + wall_thickness)) : length, height]);}
//            
//            y_shift = sqrt(pow(dia/2, 2) - pow(dia/2 * cable_entry_percentage, 2));
//            y_center = dia/2 + wall_thickness + y_shift;
//            echo(y_shift);
//            union(){
//                translate([dia/2 + wall_thickness, y_center, -height]) {cylinder(h=height*3, d=dia + 2*wall_thickness);}
//                translate([0, 0, -height]){cube([wall_thickness + (1-cable_entry_percentage)*dia/2, y_center, height*3]);}
//            }
//        }
//        translate([dia/2 + wall_thickness, dia/2 + wall_thickness, -height]) cylinder(h=height*3, d=dia); // Remove center
//    }
//    
//        //translate([dia/2 + wall_thickness, dia/2 + wall_thickness, -height]) cylinder(h=height*3, d=dia); // Remove center
////    difference(){
////        intersection(){
////            translate([0, dia/2 + wall_thickness/2, 0]){cube([wall_thickness + (1-cable_entry_percentage)*dia/2, dia + 2*wall_thickness - (dia/2 + wall_thickness), height]);}
////            
////            y_shift = sqrt(pow(dia/2, 2) - pow(dia/2 * cable_entry_percentage, 2));
////            y_center = dia/2 + wall_thickness + y_shift;
////            echo(y_shift);
////            union(){
////                translate([dia/2 + wall_thickness, y_center, -height]) {cylinder(h=height*3, d=dia + 2*wall_thickness);}
////                translate([0, 0, -height]){cube([wall_thickness + (1-cable_entry_percentage)*dia/2, y_center, height*3]);}
////            }
////        }
////        translate([dia/2 + wall_thickness, dia/2 + wall_thickness/2, -height]) cylinder(h=height*3, d=dia); // Remove center
////    }
}

module chamfer(r=0.1)
{
minkowski(){
    difference(){
        minkowski(){
            difference(){
                minkowski(){children(); sphere(r=0.01);}
                children();
            }
            sphere(r=r);
        }
    }
    sphere(r=r);
}
}
