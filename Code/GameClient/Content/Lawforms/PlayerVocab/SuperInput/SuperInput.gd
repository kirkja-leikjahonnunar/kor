extends Node

const unknown_color: Color = Color(0.697828, 0.714844, 0.49704)
const keyword_color: Color = Color(0.842364, 0.90625, 0.088501)

onready var RICH_TEXT := $RichText
onready var INPUT_TEXT := $InputText

var vocab: Array

func Initialize(my_vocab: Array): #(data_table):
	vocab = my_vocab
	for word in vocab:
		INPUT_TEXT.add_keyword_color(word, keyword_color)
