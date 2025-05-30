extends Control

@onready var label: Label = $"Q test Label"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move(target):
	var move_tween = create_tween()
	move_tween.tween_property(self, "position",target, .7)


func _on_line_edit_text_submitted(new_text: String) -> void:
	label.text = "The question for this round is: " + new_text
