extends Node
class_name NetClicker

#var net_player: NetPlayer

func RequestPlayerAdd(db_name: String):
	GameServer.NC_RequestPlayerAdd(db_name)
