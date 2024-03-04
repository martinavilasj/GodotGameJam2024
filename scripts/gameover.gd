extends Control

@onready var score = $score
@onready var game_over_sound = $AudioStreamPlayer

func _ready() -> void:
	$AnimationPlayer.play("text_press")
	game_over_sound.play()
	score.text = "SCORE: " + str(GLOBAL.PLAYER_POINTS)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		GLOBAL.main_menu()
