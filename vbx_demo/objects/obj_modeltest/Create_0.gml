/// @desc

event_user(0);

enum ModelType
{
	simple, normal, vbc, normalmap, rigged, complete
}

show_debug_overlay(1);

// Vars ==============================================================

modelposition = [0,0,0];
modelzrot = 0;

wireframe = false;
usetextures = false;
usenormalmap = true;
drawnormal = false;
cullmode = cull_clockwise;

colorfill = [0, 1, 0.5, 0];
colorblend = [0.5, 1.0, 0.5, 0];

zrotanchor = 0;
mouseanchor = [0,0];
mouselock = 0;

lightdata = [-16, 128, 64, 1]; // Light position
lightdata = [0.575000*32, -0.475000*32, 0.666146*32, 1];
lightdata = [0.291667*32, -0.575000*32, 0.764399*32, 1]

showgui = true;
cursortimeout = 0;
cursortimeouttime = 1.0;
mouselastx = 0;
mouselasty = 0;

// Input =============================================================

LoadSettings("settings.ini");
camera = instance_create_depth(0, 0, 0, obj_camera);

// Models =============================================================

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
vbf_basic = vertex_format_end();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_color();
vertex_format_add_texcoord();
vbf_model = vertex_format_end();

worldvbs = [];
worldnames = [];
worldcount = FetchWorldFiles(DIRPATH+"world/", worldvbs, worldnames);
worldindex = 0;
worldactive = -1;

vb_ball = OpenVertexBuffer(DIRPATH+"ball.vb", vbf_basic);
vb_grid = CreateGridVB(128, 1);

drawworld = true;
drawcamerapos = false;
drawgrid = true;

u_shd_model_light = shader_get_uniform(shd_model, "u_light");
u_shd_model_drawmatrix = shader_get_uniform(shd_model, "u_drawmatrix");

flashtime = 15;

// Demos ==============================================================

modelobj = array_create(8, obj_dm_simple);
modelobj[ModelType.simple]	= instance_create_depth(0,0,0, obj_dm_simple);
modelobj[ModelType.normal]	= instance_create_depth(0,0,0, obj_dm_normal);
modelobj[ModelType.vbc]	= instance_create_depth(0,0,0, obj_dm_vbc);
modelobj[ModelType.normalmap]	= instance_create_depth(0,0,0, obj_dm_vbc_normalmap);
modelobj[ModelType.rigged]	= instance_create_depth(0,0,0, obj_dm_vbc_rigged);
modelobj[ModelType.complete]	= instance_create_depth(0,0,0, obj_dm_vbc_complete);
modelmode = ModelType.rigged;

instance_deactivate_object(obj_demomodel);
instance_activate_object(modelobj[modelmode]);
modelactive = modelobj[modelmode];

// Layout
event_user(1);

OP_WorldSelect(worldindex);
