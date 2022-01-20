extends Node
class_name PlayerVocab

var words: Array

func _ready():
	GameServer.RequestPlayerDictionary()

func Update(data_table):
	pass
