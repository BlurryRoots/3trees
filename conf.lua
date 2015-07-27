function love.conf(t)
	-- The name of the save directory (string)
	t.identity = nil
	-- The LÖVE version this game was made for (string)
	t.version = "0.9.1"
	-- Attach a console (boolean, Windows only)
	t.console = false
	-- The window title (string)
	t.window.title = "3trees"
	-- Filepath to an image to use as the window's icon (string)
	t.window.icon = nil
	-- The window width (number)
	t.window.width = 1024
	-- The window height (number)
	t.window.height = 768
	-- Remove all border visuals from the window (boolean)
	t.window.borderless = false
	-- Let the window be user-resizable (boolean)
	t.window.resizable = false
	-- Minimum window width if the window is resizable (number)
	t.window.minwidth = 1
	-- Minimum window height if the window is resizable (number)
	t.window.minheight = 1
	-- Enable fullscreen (boolean)
	t.window.fullscreen = false
	-- Standard fullscreen or desktop fullscreen mode (string)
	t.window.fullscreentype = "desktop"
	-- Enable vertical sync (boolean)
	t.window.vsync = true
	-- The number of samples to use with multi-sampled antialiasing (number)
	t.window.fsaa = 0
	-- Index of the monitor to show the window in (number)
	t.window.display = 1
	-- Enable high-dpi mode for the window on a Retina display (boolean). Added in 0.9.1
	t.window.highdpi = true
	-- Enable sRGB gamma correction when drawing to the screen (boolean). Added in 0.9.1
	t.window.srgb = false

	-- Enable the audio module (boolean)
	t.modules.audio = true
	-- Enable the event module (boolean)
	t.modules.event = true
	-- Enable the graphics module (boolean)
	t.modules.graphics = true
	-- Enable the image module (boolean)
	t.modules.image = true
	-- Enable the joystick module (boolean)
	t.modules.joystick = true
	-- Enable the keyboard module (boolean)
	t.modules.keyboard = true
	-- Enable the math module (boolean)
	t.modules.math = true
	-- Enable the mouse module (boolean)
	t.modules.mouse = true
	-- Enable the physics module (boolean)
	t.modules.physics = true
	-- Enable the sound module (boolean)
	t.modules.sound = true
	-- Enable the system module (boolean)
	t.modules.system = true
	-- Enable the timer module (boolean)
	t.modules.timer = true
	-- Enable the window module (boolean)
	t.modules.window = true
	-- Enable the thread module (boolean)
	t.modules.thread = true
end
