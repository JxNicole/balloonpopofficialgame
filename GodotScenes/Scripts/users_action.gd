extends Control

var users_origin_position := Vector2.ZERO
var users_origin_size := Vector2.ZERO

var users_transition_time = 0.5

var current_user
var user_stack := []

@onready var player_1: MarginContainer = $"Player 1"
@onready var player_2: MarginContainer = $"Player 2"
@onready var player_3: MarginContainer = $"Player 3"
@onready var end_label: Label = $EndLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	users_origin_position = Vector2(0,0)
	users_origin_size = get_viewport_rect().size
	current_user = player_1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func move_next_user(next_user_id: String):
	var next_user = get_user_from_user_id(next_user_id)
	if next_user == null or current_user == null:
		print("Error: next_user or current_user is null!")
		return
	#current_user.position = Vector2(-users_origin_size.x, 0)
	#next_user.position = users_origin_position
	var tween = create_tween()
	tween.parallel().tween_property(next_user, "position", users_origin_position, users_transition_time)
	tween.parallel().tween_property(current_user, "position", Vector2(-users_origin_size.x, 0), users_transition_time)
	user_stack.append(current_user)
	current_user = next_user

func move_prev_user():
	var previous_user = user_stack.pop_back()
	var tween = create_tween()
	if previous_user != null:
		tween.parallel().tween_property(previous_user, "position", users_origin_position, users_transition_time)
		tween.parallel().tween_property(current_user, "position", Vector2(users_origin_size.x, 0), users_transition_time)
		current_user = previous_user
	elif previous_user == null or current_user == null:
		print("Error: previous_user or current_user is null!")
		return
		#previous_user.position = users_origin_position
		#current_user.position = Vector2(users_origin_position.x, 0)
	
func get_user_from_user_id(user_id: String) -> Control:
	match user_id:
		"user_1":
			return player_1
		"user_2":
			return player_2
		"user_3":
			return player_3
	print("Warning: Unknown user_id ", user_id)
	return player_1

func _on_next_button_pressed() -> void:
	if current_user == player_1:
		move_next_user("user_2")
	elif current_user == player_2:
		move_next_user("user_3")


func _on_back_button_pressed() -> void:
	move_prev_user()


func _on_timer_timeout() -> void:
	print("Timer has finished")
