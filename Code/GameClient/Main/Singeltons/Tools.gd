extends Node

# Read a JSON file.
func ReadJSON(file_path: String):
	var file = File.new()
	file.open(file_path, File.READ)
	var json = JSON.parse(file.get_as_text())
	file.close()
	return json.result

# Write a JSON file.
func WriteJSON(file_path: String, data):
	var file = File.new()
	if file.open(file_path, File.WRITE) != 0:
		print("Error opening file.")
		return

	file.store_line(to_json(data))
	file.close()
