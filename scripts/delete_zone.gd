extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.state == 5:
			GLOBAL.add_points(1000)
			body.delete_enemy()
