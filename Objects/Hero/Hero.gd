extends KinematicBody2D

signal state_changed
signal died

var states_stack = []
var current_state = null

var alive = true

var gravity_vector = 1

onready var states_map = {
	standard = $States/Standard,
	stagger = $States/Stagger
}

func die():
	$Timers/DieTimer.start()
	$icon.hide()
	$DieParticles.emitting = true
	alive = false
	emit_signal("died")
	
func jump():
	if current_state.has_method("jump"):
		current_state.jump(self)
		
func change_gravity():
	gravity_vector *= -1

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
	
	if $Rays/RayRight.is_colliding():
		var collider = $Rays/RayRight.get_collider()
		if collider.is_in_group(globals.GROUP_TILES):
			die()
			
	if $Rays/RayRight2.is_colliding():
		var collider = $Rays/RayRight2.get_collider()
		if collider.is_in_group(globals.GROUP_TILES):
			die()
	
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
	get_tree().reload_current_scene()
