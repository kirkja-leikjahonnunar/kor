extends Node

#TODO FIXME!!

var skill_data : Dictionary

#const SQLITE = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
#var db
#var db_path = "res://DataStore/kirkja_authentication.db"
#var table_name = "users"

func _ready():
	# HACK: SQL testing.
	#db = SQLITE.new()
	#db.path = db_path
	
	# MAJOR HACK!!!!!!!!!
	skill_data = {"user1": "pwd1", "user2": "pwd2"}


func HasPlayer(username: String):
	return username in skill_data
	#return skill_data.has(username)

func UserPassword(username: String):
	if not (username in skill_data): return ""
	return skill_data[username]


func DB_QueryVitals(username: String):
	return skill_data[username]
	#db.open_db()
	#db.query("SELECT * FROM %s WHERE username = '%s'" % [table_name, username])
	#return db.query_result

#func _ready():
#	var player_data_file = File.new()
#	player_data_file.open("res://Data/PlayerTable - PlayerData.json", File.READ)
#	var player_data_json = JSON.parse(player_data_file.get_as_text())
#	player_data_file.close()
#	player_data = player_data_json.result
