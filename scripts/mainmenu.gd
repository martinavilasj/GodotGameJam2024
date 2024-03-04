extends Control

@onready var start_sound = $start

func _ready() -> void:
	$AnimationPlayer.play("text_animation")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		start_sound.play()
		await start_sound.finished
		GLOBAL.start_game()
