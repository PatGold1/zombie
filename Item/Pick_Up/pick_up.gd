extends Node2D

@export var slot_data: SlotData
@onready var sprite_2d = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = slot_data.item_data.texture


func _on_body_entered(body):
	if body.inventory_data.pick_up_slot_data(slot_data):
		queue_free()
		print("1")
