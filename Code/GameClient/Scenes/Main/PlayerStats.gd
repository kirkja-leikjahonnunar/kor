extends Control

onready var anger = $PanelContainer/CenterContainer/VBoxContainer/Anger/StatValue
onready var strength = $PanelContainer/CenterContainer/VBoxContainer/Strength/StatValue
onready var wisdom = $PanelContainer/CenterContainer/VBoxContainer/Wisdom/StatValue
onready var dexterity = $PanelContainer/CenterContainer/VBoxContainer/Dexterity/StatValue
onready var sexual_stamina = $PanelContainer/CenterContainer/VBoxContainer/SexualStamina/StatValue
onready var clicker_score = $PanelContainer/CenterContainer/VBoxContainer/ClickerScore/StatValue


func _ready():
	#GameServer.FetchPlayerStats("unblinky")
	pass
	

func LoadPlayerStats(stats):
	anger.set_text(str(stats.Anger))
	wisdom.set_text(str(stats.Wisdom))
	strength.set_text(str(stats.Strength))
	dexterity.set_text(str(stats.Dexterity))
	sexual_stamina.set_text(str(stats.SexualStamina))
	clicker_score.set_text(str(stats.ClickerScore))
