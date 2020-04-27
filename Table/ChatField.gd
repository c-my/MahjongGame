extends HBoxContainer


signal send_chat


# Called when the node enters the scene tree for the first time.
func _ready():
	$LineEdit.connect("text_entered", self, "text_entered")
	
func text_entered(text):
	if text == "":
		return
	emit_signal("send_chat", text)
	$LineEdit.text = ""


func _on_SendButton_pressed():
	text_entered($LineEdit.text)
