extends Node


func move(target):
	var move_tween = create_tween()
	move_tween.tween_property(self, "position",target, .7)
