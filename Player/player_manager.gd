extends Node

var player
var player_current_attack = false
var item_equipped = false


func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func get_global_position() -> Vector2: 
	return player.global_position

func equipItem(item):
	print(item)
