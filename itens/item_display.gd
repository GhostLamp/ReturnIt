extends HBoxContainer
class_name ItemDisplay

# classezinha que define como o item vai apatrecer no inventario
@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label

var displayText:String
var displayColor:Color

func _ready() -> void:
	color_rect.color = displayColor
	label.text = displayText
