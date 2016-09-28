extends Control

signal ok_pressed(num,desired)
var chosen_number = 0
var desired_number = 0

func _ready():
	pass


func popup(title,text,num):
	var mod = get_node("Dialog")
	var slider = get_node("Dialog/Slider")
	var textBox = get_node("Dialog/Text")
	get_node("Dialog/Number").set_text(str(0))
	slider.set_max(num * 2)
	mod.set_title(title)
	textBox.set_text(text)
	desired_number = num
	mod.popup()

func unpopup():
	get_node("Dialog").hide();

func _on_Slider_value_changed( value ):
	chosen_number = value
	get_node("Dialog/Number").set_text(str(value))


func _on_Button_pressed():
	emit_signal("ok_pressed",chosen_number,desired_number)
	pass # replace with function body