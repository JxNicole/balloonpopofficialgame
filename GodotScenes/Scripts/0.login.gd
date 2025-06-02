# File: res://GodotScenes/Scripts/0.login.gd
extends Control

const LOBBY_SCENE_PATH = "res://GodotScenes/1.Lobby.tscn"
const SAVE_URL        = "http://localhost:8080/save_user.php"

func _ready() -> void:
	print(">>> Login Control _ready() is running!")
	$HTTPRequest.connect("request_completed", Callable(self, "_on_HTTPRequest_request_completed"))


# This name must match exactly what the editor shows under pressed() for your Button node:
func _on_button_pressed() -> void:
	print(">>> Next button was pressed!")  # <— This line should appear in Output when you click Next

	var name_text     = $"UI/VBoxContainer/Name Control/VBoxContainer/Name TextEdit".text
	var username_text = $"UI/VBoxContainer/Name Control/VBoxContainer/Username TextEdit".text

	if username_text.strip_edges() == "":
		print("Username is required!")
		return

	# (Optionally, show that “username works” label here, if you want)
	$"UI/VBoxContainer/Name Control/VBoxContainer/Label".visible = true

	var post_data = []
## FAILS HERE
	post_data.append("username=" + username_text.percent_encode())
	post_data.append("bio="      + name_text.percent_encode())
	var body = "&".join(post_data)

	var err = $HTTPRequest.request(
		SAVE_URL,
		[],
		false,
		HTTPClient.METHOD_POST,
		body
	)
	if err != OK:
		print("Failed to send request:", err)
	else:
		print("Request sent to server!")
		
	get_tree().change_scene_to_file("res://GodotScenes/1.Lobby.tscn")



func _on_HTTPRequest_request_completed(result, response_code, headers, body) -> void:
	var server_response = body.get_string_from_utf8()
	print("Server response:", server_response)

	if server_response.begins_with("User saved successfully"):
		get_tree().change_scene_to_file(LOBBY_SCENE_PATH)
	else:
		print("Unexpected server response, staying on login.")

func _process(delta: float) -> void:
	pass
