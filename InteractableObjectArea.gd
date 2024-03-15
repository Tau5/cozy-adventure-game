extends Node3D
const player_type = preload("res://Player/PlayerActor.gd")
const interact_icon_type = preload("res://UI/InteractIcon.gd")

@export var visual_instance: VisualInstance3D
@export var disabled = false
var interact_icon: interact_icon_type
var update_icon_position = false
var player_inside = false
# Called when the node enters the scene tree for the first time.

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	for node in get_tree().get_nodes_in_group("UI"):
		if node is interact_icon_type:
			interact_icon = node
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_inside:
		if update_icon_position and not disabled:
			var aabb = visual_instance.get_aabb()
			var relative_top = aabb.get_center()
			relative_top.y = aabb.size.y
			var absolute_top = visual_instance.to_global(relative_top)
			interact_icon.show_above(absolute_top)
		if disabled and interact_icon.visible:
			hide_interact_icon()
	pass
	
func hide_interact_icon():
	update_icon_position = false
	interact_icon.hide()
	
func show_interact_icon():
	update_icon_position = true

func _on_interact():
	pass
	
func _on_interact_internal():
	if not disabled:
		_on_interact()
	pass
	
func _on_body_entered(body):
	if not disabled:
		if body is player_type:
			if not body.interact.is_connected(_on_interact_internal):
				body.interact.connect(_on_interact_internal)
			show_interact_icon()
			player_inside = true
	pass # Replace with function body.
	
func _on_body_exited(body):
	if body is player_type:
		player_inside = false
		body.interact.disconnect(_on_interact_internal)
		update_icon_position = false
		hide_interact_icon()
