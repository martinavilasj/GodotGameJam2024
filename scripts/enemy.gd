extends CharacterBody2D

signal attack_finished

@onready var sprite = $AnimatedSprite2D

@onready var left_sensor = $left_sensor
@onready var right_sensor = $right_sensor
@onready var floor_r_sensor = $floor_r_sensor
@onready var floor_l_sensor = $floor_l_sensor
@onready var right_prox_sensor = $right_prox_sensor
@onready var left_prox_sensor = $left_prox_sensor

@onready var sprite_colision = $CollisionShape2D

# Timer para controlar los estados
@onready var timer = $Timer

var move_speed = 100
var max_speed = 150

var gravity = 30
var jump_velocity = -800

var snowball_scene = preload("res://scenes/snowball.tscn")

var snowball_amount = 0

# Estados para controlar la vida del enemigo 
# state = 0: Normal, no ha sido atacado
# state = 1: Atacado por una sola vez
# state = 2: Atacado dos veces consecutivas
# state = 3: Atacado tres veces consecutivas
# state = 4: Atacado 4 veces, listo para eliminar
# state = 5: Estado de bola de nieve, impulsada
# state = 6: Enemigo eliminado por bola 
var state = 0

var is_shooting = false

# Index para saber la posicion en la que aparece al principio en el mapa
var map_position: int

var speed_attack: float = 1.0

@onready var punch_sound = $punch

func _ready() -> void:
	move_speed = GLOBAL.ENEMY_VELOCITY
	max_speed = move_speed * 1.5
	speed_attack = GLOBAL.ENEMY_ATTACK_VELOCITY
	right_sensor.target_position.x = GLOBAL.ENEMY_VISION
	left_sensor.target_position.x = -GLOBAL.ENEMY_VISION

func _process(delta: float) -> void:
	velocity.y += gravity
	
	# Verificar estado del enemigo
	if state == 0: # Estado normal del enemigo
		#if is_shooting:
		#	await attack_finished
		if detect_player():
			shooting()
		else:
			if move_speed >= 250:
				sprite.play("run")
			else:
				sprite.play("walk")
			detect_precipice()
			detect_wall()
			move_enemy()
			move_and_slide()
	elif state == 5:
		move_speed = 900
		max_speed = 1000
		sprite.play("state5")
		detect_wall()
		move_enemy()
		move_and_slide()
	elif state == 6:
		gravity = 20
		enemy_deleted_by_ball()
		move_and_slide()
	else:# A cada estado se le asigna una animacion
		sprite.play("state{state}".format({"state": state}))
	

func detect_precipice() -> void:
	if not floor_l_sensor.is_colliding():
		sprite.flip_h = false
	elif not floor_r_sensor.is_colliding():
		sprite.flip_h = true

func detect_wall():
	if right_prox_sensor.is_colliding():
		sprite.flip_h = true
	elif left_prox_sensor.is_colliding():
		sprite.flip_h = false

func detect_player() -> bool:
	if sprite.flip_h:
		if left_sensor.is_colliding():
			var collider = left_sensor.get_collider()
			if collider:
				if collider.is_in_group("player"):
					return true
	else:
		if right_sensor.is_colliding():
			var collider = right_sensor.get_collider()
			if collider:
				if collider.is_in_group("player"):
					return true
	return false

func move_enemy() -> void:
	if !sprite.flip_h:
		velocity.x = min(velocity.x + move_speed, max_speed)
	else:
		velocity.x = max(velocity.x - move_speed, -max_speed)

func shooting():
	is_shooting = true
	sprite.play("attack", speed_attack)
	print()
	await sprite.animation_finished

func get_damage():
	if state < 4:
		state += 1
	timer.start()

func _on_timer_timeout() -> void:
	if state > 0 and state < 5:
		state -= 1
		timer.start()

func _on_animated_sprite_2d_animation_finished() -> void:
	var snowball = snowball_scene.instantiate()
	if sprite.flip_h:
		$shoot_position.scale.x = -1
		snowball.velocity = -snowball.velocity
		snowball.rotation_degrees = 0
	else:
		$shoot_position.scale.x = 1
		
	snowball.global_position = $shoot_position/Marker2D.global_position	
	get_parent().add_child(snowball)
	#attack_finished.emit()
	is_shooting = false

func delete_enemy():
	GLOBAL.ENEMY_VELOCITY += 5
	GLOBAL.ENEMY_ATTACK_VELOCITY += 0.2
	GLOBAL.ENEMY_VISION += 25
	get_parent().regenerate_enemy(map_position)
	queue_free()
	
func enemy_deleted_by_ball():
	sprite_colision.disabled = true
	sprite.play("state6")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.state == 5:
			punch_sound.play()
			GLOBAL.add_points(1500)
			# Pasar al estado 6 para reproducir animacion muerte
			state = 6

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	delete_enemy()
