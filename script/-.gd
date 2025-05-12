extends Node

@onready var report :Report = $Report
@onready var article :Article = $Article
@onready var text: Text = $Text


func _ready() -> void:
	FlowHandler.analyze(self)
	FlowHandler.display()
	article.cipher = report.cipher
	article.key = report.key
	$Timer.start()
	await $Timer.timeout
	report.shake()



func _on_button_pressed() -> void:
	$Button.text = '{0}'.format([article.analyze()])
	$Label.text = ''
	for word in article.header.atext:
		$Label.text += '{0}:{1}  '.format(SecurityHandler.decrypt(word.code, article.key, article.cipher))
	$Label.text += '\n\n'
	for word in article.body.atext:
		$Label.text += '{0}:{1}  '.format(SecurityHandler.decrypt(word.code, article.key, article.cipher))

