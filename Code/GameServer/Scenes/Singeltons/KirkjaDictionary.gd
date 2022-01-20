extends Node

const SQLITE = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "res://DataStore/kirkja"
var skill_data
var stats_data

var table_name = "kirkja_dictionary"

func _ready():
	# HACK: SQL testing.
	db = SQLITE.new()
	db.path = db_path
