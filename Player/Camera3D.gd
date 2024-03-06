extends Camera3D
@export var player: Node3D
@export var distance: float = 8

var rot_x = 0
var rot_y = 0

# TODO: Use transparency or dithering when player is occluded by a wall
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# TODO: Add sensibility and invert options
	rot_x += Input.get_axis("camera_left", "camera_right") * ((2 * PI) / 6) * delta
	rot_y += Input.get_axis("camera_down", "camera_up") * ((2 * PI) / 6) * delta
	
	# Gamepad and mouse camera movement should be non-blocking so things like gyroscope control with Steam Input 
	# (which binds gyroscope movement to a simulated mouse) or similar programs can work alongside 
	# gamepad buttons and joystick controls
	
	# NOTE: Input.get_last_mouse_velocity is relative to pixel movement, contrary to Input.get_axis
	# maybe we should normalize sensibility based on screen size so if a user changes screen resolution, 
	# the sensibility won't change
	rot_x += Input.get_last_mouse_velocity().x / 750 * ((2 * PI) / 6) * delta;
	rot_y += Input.get_last_mouse_velocity().y / 750 * ((2 * PI) / 6) * delta;
	
	# Limit camera movement vertically to not go under player or past above them (It would just invert the camera)
	if (rot_y > PI/2): rot_y = PI/2;
	if (rot_y < 0): rot_y = 0;
	
	# View explanation at https://github.com/Tau5/cozy-adventure-game/issues/2#issuecomment-1980363364
	# Calculates position of camera based on distance to player so it orbits around de player
	var pos = Vector3((distance * cos(rot_y)) * cos(rot_x), distance * sin(rot_y), (distance * cos(rot_y)) * sin(rot_x))
	transform.origin = pos + player.transform.origin
	
	var direction = (player.transform.origin - self.transform.origin).normalized()

	# View https://www.youtube.com/watch?v=rHLEWRxRGiM 
	# https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html#introducing-transforms
	# and https://github.com/godotengine/godot/blob/7d80635fce1d0c44fa69d4d8cf3da40fa998f9c7/core/math/basis.cpp#L1042
	var z = -direction;
	var x = direction.cross(Vector3.UP)
	var y = z.cross(x)
	
	transform.basis = Basis(x, y, z)
	pass
