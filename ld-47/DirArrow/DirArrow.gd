extends Node2D

export var clamp_deg = 80

func _ready():
	pass

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var arrow_pos = get_global_transform().xform(position)
	
	var angle
	# if the cursor is below the arrow, just clamp to the maximum
	if mouse_pos.y > arrow_pos.y:
		angle = clamp_deg * sign(mouse_pos.x - arrow_pos.x)
	else:
		var pos_delta = mouse_pos - arrow_pos
		var dist = pos_delta.length()
		angle = rad2deg(acos(pos_delta.x / dist))
		angle = -angle + 90 # necessary rotation
		angle = clamp(angle, -clamp_deg, clamp_deg)
	
	rotation_degrees = angle
	
