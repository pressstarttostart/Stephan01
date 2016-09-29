extends Node2D

var buttons = []
var elements_left_to_click = 0;
var elements_number = 5
var current_selected_number = 0
var max_selectable_number = 0
var Star = preload("res://Assets/UI/Star.xml")
var tasks = {
	"clicked":false,
	"found_number":false
}
export var title = "Question!"
export var text = "Combien de cerises?"
signal complete

func _ready():
	get_node("Question").set_text(text)
	get_node("Number").set_text(str(0))
	get_node("Buttons/Button_Down").set_opacity(0)
	get_node("Buttons/Button_Up").set_opacity(0)
	set_button_hand(get_node("Buttons/Button_Down"))
	set_button_hand(get_node("Buttons/Button_Up"))
	set_button_hand(get_node("Buttons/OkButton"))
	set_buttons();
	pass

func set_button_hand(button):
	button.set_default_cursor_shape(Control.CURSOR_POINTING_HAND);

func set_buttons():
	var possible_buttons = get_children()
	for i in range(possible_buttons.size()):
		var button = possible_buttons[i]
		if button extends Button:
			set_button_hand(button)
			var n = buttons.size()
			button.set_opacity(0)
			buttons.push_back(button)
			button.connect("pressed",self,"_on_pressed",[n],Button.CONNECT_ONESHOT)
	elements_left_to_click = buttons.size();
	max_selectable_number = rand_range(elements_left_to_click,elements_left_to_click*3)
	elements_number = elements_left_to_click;

func _on_pressed(i):
	var button = buttons[i];
	button.set_default_cursor_shape(Control.CURSOR_ARROW);
	button.hide()
	elements_left_to_click-=1;
	play("click")
	star(button)
	if elements_left_to_click <= 0:
		finished_task("clicked")
		#done();
		
func star(obj,scale=.1):
	var star = Star.instance()
	var pos = obj.get_global_pos();
	var size = obj.get_item_rect().size / 2
	star.set_pos(pos+size)
	star.set_scale(Vector2(scale,scale))
	star.get_node("Player").play("jump")
	get_node("Stars").add_child(star)

func play(sound):
	get_node("Sounds").play(sound)

func finished_task(type):
	tasks[type] = true
	var complete = true
	for task in tasks:
		if !tasks[task]:
			complete = false
			break;
	if complete:
		victory_achieved()

func play_animation():
	play("yeah")
	get_node("VictoryAnimation").show();
	get_node("VictoryAnimation/Player").play("Victory")
	emit_signal("complete")
	
func victory_achieved():
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	timer.set_wait_time(1)
	timer.connect("timeout", self, "play_animation")
	timer.start()
	add_child(timer)

func elements_left_to_click_change(inc):
	current_selected_number = current_selected_number + inc
	if current_selected_number >= max_selectable_number:
		play("error")
		current_selected_number = max_selectable_number
	elif current_selected_number < 0:
		play("error")
		current_selected_number = 0
	get_node("Number").set_text(str(current_selected_number))

func _on_Button_Down_pressed():
	elements_left_to_click_change(-1)

func _on_Button_Up_pressed():
	elements_left_to_click_change(1)

func _on_OkButton_pressed():
	if current_selected_number == elements_number:
		var button = get_node("Buttons/OkButton");
		button.set_disabled(true)
		star(button,.2);
		finished_task("found_number")
	else:
		play("error")
