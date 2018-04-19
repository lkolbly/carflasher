Carflasher
==========

This is a device with a LED and a button. The LED flashes two seconds after you release the button.

Why? Because when you're driving you are supposed to keep two seconds' of distance between you and the car in front of you. Counting Mississippis is hard while driving, so simply use this device.

(also so that I can learn how to make PCBs)

BOM
===

Some parts I had lying around the house, those I don't have a Mouser part number for, but I did estimate the price based on similar parts.

| Mouser Part # | Description | Location on PCB | Quantity | Price (ea) | Price (total) |
| ------------- | ----------- | --------------- | -------- | ---------- | ------------- |
| 841-MC9RS08KA2CPC | Microcontroller | DIP-8 package | 1 | 1.54 | 1.54 |
| 512-2N3904BU | NPN transistor | TO-92 footprints | 3 | 0.20 | 0.60 |
| 588-OJ1115E-R52 | 110 ohm resistor | R3 | 1 | 0.10 | 0.10 |
| 603-CFR-25JR-521K | 1K ohm resistor | R2 | 3 | 0.10 | 0.30 |
| - | 0.1uF capacitor | C1 | 1 | ~0.50 | ~0.50 |
| 604-WP154A43VBDZGCCA | RGB LED | 4-pin round LED | 1 | 2.05 | 2.05 |
| - | 0.1" headers | 6-bin BDM port | 1 | ~0.30 | ~0.30 |

Total cost per unit: $5.39 + cost of PCB ($1 for batch of ten) + cost of housing (~4m of 0.75mm PLA filament = ~$0.20) = ~$6.59

You will also need two 303/357 batteries to run the device.

Making one
==========

You will need:
- The parts from the BOM
- A PCB board (I bought mine from jlcpcb.com, with shipping they gave me 10 boards for $10)
- A housing (3D print the included .scad file)
- A way to program the microcontroller (see https://github.com/lkolbly/bdmCore)

1. Solder all of the components to the PCB. (be careful that the transistors will fit through the housing lid)
2. Take 22-gauge wire and thread it through the positive battery terminal into the casing. Also thread a piece through the lower button contact into the bottom of the casing.
3. Thread a piece of wire through the negative battery terminal (the terminal on the lid) and solder this wire to the - PWR connection.
4. Solder a piece of wire to one of the BTN connections.
5. Carefully lower the PCB into the housing, taking care to insert the two wires in the housing through the PCB. Solder these wires to the + PWR connection and the unsoldered BTN connection (these two solder joints will be on the top side of the board).
6. Thread the remaining button wire through the top button contact.
7. Close lid. Apply glue if desired.
8. Zip tie device to steering wheel.
9. Enjoy your handiwork!

Alternatively, if you contact me with promises of money ($20, but I'll do bulk discounts), I'll make one for you. That's the one-step assembly solution.
