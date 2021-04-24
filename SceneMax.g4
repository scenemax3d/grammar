//
grammar SceneMax;

@header {
   package com.abware.scenemaxlang.parser;
}

prog
   : (program_statements) EOF
   ;

program_statements : (statement ';'?)* ;

statement
   : define_resource	# defResource
   | define_sphere      # defSphere
   | define_box         # defBox
   | define_group       # defineGroup
   | debug_statement    # debugStatement
   | define_variable	# defVar
   | modify_variable    # modifyVar
   | skybox_actions     # skyBoxActions
   | screen_actions     # screenActions
   | scene_actions      # sceneActions
   | terrain_actions     # terrainActions
   | function_statement # functionStatement
   | action_statement   # actionStatement
   | do_block           # doBlock
   | function_invocation # functionInvocation
   | declare_variable   # declareVariable
   | if_statement       # ifStatement
   | collision          # collisionStatement
   | check_static       # checkStaticStatement
   | input              # inputStatement
   | print_statement    # printStatement
   | wait_statement     # waitStatement
   | wait_for_statement # waitForStatement
   | stop_statement     # stopBlock
   | return_statement   # returnStatement
   | play_sound         # playSound
   | audio_play         # audioPlay
   | audio_stop         # audioStop
   | water_actions      # waterActions
   | particle_system_actions      # particleSystemActions
   | chase_camera_actions   # chaseCameraActions
   | attach_camera_actions # attachCameraActions
   | csharp_invoke # csharpInvoke
   | using_resource # usingResource
   | light_actions # lightActions
   | add_external_code #addExternalCode
   | channel_draw_statement  # channelDraw
   | mini_map_actions # miniMapActions
   | for_each_statement # forEachStatement
   ;


add_external_code : Add file_name (',' file_name)* Code ;
file_name : QUOTED_STRING ;

debug_statement : Debug '.' debug_actions ;
debug_actions : debug_on | debug_off ;
debug_on : On ;
debug_off : Off ;


play_sound : Play Sound res_var_decl Loop? ;
audio_play : Audio '.' Play string_expr Loop? ;
audio_stop : Audio '.' Stop string_expr ;

mini_map_actions : Minimap '.' show_or_hide (Having minimap_options)? ;
show_or_hide : Show | Hide ;
minimap_options : minimap_option (And minimap_option)* ;
minimap_option : height_attr | unisize_attr | pos_2d_attr | follow_entity ;
height_attr : Height Equals? logical_expression ;
unisize_attr : Size Equals? logical_expression ;
follow_entity : Follow var_decl ;


light_actions : Lights '.' Add light_options ;
light_options : light_probe ;
light_probe : Probe QUOTED_STRING (Having print_pos_attr)? ;

input : go_condition? When input_source input_action on_entity? do_block ;
input_source : KeyA | KeyB | KeyC | KeyD | KeyE | KeyF | KeyG | KeyH | KeyI | KeyJ | KeyK | KeyL | KeyM | KeyN | KeyO |
               KeyP | KeyQ | KeyR | KeyS | KeyT | KeyU | KeyV | KeyW | KeyX | KeyY | KeyZ | KeySPACE |
               KeyLeft | KeyRight | KeyUp | KeyDown | KeyDel |
               Key0 | Key1 | Key2 | Key3 | Key4 | Key5 | Key6 | Key7 | Key8 | Key9 |
               MouseLeft | MouseRight ;
input_action: is_pressed_action ;
is_pressed_action : Is Pressed Once? ;
on_entity : On res_var_decl ;


return_statement : Return ;
stop_statement : Stop ;
wait_statement : Wait logical_expression Seconds ;

wait_for_statement : Wait For wait_for_options;
wait_for_options : wait_for_input | wait_for_expression ;
wait_for_input : input_source To Be Pressed ;
wait_for_expression : logical_expression ;

using_resource : Using resource_declaration (And resource_declaration)* ;
resource_declaration : res_var_decl (',' res_var_decl)* (Sprite | Model | Audio) ;

channel_draw_statement : res_var_decl '.' Draw sprite_name (Having channel_draw_attrs)? ;
channel_draw_attrs : channel_draw_attr (And channel_draw_attr)* ;
channel_draw_attr : pos_2d_attr | frame_attr | size_2d_attr;
sprite_name : res_var_decl | Clear ;
frame_attr : Frames logical_expression ;
size_2d_attr : Size '(' width_size ',' height_size ')' ;

print_statement : res_var_decl '.' Print print_text_expr (Having print_attr (And print_attr)*)? ;
print_text_expr : logical_expression ;
print_attr : print_color_attr | print_pos_attr | print_font_size_attr | print_append_attr | print_font_attr ;
print_append_attr : Append ;
print_font_size_attr : Size Equals? logical_expression ;
print_color_attr : Color Equals? SystemColor ;
print_font_attr : Font Equals? QUOTED_STRING ;
print_pos_attr : Pos Equals? '(' (pos_axes | pos_entity) ')' ;
pos_2d_attr : Pos '(' pos_axes_2d ')' ;
pos_axes_2d : print_pos_x ',' print_pos_y ;
pos_axes : print_pos_x ',' print_pos_y ',' print_pos_z ;
pos_entity : var_decl collision_joint_1? ;
print_pos_x : logical_expression ;
print_pos_y : logical_expression ;
print_pos_z : logical_expression ;

if_statement : IF '('? logical_expression ')'? Then? do_block (else_if_expr)* (else_expr)?;
else_if_expr : (ELSE IF '('? logical_expression ')'? Then? do_block) ;
else_expr : ELSE do_block ;


// LOGICAL EXPRESSIONS
logical_expression
    :    booleanAndExpression ( OR booleanAndExpression )*
    ;

booleanAndExpression
    :    relationalExpression ( AND relationalExpression )*
    ;

//equalityExpression
//    :    relationalExpression ( (EQUALS | NOTEQUALS) relationalExpression)*
//    ;

relationalExpression
    :    additiveExpression ( (LT | LTEQ | GT | GTEQ | EQUALS | NOTEQUALS) additiveExpression)*
    ;

additiveExpression
    :    multiplicativeExpression ( (PLUS | MINUS) multiplicativeExpression )*
    ;

multiplicativeExpression
    :    unaryExpression (( MULT | DIV | MOD ) unaryExpression)*
    ;

unaryExpression
    :    (NOT)? primaryExpression
    ;

primaryExpression
    :    '(' logical_expression ')'
    |    value
    ;

value    :
         number_expr
    |    QUOTED_STRING
    |    DATETIME
    |    BOOLEAN
    |    var_decl
    |    variable_field
    |    variable_data_field
    |    function_value
    |    csharp_register
    |    calc_distance_value
    |    calc_angle_value
    ;


calc_angle_value : Angle '(' first_object ',' second_object ')' ;
calc_distance_value : Distance '(' first_object ',' second_object ')' ;
first_object : var_decl ;
second_object : var_decl ;

function_value : (var_decl '.')? java_func_name '(' (logical_expression ((',' logical_expression)*) )? ')' ;

variable_data_field : var_decl '.' Data '.' field_name ;
field_name : ID ;

variable_field : var_decl '.' var_field ;
var_field : X | Y | Z | RX | RY | RZ | Hit | AnimPercent ;

// THE LANGUAGE SYNTAX

declare_variable : Var variable_name_and_assignemt (',' variable_name_and_assignemt)* ;
variable_name_and_assignemt : res_var_decl (Equals logical_expression)? ;

java_assignment_decl : Equals java_assignment_expr ;
java_assignment_expr : logical_expression ;

string_expr : QUOTED_STRING ;
java_func_name : Jump | res_var_decl ;


define_resource
   : define_sprite_implicit # defSpriteImplicit
   | define_sprite_implicit # defSpriteImplicit
   ;

for_each_statement : For Each entity_type? '(' var_decl ')' (for_each_having_expr)? do_block ;
entity_type : Model | Sprite | Sphere | Box ;
for_each_having_expr : Having for_each_having_attr (And for_each_having_attr)* ;
for_each_having_attr : for_each_name_attr ;
for_each_name_attr : Name string_comparators? QUOTED_STRING ;
string_comparators : Contains ;


function_statement : Function? go_condition? java_func_name (func_variables)? Equals do_block ;
function_invocation : (Run | Call) java_func_name (func_invok_variables)? (every_time_expr)? (async_expr)? ;
every_time_expr : Every logical_expression Seconds ;
func_variables : '(' res_var_decl (',' res_var_decl)* ')' ;
func_invok_variables : '(' logical_expression (',' logical_expression)* ')' ;


do_block : go_condition? (Do | '{') (amount_of_times_expr)? (async_expr)? program_statements end_do_block ;
amount_of_times_expr : logical_expression times_or_seconds ;
end_do_block : End Do | '}' ;

//define_terrain : res_var_decl isa_expr 'terrain' From file_var_decl ;
define_group : res_var_decl Belongs To The group_name Group ;
group_name : ID ;
define_sphere: res_var_decl isa_expr Collider? Static? Sphere (sphere_having_expr)? ;
define_box: res_var_decl isa_expr Collider? Static? Box (box_having_expr)? ;
define_sprite_implicit : var_decl isa_expr res_var_decl Sprite (sprite_having_expr)? ;

define_variable : var_decl isa_expr Dynamic? Static? dynamic_model_type Vehicle? (scene_entity_having_expr)? ;
dynamic_model_type : res_var_decl | dynamic_model_type_name ;
dynamic_model_type_name : '(' logical_expression ')' ;
scene_entity_having_expr : (Having model_attributes) ;
model_attributes : model_attr (And model_attr)* ;
model_attr : print_pos_attr | init_rotate_attr | init_joints_attr |
             init_turn_attr | init_scale_attr | init_mass_attr | init_static_attr | init_hidden_attr | shadow_mode_attr | calibration_attr |
             collision_shape_attr;

collision_shape_attr : Collision Shape collision_shape_options ;
collision_shape_options : Box | Boxes ;
calibration_attr : Calibrate '(' pos_axes ')' ;
shadow_mode_attr : Shadow Mode shadow_mode_options ;
shadow_mode_options : Cast | Receive | On ;

init_hidden_attr : Hidden ;
init_static_attr : Static Equals? True ;
init_joints_attr : Joints Equals? '(' QUOTED_STRING (',' QUOTED_STRING)* ')' ;
init_turn_attr : Turn turn_dir? turn_degrees ;
init_rotate_attr : Rotate Equals? '(' (rot_axes | rot_entity) ')' ;
rot_axes : rotate_x ',' rotate_y ',' rotate_z ;
rot_entity : var_decl ;
rotate_x : logical_expression ;
rotate_y : logical_expression ;
rotate_z : logical_expression ;
init_scale_attr : Scale Equals? logical_expression ;
init_mass_attr : Mass Equals? logical_expression ;

modify_variable : var_decl java_assignment_decl ;
from_file_expr : From file_var_decl ;

particle_system_actions : Effects '.' particle_system_effect '.' particle_system_action (async_expr)? ;
particle_system_effect: Flash | Explosion | Debris | Spark | SmokeTrail | ShockWave | Fire |
                        Flame | Destination | Gradient | Orbital | TimeOrbit;

particle_system_action : particle_system_action_show ;
particle_system_action_show : Show (particle_system_having_expr)? ;

particle_system_having_expr : Having particle_system_attributes ;
particle_system_attributes : particle_system_attr (And particle_system_attr)* ;
particle_system_attr : print_pos_attr | psys_attr_start_size |
                       psys_attr_end_size | psys_attr_gravity |
                       psys_attr_duration | psys_attr_radius | psys_attr_emissions | psys_attr_attach_to ;

psys_attr_attach_to : Attach To var_decl ;
psys_attr_start_size : Start Size Equals? logical_expression ;
psys_attr_end_size : End Size Equals? logical_expression ;
psys_attr_gravity : Gravity Equals? '(' vector_x ',' vector_y ',' vector_z ')' ;
psys_attr_duration : Duration Equals? logical_expression ;
psys_attr_radius : Radius Equals? logical_expression ;
psys_attr_emissions : Emissions '(' emissions_per_second ',' particles_per_emission ')' ;

emissions_per_second : logical_expression ;
particles_per_emission : logical_expression ;

vector_x : logical_expression ;
vector_y : logical_expression ;
vector_z : logical_expression ;

water_actions : Water '.' water_action ;
water_action : water_action_show ;
water_action_show : Show (water_having_expr)? ;
water_having_expr : Having water_attributes ;
water_attributes : water_attr (And water_attr)* ;
water_attr : print_pos_attr | water_strength_attr | water_wave_speed_attr | water_depth_attr | water_plane_size_attr ;
water_strength_attr : Strength Equals logical_expression ;
water_wave_speed_attr : Speed Equals logical_expression ;
water_depth_attr : Depth Equals logical_expression ;
water_plane_size_attr : Size Equals width_height_size ;
width_height_size : '(' width_size ',' height_size ')' ;
width_size : logical_expression ;
height_size : logical_expression ;

scene_actions : Scene '.' scene_action ;
scene_action : scene_action_pause | scene_action_resume ;
scene_action_pause : Pause ;
scene_action_resume : Resume ;

screen_actions : Screen '.' screen_action ;
screen_action : mode_full | mode_window ;
mode_full : Mode Full ;
mode_window : Mode Window ;

csharp_invoke : (csharp_register Equals)? CS '.' valid_java_class_name '.' java_func_name func_invok_variables? ;
csharp_register : CS '.' res_var_decl (',' res_var_decl)* ;

skybox_actions : SkyBox '.' skybox_action ;
skybox_action : skybox_action_show | skybox_action_hide | skybox_setup ;
skybox_setup : solar_system_setup_options ;
solar_system_setup_options : solar_system_option (',' solar_system_option)* ;
skybox_action_show : Show (solar_system | regular_skybox) ;
regular_skybox : QUOTED_STRING ;
solar_system : Solar System solar_system_having_expr? ;
solar_system_having_expr : Having solar_system_having_options ;
solar_system_having_options : solar_system_option (And solar_system_option)* ;
solar_system_option : cloud_flattening | cloudiness | hour_of_day ;
hour_of_day : Hour Equals? logical_expression ;
cloud_flattening : Cloud Flattening Equals? logical_expression ;
cloudiness : Cloudiness Equals? logical_expression ;
skybox_action_hide : Hide ;

terrain_actions : Terrain '.' terrain_action ;
terrain_action : terrain_action_show | terrain_action_hide ;
terrain_action_show : Show logical_expression ;
terrain_action_hide : Hide ;

attach_camera_actions : Camera '.' attach_camera_action ;
attach_camera_action : attach_camera_action_start | attach_camera_action_stop ;
attach_camera_action_start : Attach To var_decl  attach_camera_having_expr? ;
attach_camera_having_expr : Having attach_camera_having_options ;
attach_camera_having_options : attach_camera_having_option (And attach_camera_having_option)* ;
attach_camera_having_option : print_pos_attr ;
attach_camera_action_stop : Attach Stop ;

chase_camera_actions : Camera '.' chase_camera_action ;
chase_camera_action : chase_camera_action_stop | chase_camera_action_chase ;
chase_camera_action_chase : Chase var_decl chase_cam_having_expr? ;
chase_cam_having_expr : Having chase_cam_options ;
chase_cam_options : chase_cam_option (And chase_cam_option)* ;
chase_cam_option : chase_cam_option_trailing
                 | chase_cam_option_vertical_rotation
                 | chase_cam_option_horizontal_rotation
                 | chase_cam_option_rotation_speed
                 | chase_cam_option_max_distance
                 | chase_cam_option_min_distance ;
chase_cam_option_vertical_rotation : Vertical Rotation Equals? logical_expression ;
chase_cam_option_horizontal_rotation : Horizontal Rotation Equals? logical_expression ;
chase_cam_option_trailing : Trailing Equals? (True|False) ;
chase_cam_option_rotation_speed : Rotation Speed Equals? logical_expression ;
chase_cam_option_max_distance : Max Distance Equals? logical_expression ;
chase_cam_option_min_distance : Min Distance Equals? logical_expression ;

chase_camera_action_stop : Chase Stop ;

detach_parent : var_decl '.' Detach From Parent ;

attach_to : var_decl '.' Attach To var_decl ('.' joint_name)? attach_to_having_expr? ;
joint_name : QUOTED_STRING ;
attach_to_having_expr : Having attach_to_options ;
attach_to_options : attach_to_having_option (And attach_to_having_option)* ;
attach_to_having_option : print_pos_attr | init_rotate_attr ;

// Action statements
action_statement : action_operation (async_expr)? ;
async_expr : Async ;

action_operation
   : rotate		# rotateStatement
   | rotate_to  # rotateToStatement
   | record     # recordStatement
   | turn_verbal # turnStatement
   | turn_verbal_to # turnVerbalTo
   | roll_verbal # rollStatement
   | rotate_reset # rotateReset
   | move		# moveStatement
   | move_verbal # moveVerbalStatement
   | move_to    # moveTo
   | directional_move # directionalMove
   | pos        # posStatement
   | mass       # massStatement
   | velocity   # velocityStatement
   | angular_velocity # angularVelocity
   | restitution # restitutionStatement
   | friction    # frictionStatement
   | scale      # scaleStatement
   | switch_mode    # modeStatement
   | clear_modes # clearModes
   | detach_parent  # dettachParent
   | play		# playStatement
   | hide       # hideStatement
   | kill       # killStatement
   | show       # showStatement
   | delete     # deleteStatement
   | animate    # animateStatement
   | animate_short # animateShortStatement
   | stop # stopStatement
   | user_data  # userDataStatement
   | ray_check  # rayCheckStatement
   | attach_to # attachTo
   | accelerate # accelerateStatement
   | steer # steerStatement
   | brake # brakeStatement
   | turbo # turboStatement
   | reset_vehicle # resetStatement
   | vehicle_setup # vehicleSetup
   | vehicle_input_setup # vehicleInputSetup
   | vehicle_engine_setup # vehicleEngineSetup
   | character_actions # characterActions
   | set_material_action # setMaterialAction
   ;

check_static: When var_decl Is Static For logical_expression Seconds do_block ;

collision : go_condition? When var_decl collision_joint_1? Collides With var_decl collision_joint_2? do_block ;
collision_joint_1 : ('.' QUOTED_STRING) ;
collision_joint_2 : ('.' QUOTED_STRING) ;
stop : var_decl '.' Stop ;
rotate : var_decl '.' Rotate '(' (axis_expr (',' axis_expr)*) ')' In speed_expr ;
rotate_to :  var_decl '.' Rotate To '(' axis_name logical_expression ')' In speed_expr ;
axis_name : X | Y | Z ;

record : var_decl '.' Record record_actions ;
record_actions : record_transitions | record_commands | record_stop | record_save ;
record_transitions : Transitions every_time_expr ;
record_commands : Commands ;
record_stop : Stop ;
record_save : Save QUOTED_STRING ;

turn_verbal : var_decl '.' Turn turn_dir? turn_degrees In speed_expr ;
turn_dir : Left | Right | Forward | Backward ;
turn_degrees : logical_expression ;

roll_verbal :  var_decl '.' Roll turn_dir turn_degrees In speed_expr ;

turn_verbal_to : var_decl '.' Look At move_to_target (In speed_expr)? ;

rotate_reset : var_decl '.' Rotate '(' print_pos_x ',' print_pos_y ',' print_pos_z ')' ;

accelerate :  var_decl '.' Accelerate logical_expression ;
steer :  var_decl '.' Steer logical_expression ;
brake : var_decl '.' Brake logical_expression ;
turbo : var_decl '.' Turbo '(' print_pos_x ',' print_pos_y ',' print_pos_z ')' ;
reset_vehicle : var_decl '.' Reset ;


vehicle_input_setup : var_decl '.' Input (on_off_options | vehicle_input_setup_options) ;
on_off_options : On | Off ;
vehicle_input_setup_options :  vehicle_input_option (',' vehicle_input_option)* ;
vehicle_input_option : vehicle_action Equals input_source ;
vehicle_action : Start | Forward | Break | Reverse | Left | Right | Horn | Reset ;

vehicle_engine_setup : var_decl '.' Engine '.' engine_options ;
engine_options : engine_power_option | engine_breaking_option | engine_action_start_off ;
engine_action_start_off : Start | Off ;
engine_power_option : Power Equals? logical_expression ;
engine_breaking_option : Breaking Equals? logical_expression ;


vehicle_setup : var_decl '.' vehicle_side '.' vehicle_setup_options ;
vehicle_side : Front | Rear ;
vehicle_setup_options : vehicle_option (',' vehicle_option)* ;
vehicle_option : vehicle_friction_option | vehicle_suspension_option ;
vehicle_friction_option : Friction Equals logical_expression ;
vehicle_suspension_option : Suspension '.' specific_suspension_options ;
specific_suspension_options : specific_suspension_option (',' specific_suspension_option)* ;
specific_suspension_option : specific_suspension_opt_compression
                           | specific_suspension_opt_damping
                           | specific_suspension_opt_stiffness
                           | specific_suspension_opt_length ;
specific_suspension_opt_compression : Compression Equals logical_expression ;
specific_suspension_opt_damping : Damping Equals logical_expression ;
specific_suspension_opt_stiffness : Stiffness Equals logical_expression ;
specific_suspension_opt_length : Length Equals logical_expression ;



move : var_decl '.' Move '(' (axis_expr (',' axis_expr)*) ')' In speed_expr ;
move_to : var_decl '.' Move To move_to_target ('+' logical_expression)? In speed_expr looking_at_expr? ;
move_to_target : ('(' ID ')') | ('(' pos_axes ')') | position_statement ;
position_statement : '(' var_decl dir_statement* ')' ;
dir_statement : dir_verb logical_expression ;
dir_verb : Forward | Backward | Left | Right | Up | Down;
looking_at_expr : Looking At position_statement ;

move_verbal : var_decl '.' Move move_direction logical_expression In speed_expr ;

directional_move : var_decl '.' Move move_direction logical_expression (For logical_expression Seconds)? ;
move_direction : Forward | Backward | Left | Right | Up | Down ;

scale : var_decl '.' Scale Equals? logical_expression ;
pos : var_decl '.' Pos '(' (pos_axes | pos_entity | position_statement) ')' ;
mass : var_decl '.' Mass Equals? logical_expression ;
user_data : var_decl '.' Data '.' field_name Equals logical_expression ;

velocity : var_decl '.' Velocity Equals? logical_expression ;
angular_velocity : var_decl '.' Angular Velocity Equals? logical_expression ;
friction : var_decl '.' Friction Equals? logical_expression ;
restitution : var_decl '.' Restitution Equals? logical_expression ;

set_material_action : var_decl '.' Material Equals logical_expression ;

ray_check : IF '('? var_decl '.' Ray Check ')'? ray_check_from?  Then? do_block ;
ray_check_from : From '(' (pos_axes | pos_entity) ')' ;


clear_modes : var_decl '.' Clear clear_modes_options ;
clear_modes_options : clear_mode_option (And clear_mode_option)* ;
clear_mode_option : character_mode ;
character_mode : Character Mode ;


switch_mode : var_decl '.' Switch To switch_options ;
switch_options : switch_to_character | switch_to_rigid_body | switch_to_ragdoll | switch_to_kinematic | switch_to_floating;
switch_to_character : Character Mode (Having character_mode_attributes)? ;
character_mode_attributes : character_mode_attribute (And character_mode_attribute)* ;
character_mode_attribute : scalar_gravity ;
scalar_gravity : Gravity Equals? logical_expression ;

switch_to_rigid_body : Rigid Body Mode;
switch_to_ragdoll : RagDoll Mode;
switch_to_kinematic : Kinematic Mode;
switch_to_floating : Floating Mode;

//switch_to_car : Car ;

character_actions : var_decl '.' Character '.' character_action ;
character_action : character_action_jump ;
character_action_jump : Jump speed_of_expr? ;

kill : var_decl '.' Kill ;
play : var_decl '.' Play '(' frames_expr (In speed_expr)? ')' play_duration_strategy? ;
hide : var_decl '.' Hide show_options? ;
show : var_decl '.' Show show_options? ;
show_options : show_axis_option | Wireframe | show_info_option | Speedo | Tacho | show_joints_option | Outline;
show_joints_option : Joints (Having show_joints_attributes)? ;

show_joints_attributes : show_joints_attribute (And show_joints_attribute )* ;
show_joints_attribute : scalar_size_attr ;
scalar_size_attr : Size Equals logical_expression ;

show_info_option : Info (Having show_info_attributes)? ;
show_info_attributes : show_info_attribute (And show_info_attribute )* ;
show_info_attribute : file_attr ;
file_attr : File Equals? QUOTED_STRING ;

show_axis_option : Axis X? Y? Z? ;
delete : var_decl '.' Delete ;
animate : var_decl '.' Animation animation_attr (And animation_attr)* ;
animation_attr : anim_attr_speed ;
anim_attr_speed : Speed Equals? logical_expression speed_for_seconds? when_frames_above?;
speed_for_seconds : For logical_expression Seconds ;
when_frames_above : When Frames '>' logical_expression ;

animate_short : go_condition? var_decl '.' (anim_expr (Then anim_expr)*) Loop? ;
go_condition : '[' logical_expression ']' ;

///////////////////////////////////////////////////////////////////////////
play_duration_strategy : for_time_expr | Once | play_duration_loop_strategy ;
play_duration_loop_strategy : Loop (number Times)? ;
times_or_seconds : Times | Seconds ;

box_having_expr: (Having box_attributes) ;
box_attributes : box_attr (And box_attr)* ;
box_attr : model_attr | box_specific_attr ;
box_specific_attr : material_attr | volume_size_attr ;
volume_size_attr : Size Equals? '(' size_x ',' size_y ',' size_z ')' ;
size_x : logical_expression ;
size_y : logical_expression ;
size_z : logical_expression ;

sphere_having_expr : (Having sphere_attributes) ;
sphere_attributes : sphere_attr (And sphere_attr)* ;
sphere_attr : model_attr | sphere_specific_attr ;
sphere_specific_attr : material_attr | radius_attr ;
material_attr : Material Equals? logical_expression ;
radius_attr : Radius Equals? logical_expression ;

sprite_having_expr : (Having sprite_attributes) ; //rows_def And cols_def
sprite_attributes : sprite_attr (And sprite_attr)* ;
sprite_attr : rows_def | cols_def | print_pos_attr | init_scale_attr | billboard_attr ;
rows_def : Rows '=' number ;
cols_def : Cols '=' number ;
billboard_attr : Billboard Equals? True ;

anim_expr : animation_name (speed_of_expr)? ;

speed_of_expr : (At Speed Of logical_expression) ;

animation_name : (ID | QUOTED_STRING) ;

speed_expr : logical_expression Seconds ;
for_time_expr : (For logical_expression Seconds) ;
frames_expr: (Frames? from_frame To to_frame) ;

from_frame : logical_expression ;
to_frame : logical_expression ;
axis_expr : axis_id number_sign? logical_expression ;
axis_id : X | Y | Z ;
//res_type_expr : Model | Sprite ;
isa_expr : IsA | IsAn ;
var_decl : ID | Camera ;
res_var_decl : ID ;
valid_java_class_name : ID ;
file_var_decl : ID ;

number_expr : number_sign? number ;
number_sign : PLUS | MINUS ;
number: DecimalDigit ('.' DecimalDigit)? ;

Axis : 'Axis' | 'axis' ;
X : 'X' | 'x' ;
Y : 'Y' | 'y' ;
Z : 'Z' | 'z' ;
RX : 'Rx' | 'RX' | 'rx' ;
RY : 'Ry' | 'RY' | 'ry' ;
RZ : 'Rz' | 'RZ' | 'rz' ;
Hit : 'Hit' | 'hit' ;
AnimPercent : 'anim_percent' ;

True : 'True' | 'true' ;
False : 'False' | 'false' ;
IF : 'if' | 'If' ;
ELSE : 'else' | 'Else' ;
Once : 'once' | 'Once' ;
Times : 'times' | 'Times' ;
End : 'end' | 'End' ;
Do : 'do' | 'Do' ;
Loop : 'loop' | 'Loop' ;
Async : 'async' | 'Async' ;
IsA : 'is a' | 'Is a' | 'is A' | 'Is A' ;
IsAn : 'is an' | 'Is an' | 'is An' | 'Is An' ;
//Is : 'is' | 'Is' ;
//A : 'a' | 'A' | 'an' | 'An' ;
Material : 'Material' | 'material' ;
Radius : 'Radius' | 'radius' ;
Emissions : 'Emissions' | 'emissions' ;
Sphere : 'Sphere' | 'sphere' ;
Box : 'Box' | 'box' ;
Boxes : 'Boxes' | 'boxes' ;
Collision : 'Collision' | 'collision' ;
Shape : 'Shape' | 'shape' ;

Effects : 'Effects' | 'effects' ;
Flash : 'Flash' | 'flash' ;
Explosion : 'Explosion' | 'explosion' ;
Debris : 'Debris' | 'debris' ;
Spark : 'Spark' | 'spark' ;
SmokeTrail : 'Smoketrail' | 'smoketrail' ;
ShockWave : 'Shockwave' | 'shockwave' ;
Fire : 'Fire' | 'fire' ;

Flame : 'Flame' | 'flame' ;
Destination : 'Destination' | 'destination' ;
Gradient : 'Gradient' | 'gradient' ;
Orbital : 'Orbital' | 'orbital' ;
TimeOrbit : 'TimeOrbit' | 'timeOrbit' ;



Start : 'Start' | 'start' ;
Gravity : 'Gravity' | 'gravity' ;
Duration : 'Duration' | 'duration' ;

Water : 'Water' | 'water' ;
Strength : 'Strength' | 'strength' ;
Depth : 'Depth' | 'depth' ;

Terrain : 'Terrain' | 'terrain' ;
Camera : 'Camera' | 'camera' ;
Chase : 'Chase' | 'chase' ;
Trailing : 'Trailing' | 'trailing' ;
Vertical : 'Vertical' | 'vertical' ;
Horizontal : 'Horizontal' | 'horizontal' ;
Rotation : 'Rotation' | 'rotation' ;
Max : 'Max' | 'max' ;
Min : 'Min' | 'min' ;
Distance : 'Distance' | 'distance' ;
Angle : 'Angle' | 'angle' ;

Parent : 'Parent' | 'parent' ;
Detach : 'Detach' | 'detach' ;
Attach : 'Attach' | 'attach' ;
Draw : 'Draw' | 'draw' ;

Debug : 'debug' | 'Debug' ;
On : 'on' | 'On' ;
Off : 'off' | 'Off' ;

Calibrate : 'Calibrate' | 'calibrate' ;
Shadow : 'Shadow' | 'shadow' ;
Cast : 'Cast' | 'cast' ;
Receive : 'Receive' | 'receive' ;

CS : 'c#' | 'C#' | 'csharp' | 'CSharp' ;
SkyBox : 'Skybox' | 'skybox' ;
Solar : 'Solar' | 'solar' ;
System : 'System' | 'system' ;
Cloud : 'Cloud' | 'cloud' ;
Flattening : 'Flattening' | 'flattening' ;
Cloudiness : 'Cloudiness' | 'cloudiness' ;

Billboard : 'Billboard' | 'billboard' ;
Model : 'Model' | 'model' ;
Sprite : 'Sprite' | 'sprite' ;
From : 'From' | 'from' ;
Having : 'having' | 'Having' | ':' ;
For: 'for' | 'For' ;
Contains: 'Contains' | 'contains' ;
Each: 'Each' | 'each' ;
Name: 'Name' | 'name' ;

Joints : 'Joints' | 'joints' ;
Dynamic : 'Dynamic' | 'dynamic' ;
Static : 'Static' | 'static' ;
Collider : 'Collider' | 'collider' ;
Hidden : 'Hidden' | 'hidden' ;
Where : 'where' | 'Where' ;
And : 'and' | 'And' ;
In : 'in' | 'In' ;
Then : 'then' | 'Then' ;
Rows : 'rows' | 'Rows' ;
Cols : 'cols' | 'Cols' ;
To: 'to' | 'To' ;
Be : 'Be' | 'be' ;
Frames : 'frames' | 'Frames' | 'frame' | 'Frame' ;
Seconds : 'seconds' | 'Seconds' | 'second' | 'Second' ;
Wait : 'Wait' | 'wait' ;
Using : 'Using' | 'using' ;
At : 'at' | 'At' ;
Speed : 'speed' | 'Speed' ;
Of : 'of' | 'Of' ;
Rotate : 'Rotate' | 'rotate' ;
Scale : 'Scale' | 'scale' ;
Mass : 'Mass' | 'mass' ;
Velocity : 'Velocity' | 'velocity' ;
Angular : 'Angular' | 'angular' ;
Restitution : 'Restitution' | 'restitution' ;
Data : 'Data' | 'data' ;
Move : 'Move' | 'move' ;
Belongs : 'Belongs' | 'belongs' ;
The : 'The' | 'the' ;
Group : 'Group' | 'group' ;

Look : 'Look' | 'look' ;
Looking : 'Looking' | 'looking' ;

Roll : 'Roll' | 'roll' ;
Turn : 'Turn' | 'turn' ;
Forward : 'Forward' | 'forward' ;
Backward : 'Backward' | 'backward' ;
Left : 'Left' | 'left' ;
Right : 'Right' | 'right' ;
Up : 'Up' | 'up' ;
Down : 'Down' | 'down' ;

Code : 'Code' | 'code' ;
Light : 'Light' | 'light' ;
Lights : 'Lights' | 'lights' ;
Add : 'Add' | 'add' ;
Probe : 'Probe' | 'probe' ;

Minimap : 'Minimap' | 'minimap' ;
Play : 'Play' | 'play' ;
Sound : 'Sound' | 'sound' ;
Audio : 'Audio' | 'audio' ;
Hide : 'Hide' | 'hide' ;
Kill : 'Kill' | 'kill' ;
Show : 'Show' | 'show' ;
Hour : 'Hour' | 'hour' ;
Wireframe : 'Wireframe' | 'wireframe' ;
Info : 'Info' | 'info' ;
Speedo : 'Speedo' | 'speedo' ;
Tacho : 'Tacho' | 'tacho' ;
Outline : 'Outline' | 'outline' ;
Delete : 'Delete' | 'delete' ;
Accelerate : 'Accelerate' | 'accelerate' ;
Steer : 'Steer' | 'steer' ;
Brake : 'Brake' | 'brake';
Turbo : 'Turbo' | 'turbo' ;
Reset : 'Reset' | 'reset' ;
Front : 'Front' | 'front' ;
Rear : 'Rear' | 'rear' ;
Input : 'Input' | 'input' ;
Reverse : 'Reverse' | 'reverse' ;
Break : 'Break' | 'break' ;
HandBrake : 'HandBrake' | 'handbrake' | 'Handbrake' | 'handBrake' ;
Horn : 'Horn' | 'horn' ;
Engine : 'Engine' | 'engine' ;
Power : 'Power' | 'power' ;
Breaking : 'Breaking' | 'breaking' ;

Friction : 'Friction' | 'friction' ;
Suspension : 'Suspension' | 'suspension' ;
Compression : 'Compression' | 'compression' ;
Damping : 'Damping' | 'damping' ;
Stiffness : 'Stiffness' | 'stiffness' ;
Length : 'Length' | 'length' ;

Stop : 'Stop' | 'stop' ;
Return : 'Return' | 'return' ;
Animate : 'Animate' | 'animate';
Animation : 'Animation' | 'animation' ;
Print : 'Print' | 'print' ;
Append : 'Append' | 'append' ;
Color : 'Color' | 'color' ;
Font : 'Font' | 'font' ;
SystemColor : Red | Green | Blue | White | Black | Brown | Cyan |
              Gray | DarkGray | Green | LightGray | Magenta | Orange | Pink | Yellow ;
Red : 'Red' | 'red' ;
Green : 'Green' | 'green' ;
Blue : 'Blue' | 'blue' ;
White : 'White' | 'white' ;
Black: 'Black' | 'black' ;
Brown: 'Brown' | 'brown' ;
Cyan: 'Cyan' | 'cyan' ;
Gray: 'Gray' | 'gray' ;
DarkGray : 'DarkGray' | 'darkGray' | 'darkgray' ;
LightGray : 'LightGray' | 'lightGray' | 'lightgray' ;
Magenta : 'Magenta' | 'magenta' ;
Orange : 'Orange' | 'orange' ;
Pink : 'Pink' | 'pink' ;
Yellow : 'Yellow' | 'yellow' ;

Ray : 'Ray' | 'ray' ;
Check : 'Check' | 'check' ;

Pos : 'Pos' | 'pos' ;
Size : 'Size' | 'size' ;
Height : 'Height' | 'height' ;
Follow : 'Follow' | 'follow' ;
File : 'File' | 'file' ;

Clear : 'Clear' | 'clear' ;

Switch : 'Switch' | 'switch' ;
//Car : 'Car' | 'car' ;
Vehicle : 'Vehicle' | 'vehicle' ;
Character : 'Character' | 'character' ;
Jump : 'Jump' | 'jump' ;
RagDoll : 'Ragdoll' | 'ragdoll' ;
Kinematic : 'Kinematic' | 'kinematic' ;
Floating : 'Floating' | 'floating' ;
Rigid : 'Rigid' | 'rigid' ;
Body : 'Body' | 'body' ;
Screen : 'Screen' | 'screen' ;

Scene : 'Scene' | 'scene' ;
Pause : 'Pause' | 'pause' ;
Resume : 'Resume' | 'resume' ;

Record : 'Record' | 'record' ;
Transitions : 'Transitions' | 'transitions' ;
Commands : 'Commands' | 'commands' ;
Save : 'Save' | 'save' ;

Mode : 'Mode' | 'mode' ;
Full : 'Full' | 'full' ;
Window : 'Window' | 'window' ;

//Scope : 'public' | 'Public' | 'private' | 'Private' ;
Class : 'class' | 'Class' ;
Function : 'Function' | 'function' ;
Run : 'Run' | 'run' ;
Call : 'Call' | 'call' ;
Every : 'Every' | 'every' ;
Extends : 'extends' | 'Extends' ;
//Void : 'void' ;
//Int : 'int' | 'Int';
//String : 'String' ;
//Float : 'float' ;
Var : 'Var' | 'var' ;
Equals : '=' ;
New : 'new' ;
When : 'When' | 'when' ;
Collides : 'Collides' | 'collides' ;
With : 'With' | 'with' ;

/////////////////////////////////// LOGICAL EXPRESSION TOKENS /////////////////
OR    :     '||' | 'or' | 'Or';
AND   :     '&&' | And ;
EQUALS
      :    '==';
NOTEQUALS
      :    '!=' | '<>';
LT    :    '<';
LTEQ  :    '<=';
GT    :    '>';
GTEQ  :    '>=';
PLUS  :    '+';
MINUS :    '-';
MULT  :    '*';
DIV   :    '/';
MOD   :    '%';
NOT   :    '!' | 'not' | 'Not';


//INTEGER
//    :    '-'? ('0'..'9')+
//    ;
//FLOAT
//    :    '-'? ('0'..'9')+ '.' ('0'..'9')+
//    ;

//STRING
//     :    '\'' (~ '\'' )* '\''
//     ;

DATETIME
     :    '#' (~ '#' )* '#'
     ;

BOOLEAN
    :    'true'
    |    'false'
    ;

KeyA : 'key a' | 'Key a' | 'key A' | 'Key A';
KeyB : 'key b' | 'Key b' | 'key B' | 'Key B';
KeyC : 'key c' | 'Key c' | 'key C' | 'Key C';
KeyD : 'key d' | 'Key d' | 'key D' | 'Key D';
KeyE : 'key e' | 'Key e' | 'key E' | 'Key E';
KeyF : 'key f' | 'Key f' | 'key F' | 'Key F';
KeyG : 'key g' | 'Key g' | 'key G' | 'Key G';
KeyH : 'key h' | 'Key h' | 'key H' | 'Key H';
KeyI : 'key i' | 'Key i' | 'key I' | 'Key I';
KeyJ : 'key j' | 'Key j' | 'key J' | 'Key J';
KeyK : 'key k' | 'Key k' | 'key K' | 'Key K';
KeyL : 'key l' | 'Key l' | 'key L' | 'Key L';
KeyM : 'key m' | 'Key m' | 'key M' | 'Key M';
KeyN : 'key n' | 'Key n' | 'key N' | 'Key N';
KeyO : 'key o' | 'Key o' | 'key O' | 'Key O';
KeyP : 'key p' | 'Key p' | 'key P' | 'Key P';
KeyQ : 'key q' | 'Key q' | 'key Q' | 'Key Q';
KeyR : 'key r' | 'Key r' | 'key R' | 'Key R';
KeyS : 'key s' | 'Key s' | 'key S' | 'Key S';
KeyT : 'key t' | 'Key t' | 'key T' | 'Key T';
KeyU : 'key u' | 'Key u' | 'key U' | 'Key U';
KeyV : 'key v' | 'Key v' | 'key V' | 'Key V';
KeyW : 'key w' | 'Key w' | 'key W' | 'Key W';
KeyX : 'key x' | 'Key x' | 'key X' | 'Key X';
KeyY : 'key y' | 'Key y' | 'key Y' | 'Key Y';
KeyZ : 'key z' | 'Key z' | 'key Z' | 'Key Z';
Key0 : 'key 0' | 'Key 0' ;
Key1 : 'key 1' | 'Key 1' ;
Key2 : 'key 2' | 'Key 2' ;
Key3 : 'key 3' | 'Key 3' ;
Key4 : 'key 4' | 'Key 4' ;
Key5 : 'key 5' | 'Key 5' ;
Key6 : 'key 6' | 'Key 6' ;
Key7 : 'key 7' | 'Key 7' ;
Key8 : 'key 8' | 'Key 8' ;
Key9 : 'key 9' | 'Key 9' ;
MouseLeft : 'mouse left' | 'Mouse left' | 'mouse Left' | 'Mouse Left' ;
MouseRight : 'mouse right' | 'Mouse right' | 'mouse Right' | 'Mouse Right' ;
KeyDel : 'key del' | 'Key del' | 'key Del' | 'Key Del' ;
KeySPACE : 'key space' | 'Key space' | 'key Space' | 'Key Space';
KeyLeft : 'key left' | 'Key left' | 'key Left' | 'Key Left';
KeyRight : 'key right' | 'Key right' | 'key Right' | 'Key Right';
KeyUp : 'key up' | 'Key up' | 'key Up' | 'Key Up';
KeyDown : 'key down' | 'Key down' | 'key Down' | 'Key Down';

Is : 'Is' | 'is' ;
Pressed : 'Pressed' | 'pressed' ;
//////////////////////////////////////////////


//NumberSign : [+-] ;
DecimalDigit : [0-9]+ ;
ID : [a-zA-Z_$][a-zA-Z_$0-9]* ;
fragment ESCAPED_QUOTE : '\\"';
QUOTED_STRING :   '"' ( ESCAPED_QUOTE | ~('\n'|'\r') )*? '"';

// : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines
WS : [ \r\n\t] + -> channel (HIDDEN) ;
LINE_COMMENT : '//' ~[\r\n]* -> skip ;
BlockComment : '/*' .*? '*/' -> skip ;