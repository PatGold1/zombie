extends Area2D

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData

func player_interact() -> void:
	toggle_inventory.emit(self)

func _on_input_event(_viewport, _event, _shape_idx):
	if _event is InputEventMouseButton and _event.button_index == MOUSE_BUTTON_LEFT and _event.pressed:
		interact()

func interact() -> void:
	toggle_inventory.emit(self)
	print('open chest')
	
