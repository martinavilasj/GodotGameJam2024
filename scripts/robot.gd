extends CharacterBody2D

var move_speed = 250
var max_speed = 300

var gravity = 30
var jump_velocity = -800

@onready var sprite = $AnimatedSprite2D

var snowball_scene = preload("res://scenes/snowball.tscn")

var enemy_ball_in_area = false
var enemy

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	velocity.y += gravity
	
	var friction = false
	
	if GLOBAL.PLAYER_LIFES == 0:
		GLOBAL.game_over()
	
	if Input.is_action_pressed("move_right"):
		sprite.play("run")
		sprite.flip_h = false
		velocity.x = min(velocity.x + move_speed, max_speed)
	elif Input.is_action_pressed("move_left"):
		sprite.play("run")
		sprite.flip_h = true
		velocity.x = max(velocity.x - move_speed, -max_speed)
	else:
		friction = true
		sprite.play("shoot")
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		sprite.play("jump")
		velocity.y = jump_velocity
		
	if Input.is_action_just_pressed("push_enemy") and enemy_ball_in_area:
		enemy.state = 5
		enemy.sprite.flip_h = sprite.flip_h
	
	if is_on_floor():			
		if friction:
			velocity.x = lerp(velocity.x, 0.0, 0.5)
	else:
		if friction:
			velocity.x = lerp(velocity.x, 0.0, 0.01)
			
	if Input.is_action_just_pressed("shoot"):
		sprite.play("attack")
		shooting()
	
	move_and_slide()

func shooting():
	var snowball = snowball_scene.instantiate()
	if sprite.flip_h:
		$shoot_position.scale.x = -1
		snowball.velocity = -snowball.velocity
		snowball.rotation_degrees = 0
	else:
		$shoot_position.scale.x = 1
	
	snowball.global_position = $shoot_position/Marker2D.global_position	
	get_parent().add_child(snowball)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.state == 4:
			enemy_ball_in_area = true
			enemy = body
		#elif body.state < 4:
		#	GLOBAL.PLAYER_LIFES -= 1
		#	get_parent().reinstantiate_player()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_ball_in_area = false

func get_damage():
	GLOBAL.PLAYER_LIFES -= 1
