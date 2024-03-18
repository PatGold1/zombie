extends Area2D

@onready var label = $DoorSprite/Label

func _on_body_entered(body):
	if body.has_method("player"):
		label.show()


func _on_body_exited(body):
	if body.has_method("player"):
		label.hide()

