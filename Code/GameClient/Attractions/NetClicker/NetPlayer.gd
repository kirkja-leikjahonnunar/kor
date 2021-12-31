extends Control
class_name NetPlayer

var my_db_id: int
var my_name: String
var my_clicks: int
var my_forks_given: int
var my_color: Color

func Update(db_record: Dictionary):
	my_db_id = db_record["ID"]
	my_name = db_record["Name"]
	my_clicks = db_record["Clicks"]
	my_forks_given = db_record["ForksGiven"]
	my_color = Color.darkgoldenrod
