extends Area2D

var popped = false
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle")
	self.connect("input_event", Callable(self,"_on_input_event"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed and not popped:
			_pop()
	
	
func _pop():
	popped = true
	sprite.play("pop")
	sprite.connect("animation_finished", Callable(self, "_on_pop_finished"))
	
func _on_pop_finished():
	if popped:
		queue_free()
		get_tree().call_group("balloon_manager", "register_popped", self.name)
