#!/usr/bin/env python

import os
import time
from RPi.GPIO import BCM, IN, setup, setmode, input

setmode(BCM)
setup(18, IN)

DELAY = 60
countdown = DELAY

while True:
    time.sleep(1)
    if input(18):
        countdown = DELAY
    else:
        countdown -= 1
    if countdown == 0:
        os.system('shutdown -h now')
