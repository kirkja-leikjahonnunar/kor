extends Control

onready var FORKS_GIVEN_UI = $ForksGiven
var forks_given: int = 0

func _ready():
	# TODO: Load the player's previous score.
	UpdateScore(190)
	
func UpdateScore(delta_score: int):
	forks_given += delta_score
	FORKS_GIVEN_UI.text = str(forks_given)
	
