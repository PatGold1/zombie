extends CharacterBody2D

class_name Player

signal toggle_inventory

@onready var animation_tree = $AnimationTree
@export var equip_inventory_data: InventoryDataEquip
@export var inventory_data: InventoryData
@export var speed: float = 100
@onready var sprite: Sprite2D = $Body  # Assuming your sprite node is named "Body"

var direction: Vector2 = Vector2.ZERO
var health: int = 50

func _ready() -> void:
	animation_tree.active = true
	PlayerManager.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		print("open inventory")
		toggle_inventory.emit()
		
	#if Input.is_action_just_pressed("interact"):
		#interact()

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		velocity = direction * speed
		update_sprite_direction()
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func update_sprite_direction():
	if direction.x < 0:
		sprite.scale.x = -1  # Flip the sprite if facing left
	else:
		sprite.scale.x = 1

func heal(heal_value) -> void:	
	health += heal_value
