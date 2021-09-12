tool
class_name Signpost
extends StaticBody

export(String, MULTILINE) var message: String = "" setget set_message
export(int, 25, 100) var font_size: int = 40 setget set_font_size
export(Color, RGB) var font_color: Color = Color.green setget set_font_color
#export(Color, RGB) var frame_color: Color = Color.whitesmoke setget set_frame_color

#export var max_width: float = 1.6 setget set_max_width
#export var max_height: float = 0.9 setget set_max_height


onready var FONT: Font = $Viewport/Control/Panel/TextEdit.get_font("font")

func set_message(value):
	message = value
	$Viewport/Control/Panel/TextEdit.text = message

func set_font_size(value):
	font_size = value	
	#FONT.size = font_size

func set_font_color(value):
	font_color = value
	$Viewport/Control/Panel/TextEdit/.set("custom_colors/font_color", font_color)
	print(font_color)

	
#func set_frame_color(value):
#
#	pass
	
#func set_max_width(value):
#	max_width = value
#
#func set_max_height(value):
#	max_height = value
	
	
#------------------------------------------------------------------------------
#func Initialize(primary: Color, secondary: Color) -> void:
#	var material: Material = $Post.get_surface_material(0)
#	material.set_shader_param("Color", primary)
#	material = $Bulb.get_surface_material(0)
#	material.set_shader_param("Color", secondary)
	
# TODO: Automatically size the width?
# TODO: 
