extends CharacterBody2D

var speed = 10
var player_chase = false
var player = null


func _physics_process(delta):
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

#func _on_detection_area_body_exited(body):
	#player = null
	#player_chase = false
