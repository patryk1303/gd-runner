extends '_i_state.gd'

export(int) var jump_strength = 300
export(int) var speed = 200

var key_maps = {
	jump = false
}

var motion = Vector2(0, 0)

func jump(host):
	motion.y = -jump_strength

func handle_input(host, event):
	if event.is_action_pressed("move_jump"):
#		host.get_node("Rays/RayLeft").cast_to = Vector2(-8, 0)
#		host.get_node("Rays/RayRight").cast_to = Vector2(8, 0)
		key_maps.jump = true
	
	if event.is_action_released("move_jump"):
#		host.get_node("Rays/RayLeft").cast_to = Vector2(-4, 0)
#		host.get_node("Rays/RayRight").cast_to = Vector2(4, 0)
		key_maps.jump = false
	
	return

func update(host, delta):
	if not host.alive:
		return
	
	var force = globals.GRAVITY * host.gravity_vector
	
	motion += force * delta
	
	motion.x = speed
	
	motion = host.move_and_slide(motion, globals.UP * host.gravity_vector)
	
	if key_maps.jump and host.is_on_floor():
		jump(host)
		
	if not host.is_on_floor():
		var rotate_speed = deg2rad(5)
		
		host.get_node("icon").rotate(rotate_speed)
		
	if host.is_on_floor():
		var current_rotate = globals.modulo(rad2deg(host.get_node("icon").rotation), 360)
		var current_right_rotate = globals.modulo(current_rotate, 90)
		
		var diff = current_rotate - current_right_rotate
		var new_rotation = diff + 90
		
		if not round(current_rotate) == diff:
			host.get_node("icon").rotation = deg2rad(new_rotation)
	
	return