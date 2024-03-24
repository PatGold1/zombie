extends PanelContainer

#SIGNAL EMITTED WHEN A HOT BAR ITEM IS USED
signal hot_bar_use(index: int)

const Slot = preload("res://Inventory/slot.tscn")
var selected_slot_index = 0

@onready var h_box_container = $MarginContainer/HBoxContainer
@onready var texture_rect = $MarginContainer/HBoxContainer/TextureRect
	

func _unhandled_input(event: InputEvent) -> void:
	if not visible or not event.is_pressed():
		return
		
	if event is InputEventKey and range(KEY_1, KEY_7).has(event.keycode):
		hot_bar_use.emit(event.keycode - KEY_1)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			scroll_hotbar(1)  # Scroll up
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			scroll_hotbar(-1)   # Scroll down
		
func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_hotbar)
	populate_hotbar(inventory_data)
	hot_bar_use.connect(inventory_data.use_slot_data)

func populate_hotbar(inventory_data: InventoryData) -> void:
	for child in h_box_container.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_datas.slice(0, 6):
		var slot = Slot.instantiate()
		h_box_container.add_child(slot)
		
		if slot_data:
			slot.set_slot_data(slot_data)

func _select_slot(index: int) -> void:
	selected_slot_index = index
	for i in range(h_box_container.get_child_count()):
		var slot = h_box_container.get_child(i)
		slot.highlight(i == index)
		
func scroll_hotbar(direction: int) -> void:
	selected_slot_index = (selected_slot_index + direction) % h_box_container.get_child_count()

	if selected_slot_index < 0:
		selected_slot_index = h_box_container.get_child_count() - 1
	
	for i in range(h_box_container.get_child_count()):
		if i == selected_slot_index:
			
			var selected_panel = h_box_container.get_child(selected_slot_index)
			selected_panel.modulate = Color(255, 255, 255)  # Set color to white
			#hot_bar_use.emit(selected_slot_index)
		else:
			var non_selected_panel = h_box_container.get_child(i)
			non_selected_panel.modulate = Color(1, 1, 1, 0.5)  # Set color to semi-transparent white

