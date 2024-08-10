import os
import numpy as np
import sounddevice as sd
from scipy.io import wavfile
import evdev
from evdev import InputDevice, categorize, ecodes
import threading

# Function to get the theme from a file
def get_theme(file):
    with open(file, "r") as f:
        theme = f.read().strip()
    return theme + "/"

# Fetch the current theme
theme = get_theme("theme.txt")

# Preload sound files into a dictionary
sound_cache = {}

def preload_sounds(sound_files):
    for sound_file in sound_files:
        sound_path = f"sounds/{theme}{sound_file}"
        if os.path.exists(sound_path):
            samplerate, data = wavfile.read(sound_path)
            sound_cache[sound_file] = (samplerate, data)

# List of sound files to preload
sound_files_to_load = [
    'enter.wav',
    'backspace.wav',
    'delete.wav',
    'space.wav',
    'generic.wav',
    'click_left.wav',
    'click_right.wav'
]

# Preload the sounds
preload_sounds(sound_files_to_load)

# List all input devices and find the keyboard and mouse
devices = [InputDevice(path) for path in evdev.list_devices()]
keyboard_device = None
mouse_device = None

# Identify the keyboard and mouse devices
for device in devices:
    print(device.path, device.name, device.phys)  # List all devices
    if 'keyboard' in device.name.lower():
        keyboard_device = device
    elif 'mouse' in device.name.lower() or 'pointer' in device.name.lower():
        mouse_device = device

if not keyboard_device:
    print("Keyboard device not found.")
    exit(1)

if not mouse_device:
    print("Mouse device not found.")
    exit(1)

# Function to play sounds directly without waiting
def play_sound(sound_file):
    if sound_file in sound_cache:
        samplerate, data = sound_cache[sound_file]
        threading.Thread(target=sd.play, args=(data, samplerate)).start()

# Read and handle key events
def handle_keyboard_events():
    for event in keyboard_device.read_loop():
        if event.type == ecodes.EV_KEY:
            key_event = categorize(event)
            if key_event.keystate == key_event.key_down:
                if key_event.keycode == 'KEY_ENTER':
                    play_sound('enter.wav')
                elif key_event.keycode == 'KEY_BACKSPACE':
                    play_sound('backspace.wav')
                elif key_event.keycode == 'KEY_DELETE':
                    play_sound('delete.wav')
                elif key_event.keycode == 'KEY_SPACE':
                    play_sound('space.wav')
                else:
                    play_sound('generic.wav')

# Read and handle mouse events
def handle_mouse_events():
    for event in mouse_device.read_loop():
        if event.type == ecodes.EV_KEY:  # Check for mouse button events
            mouse_event = categorize(event)
            if mouse_event.keystate == mouse_event.key_down:
                if mouse_event.keycode == 'BTN_LEFT':
                    play_sound('click_left.wav')
                elif mouse_event.keycode == 'BTN_RIGHT':
                    play_sound('click_right.wav')
        elif event.type == ecodes.EV_REL:  # Handle mouse movement (optional)
            print(f'Mouse moved: {event}')

# Start keyboard and mouse event handling in separate threads
threading.Thread(target=handle_keyboard_events, daemon=True).start()
threading.Thread(target=handle_mouse_events, daemon=True).start()

# Keep the main thread alive
while True:
    pass
