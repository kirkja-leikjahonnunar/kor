extends Node

var X509_cert_filename = "X509_Certificate.crt"
var X509_key_filename = "X509_Key.key"
@onready var X509_cert_path = "user://Certificate/" + X509_cert_filename
@onready var X509_key_path = "user://Certificate/" + X509_key_filename

var CN = "Kirkja.org"
var O = "Kirkja"
var C = "US"
var not_before = "20220101000000" #TODO: these dates need to be meaningful
var not_after = "20300101000000"  #See Godot Dev Center tutorial: https://www.youtube.com/watch?v=gcopx40pwvY&list=PLZ-54sd-DMAKU8Neo5KsVmq8KtoDkfi4s&index=8


func _ready():
	var directory = Directory.new()
	if directory.dir_exists("user://Certificate"):
		pass
	else:
		directory.make_dir("user://Certificate")
	CreateX509Cert()
	print("Certificate created!")


func CreateX509Cert():
	var CNOC = "CN=" + CN + ",O=" + O + ",C=" + C
	var crypto = Crypto.new()
	var crypto_key = crypto.generate_rsa(4096)
	var X509_cert = crypto.generate_self_signed_certificate(crypto_key, CNOC, not_before, not_after)
	X509_cert.save(X509_cert_path)
	crypto_key.save(X509_key_path)
	
	# NOTE: on Windows, this will save in %appdata%/Roaming/Godot/app_userdata/X509CertificateGenerator/Certificate


