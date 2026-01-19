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
// <=====
settings_cables_dia = [[4.5,4.5,4.5,4.5,4.5,1.5,1.5,1.5,1.5]]; // or just a single list: cables_dia = [5,4,4,5];
// settings_height = 8;
// settings_wall_thickness = 1.2;
// settings_cable_entry_percentage = 0.80;
// settings_center = true;
// settings_mirror_x = [false, true];
// settings_uniform_width = true;
// settings_flat_back = true;
// settings_flat_front = true;
// <=====

// settings_translation = [0, 0, 0]; // A vec3 or a list of vec3 for every cable holder
// To offset last N cable holders out as you would 'glue' them to the side do the following:
// for dia = [4.5,4.5,4.5,4.5,4.5,2,2,2,2] where we want the last 4 2mm cables to be offset:
// set the x translation to the [(2+2+2+2) + (spacer1, spacer2, spacer3) + wall_thickness]/2 - using any spacers if you used them
// that is: (N*dia + sum_of_N-1_spacers + wall_thickness)/2

// <=====
// settings_additional_translation = [undef, [(4*1.5 + 3*(2+settings_wall_thickness) + settings_wall_thickness)/2, 0, 0]]; // A vec3 or a list of vec3 for every cable holder
// settings_union = true;
// <=====

// ==================================================== Advanced features =====================================================
// If you want to set a custom length for every cable holder
//  - a single value
//  - a list of values for every cable holder
//  - a list of lists for every cable in every cable holder
// A 0 is treated as undef - default length will be used
// Please, don't negative values
// Normally the value is: [max_]dia + 2*wall_thickness. Lower values will break the model so they are capped to that minimum.
// Example: settings_length_override = [10, [8, undef]];

// <=====
// settings_length_override = undef;
// <=====

// If you want to set a custom cable_entry_percentage for every cable holder
//  - a single value
//  - a list of values for every cable holder
//  - a list of lists for every cable in every cable holder
// A 0 or negative number is treated as undef - default_cable_entry_percentage will be used
// Example: settings_length_override = [undef, [0.50, undef]];

// <=====
// settings_cable_entry_percentage_override = undef;
// <=====

// If you want to add spacings between cables
//  - a single value
//  - a list of values for every cable holder
//  - a list of lists for every cable in every cable holder
// A 0 or negative number is treated as undef - no effect here
// One wall_thickness is overlapped so you might want to add +wall_thickness
// Example: settings_length_override = [undef, [0.50, undef]];
// settings_cable_spacing = [undef, [undef,undef,undef,undef,undef,2,2,2]];
// The same as above but in either a undef/0 or length in mm or 'w' as wall (fill all) or 'b' only back (fill just the back part) or 'c' that connects the middles of the cables

// <=====
// settings_cable_spacing_length = "w";
// <=====

// If undef uses wall_thickness.
// Only used for "c" option above.
// As usual can be a single value or a list or list of values for every cable holder.
// Best used with flat_back=false

// <=====
// settings_webbing_wall_thickness = 1.5 * settings_wall_thickness;
// <=====

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

create_cable_holder_automatically = true;
if(create_cable_holder_automatically == true){
    cable_holder();
}

// Needs development version
// cable_holder_settings = object(cables_dia=cables_dia, height=height, wall_thickness=wall_thickness, cable_entry_percentage=cable_entry_percentage, center=center, mirror_x=mirror_x,
//  uniform_width=uniform_width, flat_back=flat_back, flat_front=flat_front, translation=translation, union=union);

// Create cable_holder_single instances based on settings
// module cable_holder(settings=cable_holder_settings){
module cable_holder(
    settings_cables_dia_param,
    settings_height_param = undef,
    settings_wall_thickness_param = undef,
    settings_cable_entry_percentage_param = undef,
    settings_center_param = undef,
    settings_mirror_x_param = undef,
    settings_uniform_width_param = undef,
    settings_flat_back_param = undef,
    settings_flat_front_param = undef,
    settings_translation_param = undef,
    settings_additional_translation_param = undef,
    settings_union_param = undef,
    // Advanced features:
    settings_length_override_param = undef,
    settings_cable_entry_percentage_override_param = undef,
    settings_cable_spacing_param = undef,
    settings_cable_spacing_length_param = undef,
    settings_webbing_wall_thickness_param = undef
){
    // Use either passed parameters or global settings
    settings_cables_dia = is_undef(settings_cables_dia_param) ? settings_cables_dia : settings_cables_dia_param; if(is_undef(settings_cables_dia_param)){echo("Using global settings_cables_dia");}
    settings_height = is_undef(settings_height_param) ? is_undef(settings_height) ? undef : settings_height : settings_height_param; if(is_undef(settings_height_param)){echo("Using global or default settings_height");}
    settings_wall_thickness = is_undef(settings_wall_thickness_param) ? is_undef(settings_wall_thickness) ? undef : settings_wall_thickness : settings_wall_thickness_param; if(is_undef(settings_wall_thickness_param)){echo("Using global or default settings_wall_thickness");}
    settings_cable_entry_percentage = is_undef(settings_cable_entry_percentage_param) ? is_undef(settings_cable_entry_percentage) ? undef : settings_cable_entry_percentage : settings_cable_entry_percentage_param; if(is_undef(settings_cable_entry_percentage_param)){echo("Using global or default settings_cable_entry_percentage");}
    settings_center = is_undef(settings_center_param) ? is_undef(settings_center) ? undef : settings_center : settings_center_param; if(is_undef(settings_center_param)){echo("Using global or default settings_center");}
    settings_mirror_x = is_undef(settings_mirror_x_param) ? is_undef(settings_mirror_x) ? undef : settings_mirror_x : settings_mirror_x_param; if(is_undef(settings_mirror_x_param)){echo("Using global or default settings_mirror_x");}
    settings_uniform_width = is_undef(settings_uniform_width_param) ? is_undef(settings_uniform_width) ? undef : settings_uniform_width : settings_uniform_width_param; if(is_undef(settings_uniform_width_param)){echo("Using global or default settings_uniform_width");}
    settings_flat_back = is_undef(settings_flat_back_param) ? is_undef(settings_flat_back) ? undef : settings_flat_back : settings_flat_back_param; if(is_undef(settings_flat_back_param)){echo("Using global or default settings_flat_back");}
    settings_flat_front = is_undef(settings_flat_front_param) ? is_undef(settings_flat_front) ? undef : settings_flat_front : settings_flat_front_param; if(is_undef(settings_flat_front_param)){echo("Using global or default settings_flat_front");}
    settings_translation = is_undef(settings_translation_param) ? is_undef(settings_translation) ? undef : settings_translation : settings_translation_param; if(is_undef(settings_translation_param)){echo("Using global or default settings_translation");}
    settings_additional_translation = is_undef(settings_additional_translation_param) ? is_undef(settings_additional_translation) ? undef : settings_additional_translation : settings_additional_translation_param; if(is_undef(settings_additional_translation_param)){echo("Using global or default settings_additional_translation");}
    settings_union = is_undef(settings_union_param) ? is_undef(settings_union) ? undef : settings_union : settings_union_param; if(is_undef(settings_union_param)){echo("Using global or default settings_union");}
    // Advanced features:
    settings_length_override = is_undef(settings_length_override_param) ? is_undef(settings_length_override) ? undef : settings_length_override : settings_length_override_param; if(is_undef(settings_length_override_param)){echo("Using global or default settings_length_override");}
    settings_cable_entry_percentage_override = is_undef(settings_cable_entry_percentage_override_param) ? is_undef(settings_cable_entry_percentage_override) ? undef : settings_cable_entry_percentage_override : settings_cable_entry_percentage_override_param; if(is_undef(settings_cable_entry_percentage_override_param)){echo("Using global or default settings_cable_entry_percentage_override");}
    settings_cable_spacing = is_undef(settings_cable_spacing_param) ? is_undef(settings_cable_spacing) ? undef : settings_cable_spacing : settings_cable_spacing_param; if(is_undef(settings_cable_spacing_param)){echo("Using global or default settings_cable_spacing");}
    settings_cable_spacing_length = is_undef(settings_cable_spacing_length_param) ? is_undef(settings_cable_spacing_length) ? undef : settings_cable_spacing_length : settings_cable_spacing_length_param; if(is_undef(settings_cable_spacing_length_param)){echo("Using global or default settings_cable_spacing_length");}
    settings_webbing_wall_thickness = is_undef(settings_webbing_wall_thickness_param) ? is_undef(settings_webbing_wall_thickness) ? undef : settings_webbing_wall_thickness : settings_webbing_wall_thickness_param; if(is_undef(settings_webbing_wall_thickness_param)){echo("Using global or default settings_webbing_wall_thickness");}

    // Create cable holders
    echo("Generating cable holders...");
    assert(is_list(settings_cables_dia) && min([for (holder_cables_dia = settings_cables_dia) is_list(holder_cables_dia) == true ? 1 : 0]), "cables_dia must be a list of lists");
    assert(is_undef(settings_translation) || is_list(settings_translation), "translation must be a vec3 or list of vec3");
    num_holders = len(settings_cables_dia);

    // Loop through each cable holder settings and extract parameters from single value or list value or set default if undef
    // => Check if list/single value, check if undef in list, set default if undef
    for (i=[0:num_holders-1]){
        echo(str("Generating cable holder ", i + 1, " of ", num_holders));

        // Or allow single value without list??: cables_dia = is_list(settings_cables_dia[i]) ? settings_cables_dia[i] : [settings_cables_dia[i]];
        cables_dia = settings_cables_dia[i]; assert(is_list(cables_dia), "cables_dia entries must be a list for each cable holder");
        height = is_undef(settings_height) ? default_height : is_list(settings_height) ? (settings_height[i] == undef ? default_height : settings_height[i]) : settings_height; assert(is_num(height) || is_list(height), "height must be a number or a list");
        wall_thickness = is_undef(settings_wall_thickness) ? default_wall_thickness : is_list(settings_wall_thickness) ? (settings_wall_thickness[i] == undef ? default_wall_thickness : settings_wall_thickness[i]) : settings_wall_thickness; assert(is_num(wall_thickness), "wall_thickness must be a number");
        cable_entry_percentage = is_undef(settings_cable_entry_percentage) ? default_entry_percentage : is_list(settings_cable_entry_percentage) ? (settings_cable_entry_percentage[i] == undef ? default_entry_percentage : settings_cable_entry_percentage[i]) : settings_cable_entry_percentage; assert(is_num(cable_entry_percentage), "cable_entry_percentage must be a number");
        center = is_undef(settings_center) ? default_center : is_list(settings_center) ? (settings_center[i] == undef ? default_center : settings_center[i]) : settings_center; assert(is_bool(center), "center must be a boolean");
        mirror_x = is_undef(settings_mirror_x) ? default_mirror_x : is_list(settings_mirror_x) ? (settings_mirror_x[i] == undef ? default_mirror_x : settings_mirror_x[i]) : settings_mirror_x; assert(is_bool(mirror_x), "mirror_x must be a boolean");
        uniform_width = is_undef(settings_uniform_width) ? default_uniform_width : is_list(settings_uniform_width) ? (settings_uniform_width[i] == undef ? default_uniform_width : settings_uniform_width[i]) : settings_uniform_width; assert(is_bool(uniform_width) || is_list(uniform_width), "uniform_width must be a boolean or a list");
        flat_back = is_undef(settings_flat_back) ? default_flat_back : is_list(settings_flat_back) ? (settings_flat_back[i] == undef ? default_flat_back : settings_flat_back[i]) : settings_flat_back; assert(is_bool(flat_back), "flat_back must be a boolean");
        flat_front = is_undef(settings_flat_front) ? default_flat_front : is_list(settings_flat_front) ? (settings_flat_front[i] == undef ? default_flat_front : settings_flat_front[i]) : settings_flat_front; assert(is_bool(flat_front) || is_list(flat_front), "flat_front must be a boolean or a list");

        // Can be a single vec3 or a list of vec3 - a bit messy but works
        translation = is_undef(settings_translation) ? [0, (mirror_x == false ? -1 : 1) * wall_thickness/2, 0] : len(settings_translation) == 3 && is_num(settings_translation[0]) && is_num(settings_translation[1]) && is_num(settings_translation[2]) ? settings_translation : settings_translation[i] == undef ? [0, (mirror_x == false ? -1 : 1) * wall_thickness/2, 0] : settings_translation[i];  assert(is_list(translation) && (len(translation) == 3), "translation must be a vec3 or a list of vec3");
        assert(is_num(translation[0]) && is_num(translation[1]) && is_num(translation[2]), "translation values must be numbers");
        // translation = is_list(settings_translation[i]) ? (settings_translation[i] == undef ? [0, (mirror_x == false ? -1 : 1) * wall_thickness/2, 0] : settings_translation[i]) : settings_translation; assert(is_list(translation) && len(translation) == 3, "translation must be a vec3");
        additional_translation = is_undef(settings_additional_translation) ? [0, 0, 0] : len(settings_additional_translation) == 3 && is_num(settings_additional_translation[0]) && is_num(settings_additional_translation[1]) && is_num(settings_additional_translation[2]) ? settings_additional_translation : settings_additional_translation[i] == undef ? [0, 0, 0] : settings_additional_translation[i];  assert(is_list(translation) && (len(translation) == 3), "additional translation must be a vec3 or a list of vec3");
        assert(is_num(additional_translation[0]) && is_num(additional_translation[1]) && is_num(additional_translation[2]), "additional translation values must be numbers");

        union_flag = is_undef(settings_union) ? default_union : is_list(settings_union) ? (settings_union[i] == undef ? default_union : settings_union[i]) : settings_union; assert(is_bool(union_flag), "union must be a boolean");

        // Advanced features
        length_override = is_undef(settings_length_override) ? undef : is_num(settings_length_override)? settings_length_override : settings_length_override[i];
        assert(is_undef(length_override) || is_list(length_override) || is_num(length_override), "length_override must be undef/number, a list of undef/numbers or a list of lists of undef/numbers");

        cable_entry_percentage_override = is_undef(settings_cable_entry_percentage_override) ? undef : is_num(settings_cable_entry_percentage_override)? settings_cable_entry_percentage_override : settings_cable_entry_percentage_override[i];
        assert(is_undef(cable_entry_percentage_override) || is_list(cable_entry_percentage_override) || is_num(cable_entry_percentage_override), "cable_entry_percentage_override must be undef/number, a list of undef/numbers or a list of lists of undef/numbers");

        cable_spacing = is_undef(settings_cable_spacing) ? undef : is_num(settings_cable_spacing) ? settings_cable_spacing : settings_cable_spacing[i];
        cable_spacing_length = is_undef(settings_cable_spacing_length) ? undef : is_num(settings_cable_spacing_length) || is_string(settings_cable_spacing_length) ? settings_cable_spacing_length : settings_cable_spacing_length[i];
        webbing_wall_thickness = is_undef(settings_webbing_wall_thickness) ? undef : is_num(settings_webbing_wall_thickness) ? settings_webbing_wall_thickness : settings_webbing_wall_thickness[i];

        if(union_flag == true) {
            union(){
                translate(translation + additional_translation){
                    cable_holder_single(cables_dia=cables_dia, heights=height, wall_thickness=wall_thickness, cable_entry_percentage=cable_entry_percentage, center=center, mirror_x=mirror_x,
                     uniform_width=uniform_width, flat_back=flat_back, flat_fronts=flat_front,
                     length_override=length_override, cable_entry_percentage_override=cable_entry_percentage_override,
                     cable_spacing=cable_spacing, cable_spacing_length=cable_spacing_length, webbing_wall_thickness=webbing_wall_thickness);
                }
            }
        } else {
            translate(translation + additional_translation){
                cable_holder_single(cables_dia=cables_dia, heights=height, wall_thickness=wall_thickness, cable_entry_percentage=cable_entry_percentage, center=center, mirror_x=mirror_x,
                uniform_width=uniform_width, flat_back=flat_back, flat_fronts=flat_front,
                length_override=length_override, cable_entry_percentage_override=cable_entry_percentage_override,
                cable_spacing=cable_spacing, cable_spacing_length=cable_spacing_length, webbing_wall_thickness=webbing_wall_thickness);
            }
        }
    }
}

// uniform_width - if you mix diameters the ends won't lign up properly -> use this to set the ends to width of the biggest dia
module cable_holder_single(cables_dia=[6,7,7,6], heights=8, wall_thickness=1.6, cable_entry_percentage=0.80, center=true, mirror_x=false,
 uniform_width=true, flat_back = true, flat_fronts = true,
 // Advanced features:
 length_override = undef,
 cable_entry_percentage_override = undef,
 cable_spacing = undef, cable_spacing_length = undef, webbing_wall_thickness = undef){

num_cables = len(cables_dia);
max_dia = max(cables_dia);
sum_cable = add(cables_dia);
width = sum_cable + (num_cables+1) * wall_thickness;
heights = [for(i=[0:num_cables-1])
    (
        is_list(heights) ? (is_undef(heights[i]) ? default_height : heights[i]) : heights
    )
];
// height = is_list(heights) ? (is_undef(heights[i]) ? default_height : heights[i]) : heights; assert(is_num(height), "height must be a number");

cable_spacing_values = [for(i=0; i < num_cables - 1; i=i+1)
    (
        is_undef(cable_spacing) || (is_num(cable_spacing) && cable_spacing <= 0) ? 0 :
        is_num(cable_spacing) ? cable_spacing :
        is_list(cable_spacing) ?
            (
                is_undef(cable_spacing[i]) || (is_num(cable_spacing[i]) && cable_spacing[i] <= 0) ? 0 :
                is_num(cable_spacing[i]) ? cable_spacing[i] : undef
            )
        : undef
    )
];

cable_spacing_length_values = [for(i=[0:num_cables-2])
    (
        is_undef(cable_spacing_length) || (is_num(cable_spacing_length) && cable_spacing_length <= 0) ? 0 :
        is_string(cable_spacing_length) ? cable_spacing_length :
        is_num(cable_spacing_length) ? cable_spacing_length :
        is_list(cable_spacing_length) ?
            (
                is_undef(cable_spacing_length[i]) || (is_num(cable_spacing_length[i]) && cable_spacing_length[i] <= 0) ? 0 :
                is_string(cable_spacing_length[i]) ? cable_spacing_length[i] :
                is_num(cable_spacing_length[i]) ? cable_spacing_length[i] : undef
            )
        : undef
    )
];

for(i=[0:num_cables-1]){
    assert(is_num(cables_dia[i]), "cables_dia entries must be numbers for each cable");
    assert(cables_dia[i] > 0, "cables_dia entries must be positive numbers for each cable");

    if(i < num_cables - 1){
        assert(is_num(cable_spacing_values[i]), "cable_spacing entries must be numbers for each cable");
        assert(is_num(cable_spacing_length_values[i]) || cable_spacing_length_values[i] == "w" || cable_spacing_length_values[i] == "b" || cable_spacing_length_values[i] == "c", "cable_spacing entries must be undef or numbers or 'w' or 'b' or 'c' for each cable");
    }
}



cum_width = [for(i=0, cum_w=0; i <= num_cables; i=i+1, cum_w=cum_w + (cables_dia[i-1] == undef ? 0 : cables_dia[i-1]) + (cable_spacing_values[i-1] == undef ? 0 : cable_spacing_values[i-1]) + wall_thickness) cum_w];
max_length = max_dia + 2*wall_thickness;

// Precalculate values so I can search forward and backward when chamfering
len_overrides = [for(i=[0:num_cables-1]) is_undef(length_override) || is_num(length_override) ? length_override : length_override[i]];
for(i=[0:num_cables-1]){assert(is_undef(len_override) || is_num(len_override), "length_override entries must be undef or numbers for each cable");}
lengths = [for(i=[0:num_cables-1])
    max(is_undef(len_overrides[i]) || len_overrides[i] <= 0 ? (is_list(uniform_width) ? (uniform_width[i] == true ? max_length : 0) : (uniform_width == true ? max_length : 0)) : len_overrides[i], cables_dia[i] + 2*wall_thickness)
];
spacer_widths = [for(i=[0:num_cables-2]) cable_spacing_values[i] == undef ? 0 : cable_spacing_values[i]];
spacer_lengths = [for(i=[0:num_cables-2]) cable_spacing_length_values[i] == "c" ? 0 : cable_spacing_length_values[i] == "w" ? lengths[i] : cable_spacing_length_values[i] == "b" ? wall_thickness : cable_spacing_length_values[i]];

mirror([0,mirror_x == true ? 1 : 0, 0]){
translate([center == true ? - cum_width[num_cables]/2 - wall_thickness/2 : 0, 0, 0]){
for(i=[0:num_cables-1]){
    cable_entry_perc_override = is_undef(cable_entry_percentage_override) ? undef : is_num(cable_entry_percentage_override) ? cable_entry_percentage_override <= 0 ? undef : cable_entry_percentage_override : cable_entry_percentage_override[i];
    assert(is_undef(cable_entry_perc_override) || is_num(cable_entry_perc_override), "cable_entry_percentage_override entries must be undef or numbers for each cable");

    dia = cables_dia[i];
    height = heights[i]; assert(is_num(height), "height must be a number");
    width_half = wall_thickness + dia/2;
    opening_width = is_undef(cable_entry_perc_override) ? cable_entry_percentage * dia : cable_entry_perc_override * dia;
    flat_front = is_list(flat_fronts) ? (is_undef(flat_fronts[i]) ? default_flat_front : flat_fronts[i]) : (is_undef(flat_fronts) ? default_flat_front : flat_fronts); assert(is_bool(flat_front), "flat_front must be a boolean");

    center_y = dia/2 + wall_thickness;
    length = lengths[i];

    spacer_width = spacer_widths[i];
    spacer_length = spacer_lengths[i];
    spacer_length_prev = i == 0 ? 0 : spacer_lengths[i-1];

    webbing_wall_thickness = is_undef(webbing_wall_thickness) || (is_num(webbing_wall_thickness) && webbing_wall_thickness <= 0) ? wall_thickness : is_num(webbing_wall_thickness) ? webbing_wall_thickness : webbing_wall_thickness[i];

    union(){
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
            translate([cum_width[i] + width_half, dia/2 + wall_thickness + length/2, 0]){cube([opening_width, length, height*3], center=true);}

            // Cut Front Chamfer
            for(j=[-1:1]){
                if(i + j >= 0 && i + j < num_cables) {
                    // Avoid cutting if spacer is longer than cable holder length
                    if((j != 1 || length > spacer_length) && (j != -1 || length > spacer_length_prev)){
                    difference(){
                        translate([cum_width[i] + width_half + j*(dia + wall_thickness/2), length, height])
                        {
                            rotate(a=45, v=[0, 0, 1])
                            {
                                w = (dia) / sqrt(2);
                                cube([w, w, height*3], center=true);
                            }
                        }
                    }
                    }
                }
            }

            // Cut Top/Bottom Chamfer
            for(j=[0, 1]){
                translate([cum_width[i] + width_half, dia/2 + wall_thickness + length/2, j*height])
                {
                    rotate(a=45, v=[0, 1, 0])
                    {
                        w = (dia) / sqrt(2);
                        cube([w, length, w], center=true);
                    }
                }
            }
        }

        // Add Spacer between cables
        if(i < num_cables - 1 && spacer_width > 0){
            // If heights differ use the lower one
            height = heights[i] > heights[i+1] ? heights[i+1] : heights[i];

            // "c" option - connect the middles of the cables - a webbing
            if(cable_spacing_length_values[i] == "c"){
                x_start = cum_width[i] + width_half*2 - wall_thickness;
                y_start = dia/2 + wall_thickness;
                x_end = cum_width[i+1] + wall_thickness;
                y_end = cables_dia[i+1]/2 + wall_thickness;
                // x_delta = x_end - x_start;
                // y_delta = y_end - y_start;

                wh = webbing_wall_thickness/2;
                CubePoints = [
                [ x_start,  y_start - wh,  0 ],  //0
                [ x_start,  y_start + wh,  0 ],  //1
                [ x_end,  y_end + wh,  0 ],  //2
                [ x_end,  y_end - wh,  0 ],  //3
                [ x_start,  y_start - wh,  height ],  //4
                [ x_start,  y_start + wh,  height ],  //5
                [ x_end,  y_end + wh,  height ],  //6
                [ x_end,  y_end - wh,  height ]]; //7

                CubeFaces = [
                [0,1,2,3],  // bottom
                [4,5,1,0],  // front
                [7,6,5,4],  // top
                [5,6,2,1],  // right
                [6,7,3,2],  // back
                [7,4,0,3]]; // left

                polyhedron( CubePoints, CubeFaces );
            // Rest of the types handled separately
            }else if(spacer_length > 0){
                chamfer_cube_width = sqrt(2 * pow(wall_thickness, 2));

                translate([cum_width[i] + width_half*2 - wall_thickness, 0, 0]){
                    difference(){
                        // Spacer Body
                        cube([spacer_width + wall_thickness, spacer_length, height], center=false);

                        // Front Chamfer
                        if(spacer_length > lengths[i]){
                            translate([0, spacer_length - wall_thickness, -height]){
                                rotate([0, 0, 45]){
                                    cube([chamfer_cube_width, chamfer_cube_width, height*3], center=false);
                                }
                            };
                        }
                        if(spacer_length > lengths[i+1]){
                            translate([spacer_width + wall_thickness, spacer_length - wall_thickness, -height]){
                                rotate([0, 0, 45]){
                                    cube([chamfer_cube_width, chamfer_cube_width, height*3], center=false);
                                }
                            };
                        }
                    }
                }
            }
        }
    }

}
}
}
}
