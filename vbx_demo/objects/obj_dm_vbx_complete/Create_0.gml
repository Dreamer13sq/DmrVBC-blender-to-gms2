/// @desc

event_inherited();

// Vertex Format: [pos3f, normal3f, color4B, uv2f, bone4f, weight4f] ==========
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_custom(vertex_type_float3, vertex_usage_texcoord); // Tangent
vertex_format_add_custom(vertex_type_float3, vertex_usage_texcoord); // Bitangent
vertex_format_add_color();
vertex_format_add_texcoord();
vertex_format_add_custom(vertex_type_float4, vertex_usage_texcoord); // Bone Indices
vertex_format_add_custom(vertex_type_float4, vertex_usage_texcoord); // Bone Weights
vbf = vertex_format_end();

vbx = OpenVBX(DIRPATH + "curly_complete.vbx", vbf);

// Animation Vars =====================================================
// 2D array of matrices. Holds relative transforms for bones
posetransform = Mat4Array(DMRVBX_MATPOSEMAX, matrix_build_identity());
// 1D flat array of matrices. Holds final transforms for bones
matpose = Mat4ArrayFlat(DMRVBX_MATPOSEMAX, matrix_build_identity());

trkanims = []
trknames = []
trkcount = FetchPoseFiles(DIRPATH, trkanims, trknames);
trkindex = trkcount-1;
trkactive = 0;
trktimestep = 0;
trkposition = 0.0;
trkposlength = 0.0;
trkmarkerindex = 0;
playbackspeed = 1.0;
isplaying = false;

posemode = 0; // 0 = Poses, 1 = Animation
keymode = 0;
vbmode = 1;

wireframe = 0;
interpolationtype = TRK_Intrpl.linear;

// Control Variables ========================================================
meshselect = 0;
meshvisible = array_create(32, 1);
meshflash = array_create(32, 0);
meshtexture = array_create(32, -1);
meshnormalmap = array_create(32, -1);

skinsss = 0.0;

LoadDiffuseTextures();
LoadNormalTextures();

drawmatrix = BuildDrawMatrix();

if vbx.FindVBIndex("curly_gun_mod") != -1
	{meshvisible[vbx.FindVBIndex("curly_gun_mod")] = 0;}
if vbx.FindVBIndex("curly_school") != -1
	{meshvisible[vbx.FindVBIndex("curly_school")] = 0;}

// Uniforms ========================================================
var _shd;
_shd = shd_complete;
u_shd_complete_drawmatrix = shader_get_uniform(_shd, "u_drawmatrix");
u_shd_complete_light = shader_get_uniform(_shd, "u_light");
u_shd_complete_matpose = shader_get_uniform(_shd, "u_matpose");
u_shd_complete_texnormal = shader_get_sampler_index(_shd, "u_texnormal");

event_user(1);

OP_ActionSelect(trkindex);

