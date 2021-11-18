/// @desc

// Inherit the parent event
event_inherited();

// Toggle playback
if keyboard_check_pressed(vk_space)
{
	isplaying ^= true;
}

// Progress Animation
if isplaying
{
	trackpos = Modulo(trackpos + trackposspeed, 1);
	UpdateAnim();
}
else
{
	// Move by frame
	var lev = LevKeyHeld(vk_right, vk_left);
	if lev != 0
	{
		trackpos += lev*trackposspeed;
		posemode = 1;
		UpdateAnim();
	}
}

var s = 0.01;
mattex_x += LevKeyHeld(vk_numpad6, vk_numpad4)*s;
mattex_y += LevKeyHeld(vk_numpad2, vk_numpad8)*s;

mattex = Mat4Translate(mattex_x, mattex_y, 0);