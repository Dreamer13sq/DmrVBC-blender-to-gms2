/// @desc Initializing Variables

// Camera ----------------------------------------------
cameraposition = [0, 0, 8];	// Location to point the camera at
cameraxrot = -10;	// Camera's vertical rotation
camerazrot = 10;	// Camera's horizontal rotation
cameradistance = 24;	// Distance from camera position

fieldofview = 50;
znear = 1;
zfar = 100;

matproj = matrix_build_projection_perspective_fov(
	fieldofview, window_get_width()/window_get_height(), znear, zfar);

matview = matrix_build_identity();
mattran = matrix_build_identity();

// Camera Controls
mouseanchor = [mouse_x, mouse_y];
cameraxrotanchor = cameraxrot;	// Updated when middle mouse is pressed
camerazrotanchor = camerazrot;	// Updated when middle mouse is pressed
movingcamera = false;	// Middle mouse or left mouse + alt is held
movingcameralast = false;	// Used to check when middle has been pressed

// *Vertex formats -------------------------------------
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
vbf_simple = vertex_format_end();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_color();
vertex_format_add_texcoord();
vertex_format_add_custom(vertex_type_float4, vertex_usage_texcoord); // Bone Indices
vertex_format_add_custom(vertex_type_float4, vertex_usage_texcoord); // Bone Weights
vbf_rigged = vertex_format_end();	// For shd_rigged

// Load Vertex Buffers ---------------------------------
vb_grid = OpenVertexBuffer("grid.vb", vbf_simple);
vb_axis = OpenVertexBuffer("axis.vb", vbf_simple);

// *Open VBM -------------------------------------------
vbm_curly = new VBMData();
OpenVBM(vbm_curly, "curly_rigged.vbm", vbf_rigged);	// VBM with bone index and weight attributes

// *Open TRK -------------------------------------------
trk_wave = new TRKData();	// Initialize new TRK data
OpenTRK(trk_wave, "wave.trk");	// Read in TRK from file

// *Model Controls -------------------------------------
zrot = 0;
lightpos = [8, 32, 48]
localpose = Mat4Array(VBM_MATPOSEMAX);	// Array of matrices to be populated by EvaluateAnimationTracks()
matpose = Mat4ArrayFlat(VBM_MATPOSEMAX);	// Flat array of matrices to pass into the shader

// *Playback Controls ----------------------------------
playbackposition = 0;	// Current position of animation
playbackmode = 0; // 0 = Matrices, 1 = Tracks

// *Shader Uniforms ------------------------------------
u_rigged_light = shader_get_uniform(shd_rigged, "u_lightpos");
u_rigged_matpose = shader_get_uniform(shd_rigged, "u_matpose");	// Handler for pose matrix array

event_perform(ev_step, 0);	// Force an update
