$fn = $preview ? 16 : 64;

function add(v, i = 0, r = 0) = i < len(v) ? add(v, i + 1, r + v[i]) : r;

function is_numlist(v, i = 0) = is_list(v) && (i < len(v) ? (is_num(v[i]) ? is_numlist(v, i + 1) : false) : true);
function is_undef_or_numlist(v, i = 0) = is_list(v) && (i < len(v) ? (is_num(v[i]) || is_undef(v[i]) ? is_undef_or_numlist(v, i + 1) : false) : true);

// ================================================== CABLE HOLDERS SETTINGS ==================================================
//
// ======================================================== Read this =========================================================
// Every parameter is in mm
// Every parameter can be set as a single value or as a list for every cable holder
// If you use translation and want to unite the cable holders you need to make sure they don't coincide only - they must overlap by some amount (0.01mm should be enough)! If you mirror one cable holder you need to adjust the translation accordingly! By default it is taken in account.
// If you want to create a multiple cable holders and you set some parameters as single values those will be used for all cable holders.
// If you set some parameters as lists and leave some entries as undef those will be replaced by the default values.
//
// ======================================================= Fill this in =======================================================
settings_cables_dia = [[5,5,5,5],[2,5]]; // or just a single list: cables_dia = [5,4,4,5];
settings_height = 8;
settings_wall_thickness = 1.2;
settings_cable_entry_percentage = 0.80;
settings_center = true;
settings_mirror_x = [false, true];
settings_uniform_width = true;
settings_flat_back = true;
settings_flat_front = true;

// settings_translation = [0, 0, 0]; // A vec3 or a list of vec3 for every cable holder
// A additional translation if you want to use the default +- wall_thickness/2 in Y direction and add additional translation on top of that
settings_additional_translation = [undef, [0, 0, 0]]; // A vec3 or a list of vec3 for every cable holder
settings_union = true;
// ==================================================== Advanced features =====================================================
// If you want to set a custom length for every cable holder
//  - a single value
//  - a list of values for every cable holder
//  - a list of lists for every cable in every cable holder
// A 0 is treated as undef - default length will be used
// Please, don't negative values
// Normally the value is: [max_]dia + 2*wall_thickness. Lower values will break the model so they are capped to that minimum.
// Example: settings_length_override = [10, [8, undef]];
settings_length_override = undef;
// ================================================== CABLE HOLDERS SETTINGS ==================================================

// Every parameter is in mm
default_height = 8;
default_wall_thickness = 1.2;
default_entry_percentage = 0.80;
default_center = true;
default_mirror_x = false;
default_uniform_width = true;
default_flat_back = true;
default_flat_front = true;

// default_translation = [0, -wall_thickness/2, 0]; for mirror_x=false
// default_translation = [0, wall_thickness/2, 0]; for mirror_x=true
default_union = true;

cable_holder();

// Needs development version
// cable_holder_settings = object(cables_dia=cables_dia, height=height, wall_thickness=wall_thickness, cable_entry_percentage=cable_entry_percentage, center=center, mirror_x=mirror_x,
//  uniform_width=uniform_width, flat_back=flat_back, flat_front=flat_front, translation=translation, union=union);

// Create cable_holder_single instances based on settings
// module cable_holder(settings=cable_holder_settings){
module cable_holder(){
    echo("Generating cable holders...");
    assert(is_list(settings_cables_dia), "cables_dia must be a list of lists");
    assert(is_undef(settings_translation) || is_list(settings_translation), "translation must be a vec3 or list of vec3");
    num_holders = len(settings_cables_dia);

    // Loop through each cable holder settings and extract parameters from single value or list value or set default if undef
    // => Check if list/single value, check if undef in list, set default if undef
    for (i=[0:num_holders-1]){
        echo(str("Generating cable holder ", i + 1, " of ", num_holders));

        // Or allow single value without list??: cables_dia = is_list(settings_cables_dia[i]) ? settings_cables_dia[i] : [settings_cables_dia[i]];
        cables_dia = settings_cables_dia[i]; assert(is_list(cables_dia), "cables_dia entries must be a list for each cable holder");
        height = is_list(settings_height) ? (settings_height[i] == undef ? default_height : settings_height[i]) : settings_height; assert(is_num(height), "height must be a number");
        wall_thickness = is_list(settings_wall_thickness) ? (settings_wall_thickness[i] == undef ? default_wall_thickness : settings_wall_thickness[i]) : settings_wall_thickness; assert(is_num(wall_thickness), "wall_thickness must be a number");
        cable_entry_percentage = is_list(settings_cable_entry_percentage) ? (settings_cable_entry_percentage[i] == undef ? default_entry_percentage : settings_cable_entry_percentage[i]) : settings_cable_entry_percentage; assert(is_num(cable_entry_percentage), "cable_entry_percentage must be a number");
        center = is_list(settings_center) ? (settings_center[i] == undef ? default_center : settings_center[i]) : settings_center; assert(is_bool(center), "center must be a boolean");
        mirror_x = is_list(settings_mirror_x) ? (settings_mirror_x[i] == undef ? default_mirror_x : settings_mirror_x[i]) : settings_mirror_x; assert(is_bool(mirror_x), "mirror_x must be a boolean");
        uniform_width = is_list(settings_uniform_width) ? (settings_uniform_width[i] == undef ? default_uniform_width : settings_uniform_width[i]) : settings_uniform_width; assert(is_bool(uniform_width), "uniform_width must be a boolean");
        flat_back = is_list(settings_flat_back) ? (settings_flat_back[i] == undef ? default_flat_back : settings_flat_back[i]) : settings_flat_back; assert(is_bool(flat_back), "flat_back must be a boolean");
        flat_front = is_list(settings_flat_front) ? (settings_flat_front[i] == undef ? default_flat_front : settings_flat_front[i]) : settings_flat_front; assert(is_bool(flat_front), "flat_front must be a boolean");

        // Can be a single vec3 or a list of vec3 - a bit messy but works
        translation = is_undef(settings_translation) ? [0, (mirror_x == false ? -1 : 1) * wall_thickness/2, 0] : len(settings_translation) == 3 && is_num(settings_translation[0]) && is_num(settings_translation[1]) && is_num(settings_translation[2]) ? settings_translation : settings_translation[i] == undef ? [0, (mirror_x == false ? -1 : 1) * wall_thickness/2, 0] : settings_translation[i];  assert(is_list(translation) && (len(translation) == 3), "translation must be a vec3 or a list of vec3");
        assert(is_num(translation[0]) && is_num(translation[1]) && is_num(translation[2]), "translation values must be numbers");
        // translation = is_list(settings_translation[i]) ? (settings_translation[i] == undef ? [0, (mirror_x == false ? -1 : 1) * wall_thickness/2, 0] : settings_translation[i]) : settings_translation; assert(is_list(translation) && len(translation) == 3, "translation must be a vec3");
        additional_translation = is_undef(settings_additional_translation) ? [0, 0, 0] : len(settings_additional_translation) == 3 && is_num(settings_additional_translation[0]) && is_num(settings_additional_translation[1]) && is_num(settings_additional_translation[2]) ? settings_additional_translation : settings_additional_translation[i] == undef ? [0, 0, 0] : settings_additional_translation[i];  assert(is_list(translation) && (len(translation) == 3), "additional translation must be a vec3 or a list of vec3");
        assert(is_num(additional_translation[0]) && is_num(additional_translation[1]) && is_num(additional_translation[2]), "additional translation values must be numbers");

        union_flag = is_list(settings_union) ? (settings_union[i] == undef ? default_union : settings_union[i]) : settings_union; assert(is_bool(union_flag), "union must be a boolean");

        // Advanced features
        length_override = is_undef(settings_length_override) || is_num(settings_length_override)? settings_length_override : settings_length_override[i];
        assert(is_undef(length_override) || is_list(length_override) || is_num(length_override), "length_override must be undef/number, a list of undef/numbers or a list of lists of undef/numbers");
        echo(length_override);

        if(union_flag == true) {
            union(){
                translate(translation + additional_translation){
                    cable_holder_single(cables_dia=cables_dia, height=height, wall_thickness=wall_thickness, cable_entry_percentage=cable_entry_percentage, center=center, mirror_x=mirror_x,
                     uniform_width=uniform_width, flat_back=flat_back, flat_front=flat_front, length_override=length_override);
                }
            }
        } else {
            translate(translation + additional_translation){
                cable_holder_single(cables_dia=cables_dia, height=height, wall_thickness=wall_thickness, cable_entry_percentage=cable_entry_percentage, center=center, mirror_x=mirror_x,
                uniform_width=uniform_width, flat_back=flat_back, flat_front=flat_front, length_override=length_override);
            }
        }
    }
}

// uniform_width - if you mix diameters the ends won't lign up properly -> use this to set the ends to width of the biggest dia
module cable_holder_single(cables_dia=[6,7,7,6], height=8, wall_thickness=1.6, cable_entry_percentage=0.80, center=true, mirror_x=false,
 uniform_width=true, flat_back = true, flat_front = true, length_override = undef){

num_cables = len(cables_dia);
max_dia = max(cables_dia);
sum_cable = add(cables_dia);
width = sum_cable + (num_cables+1) * wall_thickness;
cum_width = [for(i=0, cum_w=0; i <= num_cables; i=i+1, cum_w=cum_w + (cables_dia[i-1] == undef ? 0 : cables_dia[i-1]) + wall_thickness) cum_w];

mirror([0,mirror_x == true ? 1 : 0, 0]){
translate([center == true ? -width/2 : 0, 0, 0]){
for(i=[0:num_cables-1]){
    len_override = is_undef(length_override) || is_num(length_override) ? length_override : length_override[i];
    assert(is_undef(len_override) || is_num(len_override), "length_override entries must be undef or numbers for each cable");

    dia = cables_dia[i];
    width_half = wall_thickness + dia/2;
    opening_width = cable_entry_percentage*dia;
    center_y = dia/2 + wall_thickness;
    max_length = max_dia + 2*wall_thickness;
    length = max(is_undef(len_override) || len_override <= 0 ? (uniform_width == true ? max_length : 0) : len_override, dia + 2*wall_thickness);

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
