extends Node
# BalloonManager.gd
var popped_balloons = {}

func register_popped(balloon_name):
	popped_balloons[balloon_name] = true
