extends Node

#TODO FIXME!!

var users : Dictionary = {}

#const SQLITE = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
#var db
#var db_path = "res://DataStore/kirkja_authentication.db"
#var table_name = "users"

func _ready():
	# HACK: SQL testing.
	#db = SQLITE.new()
	#db.path = db_path
	
	InitializeUserDB()



func HasPlayer(username: String):
	return username in users

# Return the user's (hashed) password.
func UserData(username: String):
	if not (username in users): return null
	return users[username]


func SetUserPassword(username, hashed_password, salt) -> bool:
	users[username] = { "password": hashed_password, "salt": salt }
	return SaveUserDatabase()


#------------------------- Database operations -----------------------------

func InitializeUserDB():
	var player_data_file = File.new()
	if player_data_file.open("res://DataStore/UserData.json", File.READ) != OK:
		print ("Could not open user database.")
		return
	
	var json = JSON.new()
	var err = json.parse(player_data_file.get_as_text())
	player_data_file.close()

	if err == OK:
		print ("User database initialized.")
		users = json.get_data()
		print ("users: ", users)
	else:
		print ("Error parsing user database.")


func SaveUserDatabase() -> bool:
	var json = JSON.new()
	var content = json.stringify(users)
	var users_data_file = File.new()
	var err = users_data_file.open("res://DataStore/UserData.json", File.WRITE)
	if err != OK:
		return false
	users_data_file.store_string(content)
	users_data_file.close()
	print ("Users data saved to file.")
	return true # false would be database/sql error for instance


#func DB_QueryVitals(username: String):
#	return users[username]
#	#db.open_db()
#	#db.query("SELECT * FROM %s WHERE username = '%s'" % [table_name, username])
#	#return db.query_result

