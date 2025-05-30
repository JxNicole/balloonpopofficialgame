extends Node2D

var popped = false
var label = Label
var time = Timer
@export var RedClr : Color
@export var OrigClr : Color
@onready var sprite = $"CanvasLayer/MarginContainer/VBoxContainer/Panel/HBoxContainer/Blue Balloon"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = $"UI/Top Panel/Clock/Timer/Label"
	time = $"UI/Top Panel/Clock/Timer"
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
	pass

func update_label_text():
	label.text = str(ceil(time.time_left))
	

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://GodotScenes/5.Summary.tscn")
	
func _on_input_event(viewport, event, shape_idx):
	print("Input received!")
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
		if not popped:
			_pop()

func _pop():
	popped = true
	sprite.play("pop")
	sprite.connect("animation_finished", Callable(self, "_on_pop_finished"))
	
func _on_pop_finished():
	if popped:
		queue_free()
		get_tree().call_group("balloon_manager", "register_popped", self.name)
