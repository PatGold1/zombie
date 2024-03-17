extends Node2D

const PickUp = preload("res://item/Pick_Up/pick_up.tscn")
const Zombie = preload("res://Enemies/zombie.tscn")

@onready var player = $Player
@onready var inventory_interface = $UI/InventoryInterface
@onready var hot_bar_inventory = $UI/HotBarInventory
@onready var kill_count = $WorldStats/KillCount

func _physics_process(delta):
	set_kill_counter()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_equip_inventory_data(player.equip_inventory_data)
	inventory_interface.force_close.connect(toggle_inventory_interface)
	hot_bar_inventory.set_inventory_data(player.inventory_data)

	execute_zombies()
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		hot_bar_inventory.hide()
	else:
		hot_bar_inventory.show()
		
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()


func _on_inventory_interface_drop_slot_data(slot_data):
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = Vector2.UP
	add_child(pick_up)

func execute_zombies():
	var wave_count = 1
	var max_waves = 100
	while wave_count < max_waves:
		for i in range(wave_count):
			spawn_zombie()
		wave_count += 1
		await get_tree().create_timer(3.0).timeout
	
func spawn_zombie():
	var object = Zombie.instantiate()
	var random_x = randf_range(-30, 30)  # replace with your desired range
	var random_y = randf_range(-30, 30) 
	
	if object != null:
		object.position = Vector2(random_x, random_y)
		
	add_child(object)
	
func set_kill_counter():
	var kill_counter_data = WorldStats.kill_counter
	kill_count.set_text(str(kill_counter_data))
