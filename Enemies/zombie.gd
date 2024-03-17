extends CharacterBody2D

@onready var label = $Label

var speed = 10
var player_chase = false
var player = null
var health = 100
@export var knock_back_amount = 10
var player_collision_range = false
var can_take_damage = true

func _physics_process(delta):
	deal_with_damage()
	movement_logic(delta)
	zombie_health(health)
	
func movement_logic(delta):
	if player_chase:
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2(0,0)) 
		#position += (player.position - position)/speed
		$AnimatedSprite2D.play("default")
		
		if(player.position.x - position.x) > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func enemy():
	pass
#
#func _on_detection_area_body_exited(body):
	#player = null
	#player_chase = false


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player_collision_range = true

func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		player_collision_range = false

func deal_with_damage():
	if player_collision_range and PlayerManager.player_current_attack == true:
		if can_take_damage == true:
			health -= 20
			apply_knockback()
			$TakeDamageCooldown.start()
			can_take_damage = false
			print("zombie heath = ", health)
			if health <= 0:
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
func apply_knockback():
	var knockback_direction = (position - player.position).normalized()
	position += knockback_direction * knock_back_amount
	move_and_collide(Vector2(0,0)) 
	#position += knockback_direction * 100
	$AnimatedSprite2D.play("knockback")
	
func zombie_health(health):
	health = str(health)
	label.set_text(health)
