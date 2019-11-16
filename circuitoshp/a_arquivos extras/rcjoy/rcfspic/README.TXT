			R C F S p i c                   13.Jan.1996

		     by Cord Johannmeyer 

this package includes all necesseary files for construction of a 

R/C receiver / joystick port interface 

for control of a (model-)flight simulator on IBM-PC compatible computer with
the original R/C Transmitter. Recently I've added support for the 
Graupner/JR trainer cord(see RCFS1.ASM).
The device was developed for operation with the RCFS R/C flight simulator by
Dave Brown, but it runs as well with all other programs using the joystick
port.

Contents: 

README   txt   this file
RCFSPICB PS    solder side of the board in postscript format
RCFSPICT PS    component side of the board in postscript format
	       for one-sided boards take the location of bridges from here
RCFSPICP PS    layout diagram in postscript format
RCFSPICS PS    circuit diagram
CONNECT  txt   pin assignment
PARTS    txt   parts list
RCFS1    ASM   main program for the PIC16C84 microcontroller
RCFS0    HEX   compiled program in Intel-Hex format (R/C receiver version)
RCFS1    HEX   compiled program in Intel-Hex format (Trainer cord version)
DIVMUL   ASM   multiplication/division subprograms
MPREG    H     header file 

The interface actually came into being as a by product, because during 
training in PIC-programming I was looking for a suitable exercise.
The costs where not particulary esteemed, so as substitute for the joysticks
I've used the somewhat expensive digital adjustable resistor X9C104 from
Xicor. The essentials of the device are the PIC16C84, 4 x 9XC104, some
switches and connectors.

Functions: 
Four servo outputs of the receiver are connected, typically elevator,
rudder, ailerons and throttle or the corresponding channels for a 
helicopter. The 4 pulsewidth modulated signals or the trainer cord signal
are sampled by the PIC, adjusted and converted to the corresponding
"sliding contact position" of the digital potentiometers.

The operate the interface with the Graupner/JR trainer cord signal the
"#define SERIAL" switch in RCFS1.ASM must be enabled, otherwise comment out
this line.

There are 2 modes of operation, the programming mode and normal operation.
After toggle of the switch into the programming mode the control sticks must
be moved into all end positions. Returning into normal operation mode the 
end positions will be stored in the EEPROM. This procedure has to be passed
only once.

The component costs are approximately 65 German mark (Conrad-prices), for
the PCB plus a matching box approximately 15 German mark have to be added.
The device works for more then 1 year complete problem-free together
with the Dave Brown RCFS R/C flight simulator.

Important!
Most of the joystick ports at multi-I/O cards have only 2 analogous inputs,
contrary to to the original IBM-specification. For operation a port with 4
inputs is required, as it is to find on a lot of sound-cards. 

Be careful if you connect the Graupner/JR transmitter via trainer cord!
The signal level has to be limited to 5 Volts. This can be done by a 
resistor and a zener diode.

My Address:

	Cord Johannmeyer
	Am Triften 58c
	28876 Oyten
	Germany

Questions, suggestions etc. please send via email to

	C_Jhm@t-online.de


Have fun

	Cord
