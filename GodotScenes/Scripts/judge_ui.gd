extends Control
@onready var label: Label = $"Input UI/Label"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_node("Input UI").move(Vector2(-1080,0))
	get_node("Thanks Label").move(Vector2(0,700))


func _on_line_edit_text_submitted(new_text: String) -> void:
	label.text = "The question for this round is " + new_text
