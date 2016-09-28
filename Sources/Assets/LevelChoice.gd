var root
var on_selected;
var paths = [];
signal on_selected(path)

func _ready():
	root = get_node("Buttons")

func add_button(name,path):
	root.add_button(name)
	paths.push_back(path);
	return root.get_button_count() - 1

func _on_Buttons_button_selected(idx):
	var path = paths[idx];
	emit_signal("on_selected",path)