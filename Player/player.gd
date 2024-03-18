extends CharacterBody2D

class_name Player

signal toggle_inventory
signal toggle_external_inventory(external_inventory_owner)

var enemy_collision_range = false
var enemy_attack_cooldown = true
var player_alive = true
var direction: Vector2 = Vector2.ZERO
var health: int = 5000
var attack_ip = false
var attack_delay = 0.5	

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@export var equip_inventory_data: InventoryDataEquip
@export var inventory_data: InventoryData
@onready var external_inventory = $ExternalInventory
@export var speed: float = 100
@onready var label = $Label
@onready var sprite: Sprite2D = $Body  # Assuming your sprite node is named "Body"


func _ready() -> void:
	animation_tree.active = true
	PlayerManager.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		#get_tree().paused = true
		toggle_inventory.emit()
		
	if Input.is_action_just_pressed("interact"):
		print("open chesty boi")
		toggle_external_inventory.emit(self)

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	player_health(health)
	
	if health <= 0:
		player_alive = false #player dies
		health = 0
		print("player has been killed")
	
func player_movement(delta):
	var direction : Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	if attack_ip == false:
		if direction:
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
		
	update_sprite_direction(direction)
	move_and_slide()

func update_sprite_direction(direction):
	#if velocity == Vector2.ZERO:
		#animation_tree["parameters/conditions/idle"] = true
		#animation_tree["parameters/conditions/is_moving"] = false
	#else:
		#animation_tree["parameters/conditions/idle"] = false
		#animation_tree["parameters/conditions/is_moving"] = true
	#if direction.x > 0:
		#animation_player.play("walk_right")
	#elif direction.x < 0:                         
		#animation_player.play("walk_left")
	#elif direction.y < 0:
		#animation_player.play("walk_down")
	if direction.x < 0:
		sprite.scale.x = -1  # Flip the sprite if facing left
	else:
		sprite.scale.x = 1

func heal(heal_value) -> void:	
	health += heal_value

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_collision_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_collision_range = false

func enemy_attack():
	if attack_ip:
		if enemy_collision_range and enemy_attack_cooldown == true:
			health = health - 20
			enemy_attack_cooldown = false
			print(health)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	attack_ip = false
	
func attack():
	if Input.is_action_just_pressed("attack"):
		animation_player.play("sword_swipe")
		PlayerManager.player_current_attack = true
		$AttackCooldown.start()
		attack_ip = true
	
func player_health(health):
	health = str(health)
	label.set_text(health)
