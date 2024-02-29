extends Control
@export var char_time: float = 0.05

class Dialog:
	var name: String
	var text: String

var dialogs = []
var curr_dialog_index = 0
var dialog_char_index = 0
var acum_time: float = 0
var playing: bool = false

signal dialog_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (playing):
		acum_time += delta;
		if (acum_time > char_time and dialog_char_index < dialogs[curr_dialog_index].text.length()):
			$Text.add_text(dialogs[curr_dialog_index].text[dialog_char_index])
			dialog_char_index += 1;
			acum_time = 0;
		pass
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if dialog_char_index > dialogs[curr_dialog_index].text.length() - 1:
			next_dialog()
		else:
			dialog_char_index = dialogs[curr_dialog_index].text.length() - 1;
			$Text.clear()
			$Text.add_text(dialogs[curr_dialog_index].text)

func add_dialog(name: String, text: String):
	var dialog = Dialog.new()
	dialog.name = name;
	dialog.text = text;
	dialogs.append(dialog)

func reset_dialog():
	dialogs.clear()
	curr_dialog_index = 0;
	dialog_char_index = 0;

func next_dialog():
	if (curr_dialog_index < dialogs.size() - 1):
		curr_dialog_index += 1;
		dialog_char_index = 0;
		$Text.clear()
		$NameLabel.set_text(dialogs[curr_dialog_index].name)
	else:
		dialog_finished.emit()
		
func play_dialog():
	$NameLabel.set_text(dialogs[curr_dialog_index].name)
	show()
	playing = true
	
func stop_dialog():
	hide()
	$NameLabel.set_text("")
	playing = false
	

