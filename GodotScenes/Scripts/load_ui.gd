extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move(target):
	#var move_tween = get_tree().create_tween()
	#move_tween.tween_property(self, "position", target, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var move_tween = create_tween()
	move_tween.tween_property(self, "position",target, 1)
