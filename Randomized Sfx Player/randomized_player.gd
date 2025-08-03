extends AudioStreamPlayer2D

class_name RandomizedAuiodStreamPlayer

@export var PossibleStreams: Array[AudioStreamOggVorbis] = []
@export var PitchModifierRange: float = .15
@export var SpeedModifierRange: float = .15

var finishedPlaying = true

func playRandom() -> void:
  stream = PossibleStreams[randi_range(0, len(PossibleStreams)-1)]
  
  var pitch = randf_range(1 - PitchModifierRange, 1 + PitchModifierRange)
  var speed = randf_range(1 - SpeedModifierRange, 1 + SpeedModifierRange)

  pitch_scale = pitch
  volume_linear = speed
  
  play()
  
  finishedPlaying = false

func _on_finished() -> void:
  finishedPlaying = true
