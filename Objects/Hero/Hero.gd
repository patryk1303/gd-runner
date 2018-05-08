extends KinematicBody2D

signal state_changed
signal died
signal die_timer

var states_stack = []
var current_state = null

var alive = true

var gravity_vector = 1

onready var states_map = {
	standard = $States/Standard,
	leftright = $States/LeftRight,
	stagger = $States/Stagger
}

func die():
	if alive:
		emit_signal("died")
	$Timers/DieTimer.start()
	$icon.hide()
	$DieParticles.emitting = true
	alive = false
	
func jump():
	if current_state.has_method("jump"):
		current_state.jump(self)
		
func change_gravity():
	gravity_vector *= -1
	
func check_ray_collide(ray):
	var collider = ray.get_collider()
	if collider and collider.is_in_group(globals.GROUP_TILES):
		die()

func _ready():
	alive = true
	states_stack.push_front($States/Standard)
	current_state = states_stack[0]
	_change_state('standard')
	
	$Rays/RayLeft.cast_to = Vector2(-8, 0)
	$Rays/RayRight.cast_to = Vector2(8, 0)
	$DieParticles.emitting = false
	
func _physics_process(delta):
	var state_name = current_state.update(self, delta)
	
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	
	check_ray_collide($Rays/RayRight)
	check_ray_collide($Rays/RayRight2)
	check_ray_collide($Rays/RayLeft)
	check_ray_collide($Rays/RayLeft2)
	
	if state_name:
		_change_state(state_name)

func _input(event):
	var state_name = current_state.handle_input(self, event)
	
	if state_name:
		_change_state(state_name)
		
func _change_state(state_name):
	current_state.exit(self)
	
	if state_name == globals.PREV:
		states_stack.pop_front()
	else:
		var new_state = states_map[state_name]
		states_stack[0] = new_state
		
	current_state = states_stack[0]
	
	if state_name != globals.PREV:
		current_state.enter(self)
		
	emit_signal('state_changed', states_stack)
	
	pass

func _on_DieTimer_timeout():
	emit_signal("die_timer")
