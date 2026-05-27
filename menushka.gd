extends Node2D
#const prol = preload("res://1_room.tscn")
func _on_exit_pressed() -> void:
	get_tree().quit()
	
func _on_play_pressed() -> void:
	#get_tree().change_scene_to_file("res://BossRoom.tscn")
	get_tree().change_scene_to_file("res://prolog.tscn")
	#get_tree().change_scene_to_packed(prol)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
