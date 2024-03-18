extends CharacterBody2D

@onready var label = $Label
const world = preload("res://Scenes/world.tscn")

var speed = 10
var player_chase = false
var player = null
var health = 50
@export var knock_back_amount = 20
var player_collision_range = false
var can_take_damage = true
@onready var take_damage = $TakeDamage


func _physics_process(delta):
	deal_with_damage()
	movement_logic(delta)
	zombie_health(health)
	
func movement_logic(delta):
	if player_chase and player != null:
		var direction = (player.position - position).normalized()
		var collision = move_and_collide(direction * speed * delta)
		$AnimatedSprite2D.play("default")
		
		if collision:
			# If the zombie collides with something, move in a random direction
			direction = (player.position - position).normalized()
			move_and_collide(direction * speed * delta)
		
		if(player.position.x - position.x) > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func enemy():
	pass

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player_collision_range = true

func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		player_collision_range = false

func deal_with_damage():
	if player_collision_range and PlayerManager.player_current_attack == true:
		if can_take_damage == true and Input.is_action_just_pressed("attack"):
			health -= 20
			apply_knockback()
			take_damage.start()
			can_take_damage = false
			print("zombie heath = ", health)
			if health <= 0:
				WorldStats.add_to_kill_counter()
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
func apply_knockback():
	if player != null:
		var knockback_direction = (position - player.position).normalized()
		move_and_collide(knockback_direction * knock_back_amount)
		$AnimatedSprite2D.play("knockback")
	
func zombie_health(health):
	health = str(health)
	label.set_text(health)
