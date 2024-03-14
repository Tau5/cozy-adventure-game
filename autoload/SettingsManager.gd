extends Node

@export var config_file = "user://config.cfg"

var settings = {
	"camera_invert_x": false,
	"camera_invert_y": false,
	"camera_mouse_sensibility": 0.16,
	"camera_joystick_sensibility": 0.16
}

func save_config():
	var config = ConfigFile.new();
	for setting in settings:
		config.set_value("settings", setting, settings[setting])
	config.save(config_file)

func load_config():
	var config = ConfigFile.new();
	var err = config.load(config_file)

	if err != OK:
		if err == Error.ERR_FILE_NOT_FOUND:
			push_warning("Error loading config file. File not found. Creating config file...")
			save_config()
		else:
			push_error("Error loading config file. Unknown error")
		return

	for setting in config.get_section_keys("settings"):
		settings[setting] = config.get_value("settings", setting)

# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()
	pass # Replace with function body.

