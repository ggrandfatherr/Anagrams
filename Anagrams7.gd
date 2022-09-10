extends Node2D

const display_panel = preload("res://Resources/DispWords.tscn")

export(int) var run_time = 90

onready var instruct = $CanvasLayer/Tutorial
onready var main_game = $CanvasLayer/Control

onready var enter_btn = $CanvasLayer/Control/Game/MajorContainer/ButtonSet/VBoxContainer/HBoxContainer/EnterButton
onready var round_timer = $RoundTimer

onready var wrd_amnt_pane = $CanvasLayer/Control/EndGame/EndGameCont/ScoreContainer/FinalScore/AmountPane/WordAmnt
onready var hs_pane = $CanvasLayer/Control/EndGame/EndGameCont/ScoreContainer/FinalScore/HSPanel
onready var s_pane = $CanvasLayer/Control/EndGame/EndGameCont/ScoreContainer/FinalScore/SPanel

onready var word_count = $CanvasLayer/Control/Game/MajorContainer/ScoreBoard/WDCount/WordCount
onready var final_score = $CanvasLayer/Control/EndGame/EndGameCont/ScoreContainer/FinalScore/SPanel/ScoreLabel
onready var high_score = $CanvasLayer/Control/EndGame/EndGameCont/ScoreContainer/FinalScore/HSPanel/HScoreLabel
onready var time_label = $CanvasLayer/Control/Game/MajorContainer/Functionality/HBoxContainer/TimeContainer/Panel/TimeLabel
onready var score_label = $CanvasLayer/Control/Game/MajorContainer/ScoreBoard/ScoreCont/ScoreLabel
onready var lower_grid = $CanvasLayer/Control/Game/MajorContainer/ButtonSet/VBoxContainer/LowerButtons
onready var upper_grid = $CanvasLayer/Control/Game/MajorContainer/ButtonSet/VBoxContainer/UpperButtons

onready var spelt_word = $CanvasLayer/Control/EndGame/EndGameCont/SpeltMarg/FullStack/SpeltWord/Panel/Label
onready var major_cont = $CanvasLayer/Control/Game
onready var endgame_cont = $CanvasLayer/Control/EndGame
onready var word_cont = $CanvasLayer/Control/EndGame/WordList
onready var gameresult = $CanvasLayer/Control/EndGame/EndGameCont
onready var word_grid = $CanvasLayer/Control/EndGame/WordList/WordGridCont/ScrollContainer/WordGrid

onready var spelt_cont = $CanvasLayer/Control/EndGame/EndGameCont/SpeltMarg/FullStack/Spelt/ScrollContainer/SpeltContainer
#onready var full_stck = $CanvasLayer/Control/EndGame/EndGameCont/SpeltMarg/ScrollHolder/FullStack

onready var holder = $CanvasLayer/Control/EndGame/EndGameCont/Holder
onready var replay = $CanvasLayer/Control/EndGame/EndGameCont/Holder/MarginContainer/Replay
onready var wrd_list_btn = $CanvasLayer/Control/EndGame/EndGameCont/Holder/ViewWordList

onready var score_tween = $ScoreTween
onready var control_tween = $ControlTween
onready var tile_tween = $TileTween
onready var return_tween = $ReturnTween

onready var cursor = $CanvasLayer/Cursor

onready var error_producer = $ErrorProducer

onready var pos_words = $CanvasLayer/Control/EndGame/WordList/MarginContainer/AmountPane/PosWords

var lower_buttons : Array = []
var upper_buttons = []

var disp_amnt = 12

var score : int = 0
var curr_box = 0
#var moved_count.size() = 0

var swapped = false
var over = false
var used_words = []
var moved_count = 0

var final_string = ""
var new_string = ""

#TIMEX
var seconds = 0
var minutes = 0


func select_new_string():
	new_string = EngDict.word_warehouse.keys()[randi() % EngDict.word_warehouse.size()]

func rt_score(word_len) -> int:
	var _score : int
	match word_len:
		3:
			_score = 100
		4:
			_score = 400
		5:
			_score = 1400
		6:
			_score = 2000
		7: 
			_score = 3000
	return _score

func split_string(string: String):
	string = string.to_upper()
	var str_arr = []
	for i in string:
		str_arr.append(i)
	return str_arr


func _ready():
	cursor.visible = EngDict.pc
	randomize()
	set_physics_process(false)
	select_new_string()
	set_arrays_signals()
	set_letters(new_string)
	endgame_cont.visible = false
	instruct.visible = true

func set_letters(n_string):
	var _string = split_string(n_string)
	_string.shuffle()
	for i in lower_buttons.size():
		lower_buttons[i].text = str(_string[i])
		

func _process(delta):
	cursor.global_position = get_global_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if used_words.size() == 1:
		word_count.text = str(used_words.size())+ " word spelt"
	else:
		word_count.text = str(used_words.size())+ " words spelt"
	
	time_label.text = give_time($RoundTimer.time_left)
	watch_word()
	if !over: 
		enter_btn.disabled = !final_string.length() >= 3
	score_label.text = str(score).pad_zeros(4)

func give_time(time_in_secs):
	seconds = int(time_in_secs)%60
	minutes = (int(time_in_secs)-seconds)/60
	var sec_string = str(seconds).pad_zeros(2)
	var min_string = str(minutes).pad_zeros(2)
	
	return min_string + ":" + sec_string

 
func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		for word in used_words:
			var new_label = Label.new()
			new_label.text = word.to_upper()
			spelt_cont.add_child(new_label)
			yield(get_tree().create_timer(0.2),"timeout")

func set_arrays_signals():
	var lb_arr = lower_grid.get_children()
	
	for i in lb_arr:
		lower_buttons.append(i.get_child(0))
	
	for i in lower_buttons.size():
		lower_buttons[i].connect("pressed",self,"move_to_id",[lower_buttons[i]])
		lower_buttons[i].id = i
	
	upper_buttons = upper_grid.get_children()
	
	for i in upper_buttons.size():
		upper_buttons[i].id = i

func watch_word():
	var btn_list = rt_moved_btns()
	var order : Dictionary = {}
	var compiled_str = ""
	
	for i in range(btn_list.size()):
		order[btn_list[i].x_pos] = btn_list[i]
	
	for i in range(btn_list.size()):
		compiled_str += order[i+1].text

	final_string = compiled_str

func check_word():
	if final_string.length() > 2:
		if !final_string in used_words and (EngDict.small_dict.has(final_string.to_lower()) or EngDict.word_warehouse.has(final_string.to_lower())):
			used_words.append(final_string)
			
			var blink = false
			if rt_score(final_string.length()) == 3000:
				blink = true
			
			var n_scre : int = score + rt_score(final_string.length())
			score_tween.interpolate_property(self,"score",null,n_scre,0.1)
			score_tween.start()
			var message = "+" +str(rt_score(final_string.length()))
			error_producer.create_error_message(message,blink)
		elif final_string in used_words:
			var message = str(final_string.to_upper()," already used.")
			error_producer.create_error_message(message)
		elif !EngDict.small_dict.has(final_string.to_lower()) or !EngDict.word_warehouse.has(final_string.to_lower()):
			var message = str("Not in Dictionary.")
			error_producer.create_error_message(message)

func check_moved() -> int:
	var _moved_btns = []
	for btn in lower_buttons:
		if btn.moved:
			_moved_btns.append(btn)
		else:
			pass
#	print(_moved_btns.size())
	return _moved_btns.size()

func rt_moved_btns():
	var _moved_btns = []
	for btn in lower_buttons:
		if btn.moved:
			_moved_btns.append(btn)
		else:
			pass

	return _moved_btns

func move_to_id(btn):
	if !btn.moved:
		var x_pos = check_moved()
#		print("index: ",x_pos," - ",btn.id, " = ", x_pos - btn.id," btn_id ",btn.id)
		tile_tween.interpolate_property(btn,"rect_position",btn.rect_position,Vector2((x_pos - btn.id) * 38,-40),0.15)
		tile_tween.start()
		btn.rect_position = Vector2((x_pos - btn.id) * 38,-40)
		btn.moved = true
		btn.x_pos = check_moved()
	elif btn.moved:
		btn.moved = false
		relocate_buttons(btn)
		tile_tween.interpolate_property(btn,"rect_position",btn.rect_position,Vector2(0,0),0.2)
		tile_tween.start()
		btn.x_pos = 0
		

func drop_btns():
	var btn_list = rt_moved_btns()
	
	for btn in btn_list:
		move_to_id(btn)


func relocate_buttons(_btn):
	for btn in lower_buttons:
		if !btn.moved:
			continue
		elif btn.moved and (btn.x_pos > _btn.x_pos):
			var new_x = btn.x_pos - btn.id
#			print(_btn," |",btn," of ",btn.id, " | " ,btn.x_pos," > ", _btn.x_pos, btn.x_pos > _btn.x_pos," at: ",btn.rect_position, " ||| ",new_x)
			return_tween.interpolate_property(btn,"rect_position",null,Vector2((btn.x_pos - btn.id - 2) * 38,-40),0.1)
			return_tween.start()
			btn.rect_position = Vector2((btn.x_pos - btn.id - 2) * 38,-40)
#			print(btn," at: ",btn.rect_position, " to be ",Vector2((btn.x_pos - btn.id - 2) * 42,-48))
			btn.x_pos -= 1
			

func sort_arr(arr:Array):
	var sorted_arr = []
	var tre = []
	var fou = []
	var fiv = []
	var six = []
	var sev = []
	
	for word in arr:
		var wd_len = len(word)
		match wd_len:
			3:
				tre.append(word)
			4:
				fou.append(word)
			5: 
				fiv.append(word)
			6: 
				six.append(word)
			7:
				sev.append(word)
	
	tre.sort()
	fou.sort()
	fiv.sort()
	six.sort()
	sev.sort()
	
	sorted_arr.append_array(sev)
	sorted_arr.append_array(six)
	sorted_arr.append_array(fiv)
	sorted_arr.append_array(fou)
	sorted_arr.append_array(tre)
	
#	sorted_arr.invert()
	
	return sorted_arr

func disp_spelt_words():

	replay.visible = false
	wrd_list_btn.visible = false
	
	used_words = sort_arr(used_words)

	spelt_word.text = "WORD: " + new_string.to_upper()
	wrd_amnt_pane.text = str(used_words.size()) + " words."
	for i in len(used_words):
		var _score = rt_score(used_words[i].length())
		var _new_panel = display_panel.instance()
		_new_panel.word = used_words[i].to_upper()
		_new_panel.score = str(_score)
		spelt_cont.add_child(_new_panel)
#		yield(get_tree().create_timer(0.2),"timeout")

	replay.visible = true
	wrd_list_btn.visible = true

func _on_EnterButton_pressed():
	check_word()
	drop_btns()

func animate_boxes():
	if !swapped:
		control_tween.interpolate_property(major_cont,"rect_position",Vector2(0,0),Vector2(-270,0),0.4)
		control_tween.interpolate_property(endgame_cont,"rect_position",Vector2(-270,0),Vector2(0,0),0.4)
		endgame_cont.visible = true
		major_cont.visible = false
#		major_cont.rect_position = Vector2(-270,0)
#		endgame_cont.rect_position = Vector2(0,0)
		control_tween.start()
		swapped = true
	else:
		control_tween.interpolate_property(endgame_cont,"rect_position",Vector2(0,0),Vector2(-270,0),0.4)
		control_tween.interpolate_property(major_cont,"rect_position",Vector2(-270,0),Vector2(0,0),0.4)
		control_tween.start()
		endgame_cont.visible = false
		major_cont.visible = true
		swapped = false

func clear_display():
	for i in spelt_cont.get_children():
		i.queue_free()
	for i in word_grid.get_children():
		i.queue_free()

func set_highscore():
	if score > EngDict.high_score:
		EngDict.set_highscore(score)
		hs_pane.visible = false
		s_pane.visible = true
		final_score.text = "New High Score: " + str(EngDict.get_highscore()).pad_zeros(4) + "!"
	else:
		hs_pane.visible = true
		final_score.text = "Score: " + str(score).pad_zeros(4)
		high_score.text = "HighScore: " + str(EngDict.get_highscore()).pad_zeros(4)

func set_possible_words():
	var list = EngDict.small_dict
	var list2 = EngDict.word_warehouse
	var split_word = split_string(new_string)
	var pos_list = []
	
	#each word in dict
	for word in list:
		var is_in = false
		#cut form of dict word
		var dict_word = split_string(word)
		var dupli = split_word.duplicate()
		for ltr in dict_word:
			if !ltr in dupli:
				is_in = false
				break
			elif ltr in dupli:
				is_in = true
				dupli.erase(ltr)
		if is_in:
			pos_list.append(word)
		else:
			pass
		
	for word in list2:
		var is_in = false
		#cut form of dict word
		var dict_word = split_string(word)
		var dupli = split_word.duplicate()
		for ltr in dict_word:
			if !ltr in dupli:
				is_in = false
				break
			elif ltr in dupli:
				is_in = true
				dupli.erase(ltr)
		if is_in:
			pos_list.append(word)
		else:
			pass
	
	pos_list.sort()
	pos_words.text = str(pos_list.size()) + " words."
	
	for combo in pos_list:
		var _new_panel = display_panel.instance()
		_new_panel.word = combo
		_new_panel.norm = false
		word_grid.add_child(_new_panel)

func _on_RoundTimer_timeout():
	check_word()
	set_highscore()
	drop_btns()
	over = true
	enter_btn.disabled = true
	animate_boxes()
	disp_spelt_words()


func _on_ShuffleButton_pressed():
	drop_btns()
	set_letters(new_string)


func _on_ReplayButton_pressed():
	over = false
	drop_btns()
	animate_boxes()
	select_new_string()
	set_letters(new_string)
	clear_display()
	round_timer.start(run_time)
	score = 0
	used_words = []
	set_physics_process(false)
	instruct.visible = true
	


func _on_MenuButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

#Start Game
func _on_StartBtn_pressed():
	set_physics_process(true)
	set_possible_words()
	instruct.visible = false
	main_game.visible = true
	round_timer.start(run_time)


func _on_Undo_pressed():
	get_tree().change_scene("res://SelectAnagramCount.tscn")


func _on_ViewWordList_pressed():
	gameresult.visible = false
	word_cont.visible = true


func _on_ToScore_pressed():
	gameresult.visible = true
	word_cont.visible = false
