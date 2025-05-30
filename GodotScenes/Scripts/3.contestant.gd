extends Control
var label = Label
var time = Timer
@export var RedClr : Color
@export var OrigClr : Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = $Clock/Timer/Label
	time = $Clock/Timer
	OrigClrRed()
	time.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_label_text()
	
	if time.time_left <= 5:
		label.modulate = RedClr
	else:
		OrigClrRed()

func OrigClrRed():
	label.modulate = OrigClr

func update_label_text():
	label.text = str(ceil(time.time_left))

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://GodotScenes/loading.tscn")
