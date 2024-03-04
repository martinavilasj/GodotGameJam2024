extends Node

var PLAYER_LIFES: int = 3
var PLAYER_POINTS: int = 0

var ENEMY_VELOCITY: int
var ENEMY_ATTACK_VELOCITY: int

var menu_scene: String = "res://scenes/mainmenu.tscn"
var game_scene: String = "res://scenes/level_1.tscn"
var game_over_scene: String = "res://scenes/gameover.tscn"

func add_points(points: int) -> void:
	PLAYER_POINTS += points

func generate_powerup(position: Vector2) -> void:
	pass

func main_menu() -> void:
	get_tree().change_scene_to_file(menu_scene)

func start_game() -> void:
	restart_game()
	get_tree().change_scene_to_file(game_scene)

func game_over() -> void:
	get_tree().change_scene_to_file(game_over_scene)

func restart_game() -> void:
	PLAYER_LIFES = 3
	PLAYER_POINTS = 0
