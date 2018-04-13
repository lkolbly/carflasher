import itertools
from rs08asm import rs08asm
from mc9rs08kaX import *

uniqLabelCnt = 0

# Note: This changes .PAGESEL!
def pageAddr(p, addr):
	addr = p._labelOrLiteral(addr)
	if addr < 256:
		raise Exception("You don't need to use pageAddr to access %s"%addr)
	p.movi(addr>>6, ".PAGESEL")
	return 0xC0 + (addr&0x3F)

# color is one of the eight possible colors (R/G/B each either 0 or 1)
def setColor(p, color):
	p.movi((color[2]<<4) | (color[1]<<1) | color[0], ".PTAD")
	pass

# Can wait for up to 1.25MHz/256/256/256 = 13.422s
# 1.25MHz/256 is the MTIM clock prescaler
# /256 is the MTIM modulo
# /256 is the 8 bit counter in A
# Brightness is in parts per 256 (e.g. 128 is 50% brightness)
# Color is 0 or 1 for each of R, G, and B
mtimWaitInstances = set()
def mtimWait(p, color, brightness, timeSeconds):
	if brightness < 1 or brightness > 255:
		raise Exception("Brightness must be a reasonable value")

	numIters = int(timeSeconds * 256 / 13.422)
	if numIters < 1 or numIters > 255:
		raise Exception("'%s' is out of range"%timeSeconds)

	fnname = "mtimWait_%s%s%s_%s_%s"%(color[0], color[1], color[2], brightness, numIters)
	p.jsr(fnname)
	mtimWaitInstances.add((color, brightness, timeSeconds))

def mtimWaitCode(p, color, brightness, timeSeconds):
	numIters = int(timeSeconds * 256 / 13.422)
	fnname = "mtimWait_%s%s%s_%s_%s"%(color[0], color[1], color[2], brightness, numIters)

	# Accumulator counts down from numIters
	p.label(fnname)
	p.movi(0x08, ".MTIMCLK") # Divide the bus clock by 256
	p.ldai(numIters)

	p.label(fnname+"_loop")

	# Run the mtimWait inner loop once
	# Turn on all LEDs
	setColor(p, color)

	# Configure the MTIM for the uptime
	p.movi(brightness, ".MTIMMOD")
	p.movi(0x60, ".MTIMSC")

	p.wait()

	# Clear the LEDs
	p.movi(0x00, ".PTAD")

	# Configure the MTIM for the downtime (writing to MTIMMOD also clears TOF)
	p.movi(256-brightness, ".MTIMMOD")
	p.movi(0x60, ".MTIMSC")

	p.wait()

	# Clear TOF and disable the MTIM
	p.movi(0, ".MTIMMOD")
	p.movi(0x00, ".MTIMSC")

	# Decrement A, repeat if not zero
	p.deca()
	p.cmpi(0)
	p.bne(fnname+"_loop")
	p.rts()
	pass

device = mc9rs08kaX(2)
p = rs08asm(device)

p.at(".RESET")
p.jmp("start")

p.at(".FLASHBASE")

p.label("start")

# Set the trim NOTE! This value will vary per chip
p.movi(98, ".ICSTRM")
p.movi(0x01, ".ICSSC")

# Set the prescaler to divide by 8
p.movi(0xC0, ".ICSC2")

p.label("pwron")

# Kill the watchdog, enable stop mode, enable BKGD and RESET
p.movi(0x23, pageAddr(p, ".SOPT"))

# Disable & acknowledge low voltage detect
p.movi(0x40, pageAddr(p, ".SPMSC1"))

# Setup the I/O direction and pulldown
p.movi(0x20, pageAddr(p, ".PTAPUD"))
p.movi(0x20, pageAddr(p, ".PTAPE"))
p.movi(0x13, ".PTADD")

# Light each of R,G,B for 1/2 second
mtimWait(p, (1,0,0), 64, 0.5)
mtimWait(p, (0,1,0), 128, 0.5)
mtimWait(p, (0,0,1), 255, 0.5)

# Setup the KBI and sleep
p.label("setupKbiAndSleep")
p.movi(0x00, ".KBISC")
p.movi(0x20, ".KBIPE")
p.movi(0x20, ".KBIES")
p.movi(0x04, ".KBISC") # Clear any false interrupts
p.movi(0x02, ".KBISC")

p.stop()

p.label("kbi")

p.movi(0x04, ".KBISC") # Write 1 to KBIACK, disable interrupt

mtimWait(p, (0,0,0), 128, 1.0)
mtimWait(p, (1,1,1), 255, 0.125)
p.jmp("setupKbiAndSleep")

for c,b,t in mtimWaitInstances:
	mtimWaitCode(p, c, b, t)

if __name__ == "__main__":
	print(p.assemble())

	def doProgram():
		from programmer import Programmer
		programmer = Programmer(device)
		print(programmer._slice(p))
		programmer.program(p)

	doProgram()
