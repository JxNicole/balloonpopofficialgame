extends Control

# --- Helper for robust node lookup ---
func _get_node_checked(path: String):
	var node = get_node_or_null(path)
	if node == null:
		push_error("Node not found: " + path)
	return node

# --- Node references ---
@onready var name_text_edit         = _get_node_checked("UI/VBoxContainer/Name Control/VBoxContainer/Name TextEdit")
@onready var username_text_edit     = _get_node_checked("UI/VBoxContainer/Name Control/VBoxContainer/Username TextEdit")
@onready var username_status_label  = _get_node_checked("UI/VBoxContainer/Name Control/VBoxContainer/Label")
@onready var age_text_edit          = _get_node_checked("UI/VBoxContainer/Age Control/VBoxContainer/Age TextEdit")
@onready var boy_button             = _get_node_checked("UI/VBoxContainer/Gender Control/VBoxContainer/Boy")
@onready var girl_button            = _get_node_checked("UI/VBoxContainer/Gender Control/VBoxContainer/Girl")
@onready var nb_button              = _get_node_checked("UI/VBoxContainer/Gender Control/VBoxContainer/Non-Binary")
@onready var http_request           = _get_node_checked("HTTPRequest")
@onready var next_button            = _get_node_checked("Button")

# --- State variables ---
var gender_choice: String = ""
var username_check_in_progress := false
var pending_username: String = ""
var username_is_available := false

func _ready():
	_reset_gender_buttons()
	if username_status_label:
		username_status_label.visible = false
	if username_text_edit:
		username_text_edit.text_changed.connect(_on_username_text_changed)
	if age_text_edit:
		age_text_edit.text_changed.connect(_on_age_text_changed)
	if boy_button:
		boy_button.pressed.connect(_on_gender_selected.bind(boy_button, "Boy"))
	if girl_button:
		girl_button.pressed.connect(_on_gender_selected.bind(girl_button, "Girl"))
	if nb_button:
		nb_button.pressed.connect(_on_gender_selected.bind(nb_button, "Non-Binary"))
	if next_button:
		next_button.pressed.connect(_on_button_pressed)
	if http_request:
		http_request.request_completed.connect(_on_request_completed)

# --- Gender Selection Logic ---
func _reset_gender_buttons():
	for b in [boy_button, girl_button, nb_button]:
		if b:
			b.button_pressed = false
			b.add_theme_color_override("font_color", Color.WHITE)

func _on_gender_selected(selected_button, selected_gender):
	gender_choice = selected_gender
	for b in [boy_button, girl_button, nb_button]:
		if b:
			b.button_pressed = false
			b.add_theme_color_override("font_color", Color.WHITE)
	if selected_button:
		selected_button.button_pressed = true
		selected_button.add_theme_color_override("font_color", Color.GREEN)

# --- Username: only allow valid chars, check uniqueness after 5 chars ---
func _on_username_text_changed():
	if not username_text_edit:
		return
	var username = username_text_edit.text.strip_edges()
	# Only allow a-z, A-Z, 0-9, _
	if not username.match("^[a-zA-Z0-9_]*$"):
		_set_status("Only letters, numbers, _", Color.RED)
		username_is_available = false
		return
	elif username.length() > 0 and username.length() < 5:
		_set_status("Username must be 5+ chars.", Color.RED)
		username_is_available = false
		return
	else:
		_hide_status()
		username_is_available = false

	# Only run availability check if pattern valid and >=5
	if username.length() >= 5:
		if username_check_in_progress:
			pending_username = username
			return
		_check_username_availability(username)



func _check_username_availability(username):
	username_check_in_progress = true
	pending_username = ""
	var check_url = "http://localhost:8080/check_username.php"
	var body = "username=" + username.uri_encode()
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	if http_request:
		http_request.request(
			check_url,
			headers,
			body.to_utf8_buffer(),
			HTTPClient.METHOD_POST
		)

# --- Age: just show warning if not number, but don't alter text ---
func _on_age_text_changed():
	if not age_text_edit: return
	var age = age_text_edit.text.strip_edges()
	if age != "" and not age.is_valid_int():
		_set_status("Age must be a number.", Color.RED)
	else:
		if username_status_label and username_status_label.text == "Age must be a number.":
			_hide_status()

# --- Main form submit validates strictly ---
func _on_button_pressed():
	var name = name_text_edit and name_text_edit.text.strip_edges() or ""
	var username = username_text_edit and username_text_edit.text.strip_edges() or ""
	var age = age_text_edit and age_text_edit.text.strip_edges() or ""
	if name == "" or username == "" or age == "" or gender_choice == "":
		push_error("All fields required.")
		_set_status("All fields required.", Color.RED)
		return
	if not age.is_valid_int() or int(age) < 1:
		push_error("Please enter a valid age.")
		_set_status("Please enter a valid age.", Color.RED)
		return
	if not username.is_match("^[a-zA-Z0-9_]{5,}$"):
		push_error("Username must be 5+ chars, only letters, numbers, _")
		_set_status("Choose a unique username.", Color.RED)
		return
	if not username_is_available:
		push_error("Username is not available.")
		_set_status("Choose a unique username.", Color.RED)
		return

	var post_data = []
	post_data.append("name=" + name.uri_encode())
	post_data.append("username=" + username.uri_encode())
	post_data.append("age=" + age.uri_encode())
	post_data.append("gender=" + gender_choice.uri_encode())
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
			push_error("Failed to start HTTP request.")
		else:
			next_button.disabled = true

# --- Handles both username and login POST responses ---
func _on_request_completed(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	if username_check_in_progress:
		username_check_in_progress = false
		var username = username_text_edit and username_text_edit.text.strip_edges() or ""
		if response_code == 200 and response_text.strip_edges() == "OK":
			_set_status("The username works!", Color.WHITE)
			username_is_available = true
		else:
			_set_status("Username not available", Color.RED)
			username_is_available = false
		if pending_username != "" and pending_username != username:
			_check_username_availability(pending_username)
		return

	next_button.disabled = false
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Network error.")
		_set_status("Network error.", Color.RED)
		return
	if response_code == 200 and response_text.begins_with("User saved successfully"):
		_set_status("Login data saved successfully!", Color.WHITE)
		# You can change scene here
	else:
		push_error("Server error %s: %s" % [response_code, response_text])
		_set_status("Server error.", Color.RED)

# --- Utility: Show/hide the status label ---
func _set_status(msg: String, color: Color):
	if username_status_label:
		username_status_label.text = msg
		username_status_label.visible = true
		username_status_label.add_theme_color_override("font_color", color)

func _hide_status():
	if username_status_label:
		username_status_label.visible = false
