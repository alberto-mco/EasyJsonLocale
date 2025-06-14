extends Control

@onready var label: Label = $Label


func _on_btn_play_pressed() -> void:
	label.text = tr("HelloWorld")
