extends "_i_state.gd"

export(int) var jump_force = 200
export(int) var speed = 200
export(int) var max_gravity = 250
export(int, -1, 1, 1) var direction = 1

var key_maps = {
	jump = false
}

var motion = Vector2(0, 0)

# Initialize the state. E.g. change the animation
func enter(host):
	var ray_right = host.get_node("Rays/RayRight")
	var ray_right_2 = host.get_node("Rays/RayRight2")

	var ray_left = host.get_node("Rays/RayLeft")
	var ray_left_2 = host.get_node("Rays/RayLeft2")

	var target = host.get_node("Target")

	host.get_node("icon").rotation = 0

	ray_right.cast_to = Vector2(globals.RAY_LEN, globals.RAY_LEN)
	ray_left.cast_to = Vector2(-globals.RAY_LEN / 2, globals.RAY_LEN)

	ray_right_2.cast_to = Vector2(globals.RAY_LEN, -globals.RAY_LEN)
	ray_left_2.cast_to = Vector2(-globals.RAY_LEN / 2, -globals.RAY_LEN)

	target.position = Vector2(0, 0)

func handle_input(host, event):
	if event.is_action_pressed("move_jump"):
		key_maps.jump = true

	if event.is_action_released("move_jump"):
		key_maps.jump = false

func update(host, delta):
	if not host.alive:
		return

	var force = globals.GRAVITY * 0.1 * host.gravity_vector

	motion += force * delta

	if key_maps.jump:
		force.y = -jump_force

	force.x = speed

	motion.x = force.x
	motion.y = clamp(motion.y + force.y, -max_gravity, max_gravity)

#	print(motion.y)

	motion = host.move_and_slide(motion, globals.UP * host.gravity_vector)
