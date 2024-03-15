extends Control

func show_above(node_top: Vector3):
	var camera = get_viewport().get_camera_3d()
	var pos = camera.unproject_position(node_top)
	pos.y -= size.y / 2
	global_position = pos
	show()
