Graceful shutdown for the Raspberry Pi
====

The Raspberry Pi is a great little board, but because it runs Linux, you risk
corrupting the file system on the SD card if you simply switch off the power.
The standard advice is to type "sudo shutdown -h now" and wait until the
shutdown process has finished, or has at least unmounted all the file systems,
before switching off the power.

What if the RPi is part of some embedded widget with no keyboard and screen?
How then to initiate a shutdown, and how to know when it's finished? It was
while contemplating the creation of just such an embedded widget that I hit
upon this piece of brilliance. First, build this circuit.

How does this work? When you plug in the wall wart, we don't want to draw power
from the 9 volt battery yet, so we want Q1 to be off. This is accomplished by
using Q4 to keep the Q2/Q3 Darlington turned off. The wall wart power flows
thru the three diodes in parallel and operates the switching voltage regulator
(I picked up a bunch of these from some Chinese outfit on eBay). Meanwhile C1
charges to around 9 volts.

What happens when you yank the wall wart? First Q4 turns off, and C1 begins to
discharge thru R1 and R6, turning on the Darlington pair, which turns on Q1 so
that now the switching regulator is running on battery power. The battery power
remains on for some multiple of the RC time constant (100 uF * 500K = 50 secs),
and you end up with about two minutes to get the Raspberry Pi to shutdown.

The active-low shutdown signal should be wired to a GPIO, which should poll it
about once per second. You'll need a script on the RPi that watches this GPIO
and forces a shutdown when it goes low. I've connected the shutdown warning to
GPIO18.

[Info about RPi GPIOs](https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/)

I'm using a Raspberry Pi 2, which is much faster than the older Raspberry Pis,
and reliably shuts down in only 10 or 15 seconds. So I decided to give myself
the luxury of waiting 60 seconds before I commence shutdown. This means I can
move the wall wart from one electrical outlet to another, and the battery power
will keep the RPi alive in the meanwhile.

You'll need two scripts to make this thing work, which you'll find in this
repository. Copy `shutdown.py` to the `/root` directory. Copy `shutdown.sh`
to the `/etc/init.d` directory. While still in the `/etc/init.d` directory,
type `update-rc.d shutdown.sh defaults`, which will turn this into a service
that becomes part of your RPi's boot process.
