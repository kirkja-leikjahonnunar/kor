extends Node
# Hue shift page - https://godotengine.org/qa/5393/how-to-create-color-transition-sprite-around-the-color-wheel
# Mad props to the Game Development Center.
const PROPS_LINK = "https://youtu.be/gcopx40pwvY"

onready var PATH_INPUT = $Control/HBoxContainer/VBoxContainer2/HBoxContainer/PathInput
onready var BG = $Control/Background
onready var COLOR_BUTTON = $Control/HBoxContainer/VBoxContainer/ColorPickerButton
onready var SPEED_SLIDER = $Control/HBoxContainer/VBoxContainer/SpeedSlider

var hue_timer: float = 0.0
var speed: float = 60.0 # Degree increment per second around the color wheel.
var speed_multiplier: float = 1.0

# ----------------------Godot Docs---------------------------------------------
# X509Certificate generate_self_signed_certificate(
#	key: CryptoKey,
#	issuer_name: String = "CN=myserver,O=myorganisation,C=IT",
#	not_before: String  = "20140101000000",
#	not_after: String   = "20340101000000")

var X509_cert_filename: String = "X509Certificate.crt"
var X509_key_filename: String = "X509Key.key"
var X509_cert_path: String
var X509_key_path: String


#"CN=myserver,O=myorganisation,C=IT"
# Sending it all in one long string.
export var CN         = "KirkjaOnline"		# Common Name.
export var O          = "Kirkja"			# Organization.
export var C          = "US"				# Country code.
export var not_before = "20211013000000"	# 2021-10-01.
export var not_after  = "20221013000000"	# 2022-10-01.


func _ready():
	X509_cert_path = PATH_INPUT.text + X509_cert_filename
	X509_key_path = PATH_INPUT.text + X509_key_filename
	speed_multiplier = SPEED_SLIDER.value
	
	
func _process(delta_time: float):
	hue_timer = fmod(hue_timer + delta_time * speed * speed_multiplier, 360.0)
	COLOR_BUTTON.color.h = hue_timer / 360.0 # h, s, v, are 0 - 1 range floats.
	BG.color.h = COLOR_BUTTON.color.h
	

func Create509Cert():
	# Existing directory?
	var directory = Directory.new()
	if directory.dir_exists(PATH_INPUT.text):
		pass
	else:
		directory.make_dir(PATH_INPUT.text)
	
	var CNOC = "CN=" + CN + ",O=" + O + ",C=" + C
	var crypto = Crypto.new()
	var crypto_key = crypto.generate_rsa(4896)
	var X509Cert = crypto.generate_self_signed_certificate(crypto_key, CNOC, not_before, not_after)
	X509Cert.save(X509_cert_path)
	crypto_key.save(X509_key_path)


func _on_FileDialogButton_pressed():
	pass # Replace with function body.


func _on_ColorPickerButton_color_changed(color):
	BG.color = color


func _on_CreateCertificate_pressed():
	Create509Cert()
	print("Certificate created.")


func _on_SpeedSlider_value_changed(value):
	speed_multiplier = value


func _on_PropsButton_pressed():
	OS.shell_open(PROPS_LINK)

	

