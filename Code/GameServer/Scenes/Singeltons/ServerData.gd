extends Node

var skill_data
var stats_data

func _ready():
	
	# Skill Data.
	var skill_data_file = File.new()
	skill_data_file.open("res://Data/SkillData - Sheet1.json", File.READ)
	var skill_data_json = JSON.parse(skill_data_file.get_as_text())
	skill_data_file.close()
	skill_data = skill_data_json.result
	
	# Stats Data
	var stats_data_file = File.new()
	stats_data_file.open("res://Data/StatsData - Stats.json", File.READ)
	var stats_data_json = JSON.parse(stats_data_file.get_as_text())
	stats_data_file.close()
	stats_data = stats_data_json.result
