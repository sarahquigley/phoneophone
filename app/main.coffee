frequencies = [
  1760 ,1567.98 ,1396.91 ,1318.51 ,1174.66 ,1046.50 ,987.77,
  880 ,783.99 ,698.46 ,659.26 ,587.33 ,523.25 ,493.88,
  440 ,392 ,349.23 ,329.63 ,293.66 ,261.63 ,246.94,
  220 ,196 ,174.61 ,164.81 ,146.83 ,130.81 ,123.47,
  110 ,98 ,87.31 ,82.41 ,73.42 ,65.41 ,61.74,
  55 ,49 ,43.65 ,41.20 ,36.71 ,32.70 ,30.87
]

welcome_el = document.getElementById('welcome')
make_music_el = document.getElementById('make-music')
instructions_el = document.getElementById('instructions')
got_it_el = document.getElementById('got-it')
audio_space_el = document.getElementById('audio-space')

if _.isObject(make_music_el)
  make_music_el.addEventListener 'click', (event) ->
    welcome_el.style.display = 'none'
    instructions_el.style.display  = 'block'

if _.isObject(got_it_el)
  got_it_el.addEventListener 'click', (event) ->
    instructions_el.style.display = 'none'
    audio_space = new PhoneoPhone.AudioSpace(audio_space_el, frequencies)
