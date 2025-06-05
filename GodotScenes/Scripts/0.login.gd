extends Control

# --- Utility for robust node lookup ---
func _get_node_checked(path: String):
	var node = get_node_or_null(path)
	if node == null:
		push_error("Node not found: " + path)
	return node

# --- Node references (adjust if you move nodes!) ---
@onready var age_text_edit = _get_node_checked("Age TextEdit") # update path to match your node!
@onready var status_label  = _get_node_checked("Label") # For errors/info
@onready var http_request  = _get_node_checked("HTTPRequest")
@onready var next_button   = _get_node_checked("Button")

# --- Ready: Connect everything ---
func _ready():
	if status_label: status_label.visible = false
	if age_text_edit: age_text_edit.text_changed.connect(_on_age_text_changed)
	if next_button: next_button.pressed.connect(_on_next_pressed)
	if http_request: http_request.request_completed.connect(_on_request_completed)

# --- Allow only digits in age field ---
func _on_age_text_changed():
	if not age_text_edit: return
	var age = age_text_edit.text
	var digits = ""
	for c in age:
		if c.is_digit():
			digits += c
	if age != digits:
		age_text_edit.text = digits

# --- On Next, validate & submit ---
func _on_next_pressed():
	var age = age_text_edit and age_text_edit.text.strip_edges() or ""
	if age == "" or not age.is_valid_int() or int(age) < 1:
		_set_status("Please enter a valid age.", Color.RED)
		return
	# Compose POST data (you probably want to keep all values in a singleton or pass them!)
	var post_data = []
	post_data.append("age=" + age.uri_encode())
	# ...append other fields as needed (e.g., name, username, gender) from previous steps
	var body = post_data.join("&")
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	if http_request:
		var err = http_request.request(
			"http://localhost:8080/save_user.php",
			headers,
			body.to_utf8_buffer(),
			HTTPClient.METHOD_POST
		)
		if err != OK:
			_set_status("Failed to start HTTP request.", Color.RED)
		else:
			next_button.disabled = true

# --- Handle HTTP response ---
func _on_request_completed(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	next_button.disabled = false
	if result != HTTPRequest.RESULT_SUCCESS:
		_set_status("Network error.", Color.RED)
		return
	if response_code == 200 and response_text.begins_with("User saved successfully"):
		# Go to gender screen!
		get_tree().change_scene_to_file("res://GodotScenes/0.Login1C.tscn")
	else:
		_set_status("Server error: " + response_text, Color.RED)

# --- Status label ---
func _set_status(msg: String, color: Color):
	if status_label:
		status_label.text = msg
		status_label.visible = true
		status_label.add_theme_color_override("font_color", color)
