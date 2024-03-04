extends Control

func _ready() -> void:
	$AnimationPlayer.play("text_animation")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		GLOBAL.start_game()
