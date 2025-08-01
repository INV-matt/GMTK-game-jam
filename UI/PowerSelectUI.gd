extends CanvasLayer
class_name PowerSelectUI

@export var powerSelect: Control = null

func _ready() -> void:
  if !powerSelect: powerSelect = $powerSelect

  powerSelect.visible = false

  SignalBus.open_power_select.connect(_displayPowerSelect)
  SignalBus.hide_power_select.connect(_hidePowerSelect)


func _displayPowerSelect() -> void:
  powerSelect.visible = true
  get_tree().paused = true


func _hidePowerSelect() -> void:
  get_tree().paused = false
  powerSelect.visible = false
