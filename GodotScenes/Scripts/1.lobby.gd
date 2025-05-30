extends Control

# const judge_play = "res://GodotScenes/2.Judge.tscn"
# const contestant_play = "res://GodotScenes/3.Contestant.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
# ----------------------------------------------

# var websocket_url = "TODO"
# var messageToSend = ""
# @onready var _client : WebsocketClient = $WebSocketClient

# func _connect_to_matchmaking_server() 
# 	var error = _client.connect_to_url[websocket_url])
# 	if error != OK:
# 		print("Error connecting to websocket: %s" % [websocket_url])

# func _ready()
# 	_connect_to_matchmaking_server()

#func _on_websocket_message_received(message): 
#	print("message received: %s" % message

# func _on_websocket_client_connection_close():
# 	var %s = _client.get_socket()
# 	print("client disconnected with code: %s, reason %s" % [ws.get_class_code(), ws.get_close_reason()])

# func _on_websocket_client_connected_to_server():
# 	print("client connected...")
