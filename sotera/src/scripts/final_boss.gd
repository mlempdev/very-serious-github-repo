extends Control

enum Answers {A, B ,C, D}

@onready var option_a: Button = $Options/VBoxContainer/OptionA
@onready var option_b: Button = $Options/VBoxContainer/OptionB
@onready var option_c: Button = $Options/VBoxContainer2/OptionC
@onready var option_d: Button = $Options/VBoxContainer2/OptionD
@onready var question_label: Label = $QuestionLabel
@onready var boss_health_bar: ProgressBar = $BossHealthBar
@onready var player_health_bar: ProgressBar = $PlayerHealthBar


@export var boss_max_health: int
@export var player_max_health: int 
@export var boss_damage: int 
@export var player_damage: int
@export var questions: Array[Question]

var question_index: int = 0
var current_question: Question
var num_of_questions: int = 0
var player_health: int 
var boss_health: int

func _ready() -> void:
	num_of_questions = questions.size()
	if num_of_questions == 0:
		return

	option_a.grab_focus()
	option_a.pressed.connect(_on_option_button_pressed.bind(Answers.A))
	option_b.pressed.connect(_on_option_button_pressed.bind(Answers.B))
	option_c.pressed.connect(_on_option_button_pressed.bind(Answers.C))
	option_d.pressed.connect(_on_option_button_pressed.bind(Answers.D))

	display_question()
	set_health_bars()


func set_health_bars() -> void:
	player_health = player_max_health
	boss_health = boss_max_health

	boss_health_bar.max_value = boss_max_health
	boss_health_bar.value = boss_health
	player_health_bar.max_value = player_max_health
	player_health_bar.value = player_health

func _on_option_button_pressed(answer: Answers) -> void:
	if answer == current_question.answer:
		on_right_answer()
	else:
		on_wrong_question()
	
	move_to_next_question()


func display_question() -> void:
	current_question = questions[question_index]

	question_label.text = current_question.question
	option_a.text = "A: " + current_question.option_a
	option_b.text = "B: " + current_question.option_b
	option_c.text = "C: " + current_question.option_c
	option_d.text = "D: " + current_question.option_d

func move_to_next_question() -> void:
	if question_index >= num_of_questions -1:
		on_quiz_end()
		return
	question_index += 1
	display_question()

func on_right_answer() -> void:
	boss_health -= player_damage
	boss_health_bar.value = boss_health

func on_wrong_question() -> void:
	player_health -= boss_damage
	player_health_bar.value = player_health

func on_quiz_end() -> void:
	pass
