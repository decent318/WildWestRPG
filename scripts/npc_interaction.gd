extends Area2D

var is_in_hitbox := false
var is_in_converstation := false
var is_speaking := false

func on_entered(body : Node2D): 
	is_in_hitbox = true
	player = body
func on_exited(_body : Node2D): is_in_hitbox = false

@onready var dialog = $dialog

@export_file("*.json") var Dialog
@export var Group := 0

var CurrentLine := 0
var player

func _input(_event):
	if is_in_hitbox:
		if Input.is_action_just_pressed("INTERACTION") and !is_speaking:
			is_in_converstation = true
			
			var json_data = JSON.parse_string(FileAccess.get_file_as_string(Dialog))
			var clump = json_data[Group]
			
			if CurrentLine == len(clump):
				dialog.visible = false
				player.frozen = false
				CurrentLine = 0
				return
			
			dialog.visible = true
			player.frozen = true
			dialog.set_speaker(clump[CurrentLine].speaker)
			if clump[CurrentLine].keys().find("color") != -1:
				dialog.set_color(clump[CurrentLine].color)
			else:
				dialog.set_color("ffffff")
			is_speaking = true
			await dialog.type_dialog(clump[CurrentLine].text)
			is_speaking = false
			CurrentLine += 1
