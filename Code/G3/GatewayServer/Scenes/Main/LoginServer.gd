extends Node

func _on_LocalhostButton_pressed():
	Authenticate.ConnectToServer($LoginControl/VBoxContainer/LineEdit.get_text())
	$LoginControl.visible = false
