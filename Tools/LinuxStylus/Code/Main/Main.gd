extends Control

func _on_Blender_pressed():
	OS.execute("/home/unblinky/Kirkja/kor/Tools/LinuxStylus/Code/BashScripts/blender.sh", [])
	print("Loading Blender pen preferences.")

func _on_Krita_pressed():
	OS.execute("/home/unblinky/Kirkja/kor/Tools/LinuxStylus/Code/BashScripts/krita.sh", [])
	print("Loading Krita pen preferences.")
