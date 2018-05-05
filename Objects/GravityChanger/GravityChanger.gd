extends Area2D

func _on_GravityChanger_body_entered(body):
	if body.is_in_group("hero"):
		body.change_gravity()
