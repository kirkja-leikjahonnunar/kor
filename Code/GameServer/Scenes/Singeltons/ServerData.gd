extends Node

const SQLITE = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "res://DataStore/kirkja"
var skill_data
var stats_data

func _ready():
	# HACK: SQL testing.
	db = SQLITE.new()
	db.path = db_path


#------------------------------------------------------------------------------
# Net Clicker Database Functions
#------------------------------------------------------------------------------
var table_name = "nc_player_table"

func DB_GetPlayerData(username: String):
	db.open_db()
	db.query("SELECT * FROM %s WHERE Name = '%s'" % [table_name, username])
	
	#print("Printing QUERY: %s" % db.query_result[0]["ID"])
	
	return db.query_result
	

func DB_GetPlayerClicks(player_db_id: int) -> int:
	db.open_db()
	db.query("SELECT Name, Clicks FROM %s WHERE ID = %s;" % [table_name, player_db_id])
	
	var player_name = db.query_result[0]["Name"]
	var player_clicks = db.query_result[0]["Clicks"]
	print("Player: %s has clicked %s times." % [player_name, player_clicks])
	
	return player_clicks
	#"select PlayerInfo.Name as pname, ItemInventory.Name as iname from PlayerInfo left join ItemInventory on PlayerInfo.ID = ItemInventory.PlayerID where PlayerInfo.ID = " + str(id))

	
func DB_UpdateClicks(player_db_id: int, delta_score: int):
	db.open_db()

	var clicks: int = DB_GetPlayerClicks(player_db_id)
	db.query("UPDATE %s SET Clicks = %s WHERE ID = %s;" % [table_name, clicks + delta_score, player_db_id])


#-------------------------
# Returns a full DB table.
#-------------------------
func DB_GetAllPlayersData():
	db.open_db()
	db.query("SELECT * FROM " + table_name)
	return db.query_result
	
	# TODO: Not in the tut! Why?
#	if get_node("TextureRect").texture != null:
#		SaveTextureToDB(get_node("TextureRect").texture)
#	else:
#		print("Null texture.")


	#CommitDataToDB()
#	ReadFromDB()
	#var item_result = GetItemsByUser(2)

	# Skill Data.
#	var skill_data_file = File.new()
#	skill_data_file.open("res://Data/SkillData - Sheet1.json", File.READ)
#	var skill_data_json = JSON.parse(skill_data_file.get_as_text())
#	skill_data_file.close()
#	skill_data = skill_data_json.result
#
#	# Stats Data
#	var stats_data_file = File.new()
#	stats_data_file.open("res://Data/StatsData - Stats.json", File.READ)
#	var stats_data_json = JSON.parse(stats_data_file.get_as_text())
#	stats_data_file.close()
#	stats_data = stats_data_json.result



#	var dict: Dictionary = Dictionary()
#	dict["Name"] = "Charlie"
#	dict["Score"] = 560

	#db.insert_row(table_name, dict)
	

#==============================================================================
# HACK: Trying out SQLite code. Not sure it goes here.
#
#const SQLITE = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
#var db
#var db_name = "res://DataStore/kirkja" # Path to db.
#
#export var texture: Texture
#
#
#func SaveTextureToDB(_texture: Texture):
#	var tex = _texture.get_data()
#	var tex_data = {"Width": tex.get_width(),
#	"Height": tex.get_height(),
#	"Format": tex.get_format()}
#
#	var tex_bytes = tex.get_data()
#	var bytes = ""
#	for i in range(tex_bytes.size()):
#		bytes = bytes + ',' + str(tex_bytes[i])
#	tex_data["Data"] = bytes
#
#	db.open_db()
#	db.insert_row("Images", tex_data)
#
#
#
#func GetItemsByUser(id: int):
#	db.open_db()
#	db.query("select PlayerInfo.Name as pname, ItemInventory.Name as iname from PlayerInfo left join ItemInventory on PlayerInfo.ID = ItemInventory.PlayerID where PlayerInfo.ID = " + str(id))
#	for i in range(0, db.query_result.size()):
#		print("Query: %s's Item: %s" % [db.query_result[i]["pname"], db.query_result[i]["iname"]])
#	return db.query_result
#
#
#func WriteToDB():
#	db.open_db()
#	var table_name = "PlayerInfo"
#
#	var dict: Dictionary = Dictionary()
#	dict["Name"] = "Charlie"
#	dict["Score"] = 560
#
#	db.insert_row(table_name, dict)
#
#
#func ReadFromDB():
#	db.open_db()
#	var table_name = "PlayerInfo"
#	db.query("select * from " + table_name + ";")
#	for i in range(0, db.query_result.size()):
#		print("Query: %s's Score: %s" % [db.query_result[i]["Name"], db.query_result[i]["Score"]])

# END HACK: ===================================================================
