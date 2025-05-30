extends Control

var count = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_node("Player 1").move(Vector2(-1080,0))
	get_node("Player 2").move(Vector2(0,0))
	get_node("Player 3").move(Vector2(1080,0))
	get_node("label").move(Vector2(3500,400))
	
	get_node("Player 1").move(Vector2(-2185,0))
	get_node("Player 2").move(Vector2(-1080,0))
	get_node("Player 3").move(Vector2(0,0))
	get_node("label").move(Vector2(2185,400))
	# pressed again 3/3
	get_node("Player 1").move(Vector2(-3500,0))
	get_node("Player 2").move(Vector2(-2185,0))
	get_node("Player 3").move(Vector2(-1080,0))
	get_node("label").move(Vector2(100,500))
