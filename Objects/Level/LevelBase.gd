extends Node2D

const ATTEMPT = "Attempt "

func stop_music():
	$music.stop()
	
func _ready():
	$Hero.connect("died", self, "_on_hero_die")
	$Hero.connect("die_timer", self, "_on_hero_die_timer")
	
	$Attempt.text = ATTEMPT + String(globals.level_attemps)
	
func _physics_process(delta):
	$cloud1.position.x = $Hero.position.x
	$Shades.position = $Hero.position
	
func _on_hero_die():
	globals.level_attemps += 1
	stop_music()
	
func _on_hero_die_timer():
	get_tree().reload_current_scene()