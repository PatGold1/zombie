extends CharacterBody2D

class_name Player

signal toggle_inventory

var enemy_collision_range = false
var enemy_attack_cooldown = true
var player_alive = true
var direction: Vector2 = Vector2.ZERO
var health: int = 150
var attack_ip = false

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@export var equip_inventory_data: InventoryDataEquip
@export var inventory_data: InventoryData
@export var speed: float = 100
@onready var sprite: Sprite2D = $Body  # Assuming your sprite node is named "Body"


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
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		player_alive = false #player dies
		health = 0
		print("player has been killed")
	
func player_movement(delta):
	var direction : Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
	update_sprite_direction()
	move_and_slide()

func update_sprite_direction():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	#if direction.x > 0:
		#print("right")
		#animation_player.play("walk_right")
	#elif direction.x < 0:
		#print("left")                                   
		#animation_player.play("idle_left")
	#elif direction.y < 0:
		#print("down")
		#animation_player.play("walk_down")
	#if direction.x < 0:
		#sprite.scale.x = -1  # Flip the sprite if facing left
	#else:
		#sprite.scale.x = 1

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
	if enemy_collision_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$AttackCooldown.start()
		print(health)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
func attack():
	if Input.is_action_just_pressed("attack"):
		PlayerManager.player_current_attack = true
		attack_ip = true

func _on_deal_attack_cooldown_timeout():
	$DealAttackCooldown.stop()
	PlayerManager.player_current_attack = false
