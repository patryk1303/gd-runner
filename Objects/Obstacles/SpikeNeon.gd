extends Area2D

func _on_SpikeNeon_body_entered(body):
	if body.is_in_group("hero"):
		body.die()
