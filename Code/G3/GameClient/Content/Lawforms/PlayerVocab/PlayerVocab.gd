extends Node
class_name PlayerVocab

onready var DICTIONARY_UI := $Dictionary
onready var SUPER_INPUT := $SuperInput

var words: Array

func _ready():
	#TODO: The Game Server would call Initialize() eventually.
	#GameServer.RequestPlayerDictionary()
	Initialize() # 4 now.

func Initialize(): #(data_table):
	words = ["dog", "cat", "mouse"]
	SUPER_INPUT.Initialize(words)
	
	# Just testing.
	for word in words:
		DICTIONARY_UI.text += "\n" + word
		
