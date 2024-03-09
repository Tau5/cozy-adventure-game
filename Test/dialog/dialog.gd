extends Node2D

@onready var dialog = $DialogBox

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog.show()
	dialog.add_dialog("Kit", "Hi! My name is Kit!")
	dialog.add_dialog("You", "You have daddy issues.")
	dialog.play_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dialog_box_dialog_finished():
	dialog.hide()
