extends '_i_state.gd'

const RAY_LEN = 8

export(int) var speed = 200
export(int) var max_gravity = 300

var key_maps = {
	left = false,
	right = false
}

var motion = Vector2(0, 0)

func enter(host):
	var ray_right = host.get_node("Rays/RayRight")
	var ray_right_2 = host.get_node("Rays/RayRight2")
	
	var ray_left = host.get_node("Rays/RayLeft")
	var ray_left_2 = host.get_node("Rays/RayLeft2")
	
	var target = host.get_node("Target")
	
	host.get_node("icon").rotation = 0
	
	ray_right.cast_to = Vector2(0, globals.RAY_LEN)
	ray_left.cast_to = Vector2(0, globals.RAY_LEN)
	
	ray_right_2.cast_to = Vector2(0, 0)
	ray_left_2.cast_to = Vector2(0, 0)
	
	target.position = Vector2(0, 128)

func exit(host):
	.exit(host)

func handle_input(host, event):
	
	if event.is_action_pressed("move_jump"):
		key_maps.left = true
	elif event.is_action_pressed("move_jump2"):
		key_maps.right = true
		
	if event.is_action_released("move_jump"):
		key_maps.left = false
	elif event.is_action_released("move_jump2"):
		key_maps.right = false

func update(host, delta):
	if not host.alive:
		return
		
	var force = globals.GRAVITY * 0.1 * host.gravity_vector
	
	motion += force * delta
	
	if key_maps.left:
		force.x = -speed
	elif key_maps.right:
		force.x = speed
		
	motion.x = force.x
	motion.y = clamp(motion.y, 100, max_gravity)
	
	motion = host.move_and_slide(motion, globals.UP * host.gravity_vector)