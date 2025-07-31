extends CanvasLayer

@export var Buttons: Array[Button]


@export var powers: Array[Power]

func DisplayPowers():
  for i in range(len(Buttons)):
    Buttons[i].text = powers[i % len(powers)].Name
    Buttons[i].pressed.connect(powers[i % len(powers)].apply_power_passive)
    Buttons[i].pressed.connect(powers[i % len(powers)].apply_power_death)
