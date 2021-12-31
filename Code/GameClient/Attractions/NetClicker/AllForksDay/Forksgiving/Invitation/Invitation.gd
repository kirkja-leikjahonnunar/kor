extends Control

onready var USERNAME_UI := $h_box/user_container/username

func Update(net_player: NetPlayer):
	USERNAME_UI.text = net_player.my_name

func _on_edit_ndp_button_pressed():
	USERNAME_UI.editable = !USERNAME_UI.editable

func _on_rsvp_button_pressed():
	visible = false
	get_parent().is_running = true # Node Jump.
