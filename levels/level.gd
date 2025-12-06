extends Node2D
class_name Level

# o script dos niveis atualmente só tá servindo pra guardar as portas que o nivel tem e os items que o jogador vai começar

@export var doors:Array[Door]
@export var start_items:Array[BaseItem]
