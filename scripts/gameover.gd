extends Control

@onready var score = $score

func _ready() -> void:
	$AnimationPlayer.play("text_press")
	score.text = "SCORE: " + str(GLOBAL.PLAYER_POINTS)
func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		GLOBAL.main_menu()
