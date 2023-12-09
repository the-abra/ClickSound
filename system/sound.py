from pynput import keyboard, mouse
from playsound import playsound
import threading

 
def gett(file):
    with open(file, "r") as f:
        theme = f.read()
    return theme.strip()

theme = gett("theme.txt") + "/"

pressed_keys = set()

def on_press(key):
    if key in pressed_keys:
        return
    pressed_keys.add(key)
    if key == keyboard.Key.enter:   
        threading.Thread(target=playsound, args=(f"sounds/{theme}enter.wav",)).start()
    elif key == keyboard.Key.backspace:
        threading.Thread(target=playsound, args=(f"sounds/{theme}backspace.wav",)).start()
    elif key == keyboard.Key.delete:
        threading.Thread(target=playsound, args=(f"sounds/{theme}delete.wav",)).start()
    elif key == keyboard.Key.space:
        threading.Thread(target=playsound, args=(f"sounds/{theme}space.wav",)).start()
    else:
        threading.Thread(target=playsound, args=(f"sounds/{theme}generic.wav",)).start()

def on_release(key):
    pressed_keys.discard(key)

def on_click(x, y, button, pressed):
    if pressed and button == mouse.Button.left:
        threading.Thread(target=playsound, args=(f"sounds/{theme}click_left.wav",)).start()
    elif pressed and button == mouse.Button.right:
        threading.Thread(target=playsound, args=(f"sounds/{theme}click_right.wav",)).start()

def start_listening():
    listener = keyboard.Listener(on_press=on_press, on_release=on_release)
    listener.start()

    mouse_listener = mouse.Listener(on_click=on_click)
    mouse_listener.start()

    listener.join()
    mouse_listener.join()

start_listening()