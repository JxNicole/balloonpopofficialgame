extends Control

# const SERVER_PORT = 8080
# const SERVER_IP = "127.0.0.1"

# const lobby = "res://GodotScenes/1.Lobby.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	# if OS.has_feature("dedicated_server"):
	# if this is a dedicated server, run as a server
	# _on_host_pressed()

func _on_host_pressed():
	# print ("host pressed")
	# var peer = ENetMultiplayerPeer.new()
	# peer.create_server(SERVER_PORT)
	# multiplayer.multiplayer_peer = peer
	# start_game()
	pass

func start_game():
	# $UI.hide
	# if multiplayer.is_server():
		# print("server changing to gameplay scene...")
		# change_level.call_deferred(load(lobby))
	pass

func change_game_play(scene: PackedScene):
	# var game_play = $??? (level)
	# for c in game.get_children():
		# game.remove_child(c)
		# c.queue_free()
		
	# game.add_child(scene.instantiate())
	pass

func _on_client_pressed():
	# print ("client pressed")
	# var = ENetMultiplayerPeer.new()
	# peer.create_client(SERVER_IP, SERVER_PORT)
	# multiplayer.multiplayer_peer = peer
	# start_game()
	pass

func _on_join_game_pressed():
	# print("join game pressed.")
	# $UI.hide()
	# TODO: go to lobby scene (or gameplay?) 
	# load lobby scene into lobby placeholder
	# $LobbyPlaceholder.add_child(lobby.instantiate())
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://GodotScenes/1.Lobby.tscn")
