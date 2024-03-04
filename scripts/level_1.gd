extends Node2D

@onready var lifes_text = $UI/lifes
@onready var points_text = $UI/points

var player_scene = preload("res://scenes/robot.tscn")
var player

var enemies = [
	preload("res://scenes/zombie.tscn"),
	preload("res://scenes/male.tscn"),
	preload("res://scenes/female.tscn")]

@onready var positions = [
	$posiciones/posicion1.position,
	$posiciones/posicion2.position,
	$posiciones/posicion3.position,
	$posiciones/posicion4.position,
	$posiciones/posicion5.position,
	$posiciones/posicion6.position
]

func _ready() -> void:
	randomize()
	instantiate_player()
	instantiate_all_enemies()

func _process(delta: float) -> void:
	lifes_text.text = str(GLOBAL.PLAYER_LIFES)
	points_text.text = str(GLOBAL.PLAYER_POINTS)

func instantiate_player():
	player = player_scene.instantiate()
	player.position = $player_spawn.position
	add_child(player)

func reinstantiate_player():
	if player:
		player.queue_free()
		instantiate_player()

func instantiate_all_enemies() -> void:
	for p in positions:
		var enemy = enemies[randi() % 3].instantiate()
		enemy.position = p
		enemy.map_position = positions.find(p,0)
		add_child(enemy)

func regenerate_enemy(index_position: int) -> void:
	var timer = Timer.new()
	timer.timeout.connect(add_enemy.bind(index_position))
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
func add_enemy(index: int):
	var enemy = enemies[randi() % 3].instantiate()
	enemy.position = positions[index]
	enemy.map_position = index
	add_child(enemy)
