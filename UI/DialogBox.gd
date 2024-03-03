extends Control
@export var seconds_per_character: float = 0.05

class Dialog:
	var name: String
	var text: String

var dialogs = []
var curr_dialog_index = 0
var dialog_char_index = 0
var acum_time: float = 0
var playing: bool = false
const default_delimiter = "|"

signal dialog_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (playing):
		acum_time += delta
		
		if (acum_time > seconds_per_character and dialog_char_index < dialogs[curr_dialog_index].text.length()):
			$TextBox.add_text(dialogs[curr_dialog_index].text[dialog_char_index])
			dialog_char_index += 1
			acum_time = 0

func _input(event):
	if event.is_action_pressed("ui_accept"):
		# if finished drawing the text
		if dialog_char_index > dialogs[curr_dialog_index].text.length() - 1:
			next_dialog()
		else:
			# skip all text 
			dialog_char_index = dialogs[curr_dialog_index].text.length() - 1
			$TextBox.clear()
			$TextBox.add_text(dialogs[curr_dialog_index].text)

func add_dialog(dialog_name: String, text: String, delimiter: String = default_delimiter):
	for text_in_dialog in text.split(delimiter):
		var dialog = Dialog.new()
		dialog.name = dialog_name
		dialog.text = text_in_dialog
		dialogs.append(dialog)

func reset_dialog():
	dialogs.clear()
	curr_dialog_index = 0
	dialog_char_index = 0

func next_dialog():
	# if not finished rendering dialogs
	if (curr_dialog_index < dialogs.size() - 1):
		curr_dialog_index += 1
		dialog_char_index = 0
		$TextBox.clear()
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
