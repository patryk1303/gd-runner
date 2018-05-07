extends Node2D

func stop_music():
	$music.stop()
	
func _ready():
	$Hero.connect("died", self, "_on_hero_die")
	
func _physics_process(delta):
	$cloud1.position.x = $Hero.position.x
	$Shades.position = $Hero.position
	
func _on_hero_die():
	stop_music()