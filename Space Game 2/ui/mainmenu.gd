extends Control


func _on_button_pressed() -> void:
	var game = load("res://game/game_area.tscn").instantiate()
	get_parent().add_child(game)
	queue_free()
