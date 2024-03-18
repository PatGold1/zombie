extends Node2D

@export var slot_data: SlotData
@onready var sprite_2d = $Item
@onready var item = $Item


var original_position: Vector2
var bob_amplitude = 0.5
var bob_speed = 2.0
var time_passed = 0.0

func _ready() -> void:
	original_position = position
	sprite_2d.texture = slot_data.item_data.texture

func _on_body_entered(body):
	if body.has_method("player"):
		if body.inventory_data.pick_up_slot_data(slot_data):
			queue_free()
			print("1")
		
func _process(delta: float) -> void:
	time_passed += delta
	var bob_offset = sin(time_passed * bob_speed) * bob_amplitude
	item.position.y = original_position.y + bob_offset
