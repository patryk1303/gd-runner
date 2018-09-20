extends Area2D

var target
export(NodePath) var target_path

func _ready():
	target = get_node(target_path)

	$Label.hide()

func _on__TriggerBase_body_entered(body):
	pass # replace with function body
