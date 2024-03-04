extends Area2D

var velocity: int = 700


@onready var sprite = $AnimatedSprite2D
@onready var rotation_ball = sprite.rotation_degrees

func _ready() -> void:
	sprite.play("default")
	
func _physics_process(delta: float) -> void:
	global_position.x += velocity * delta
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.state < 4:
			GLOBAL.add_points(100)
		body.get_damage()
		queue_free()
	elif body.is_in_group("player"):
		GLOBAL.PLAYER_LIFES -= 1
		get_parent().reinstantiate_player()
		queue_free()
