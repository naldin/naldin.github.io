DirectPad Pro
Version 5.0
(c) 1997-9 Earle F. Philhower, III
April 19, 1999
http://www.ziplabel.com

Introduction
  Do you have a joystick or gamepad that you just love, but isn't available
  for your PC?  Are the awful PC-compatible gamepads making you long for the days
  of the Atari 2600 and your beloved Wico-stick?  Do you miss your "superergo" Jaguar
  joypad?  If so, the DirectPad Pro is for you!

  DirectPad Pro is a combination hardware/software interface that allows Windows 95
  to utilize Sega, Atari, Jaguar, SNES, and other console joysticks and keypads on
  their PCs.  All of the interfaces require minimal wiring and operate through a free
  parallel port.  Any Windows DirectX compatible game can use these interfaces
  automatically!

New In Version 5.0:
  * Multiple N64 Controllers! 
  * Functional Saturn Analog Controllers 
  * VirtualBoy Support 
  * Calibration option for analog pads 
  * More force feedback control 
  * Nihongo ga wakarimasu ka?  DirectPad Pro does! 

Disclaimer
  DirectPad Pro is free software, and may be used without payment for any
  non-commercial purpose.  However, both the software and hardware are for
  USE AT YOUR OWN RISK.

  Finally, I would like to make it clear that I am not affiliated with any
  video game related company.  Atari, Jaguar, SNES, Sega, Genesis, Nintendo,
  and all other company and product names may be (c), (tm), or (r) their
  respective companies.

Requirements
  * Windows 95/98, with DirectX 5.0/6.0
  * Printer Port
  * Homebuilt Interface

Construction
  DirectPad Pro requires the construction of a parallel port interface to talk
  to your gamepads.  If you are careful and clip component leads you will be able
  to fit the entire pad interface into a DB-25 shell.  IF YOU DON'T KNOW WHICH
  END OF A SOLDERING IRON TO HOLD, PLEASE GET SOMEONE ELSE TO BUILD THESE INTERFACES
  FOR YOU.

  The required schematics are included in the .ZIP file under "name.GIF".
  For the TurboGraFX interface, please see the web page listed in the TGFX section.
  For the N64 schematics, see the N64 controller section below.
  Print the schematics out and cross off the connections as you make them.

**NOTE:  The Genesis interface has been known to not function with some
  newer parallel port chipsets.  These newer chipsets don't allow the computer
  to read a pin that's being used as aninput by DirectPad Pro, and there's
  no known workaround.  Your only option is to get an older parallel port card.
  The same goes for the "Pause" button on the Jaguar interface, but this is not
  as catastrophic as the Genesis problem.

  Construction is very straightforward.  Just make sure to double-check the
  orientation of any diodes in the circuits.  Before plugging in your interface
  do a final check, to make sure that all wires are connected properly, and that
  no bare leads or wires are touching anything.  I strongly recommend using
  a cheap, plastic hood for these interfaces, so there's even less chance of
  short-circuiting things.

  See the file "IFACE.GIF" to see how I have my interface hood set up, using a
  slightly modified plastic DB-25 hood.

  I recommend not cutting up your joystick cables to make these interfaces.
  Instead, use the appropriate female or male connector so that you can connect
  any compatible joystick to the one interface.

  It is very easy to find the HD-15 and DB-9 connectors necessary for the
  Jaguar and Atari interfaces, but finding SNES connectors are probably
  impossible.  For the SNES interface I recommend purchasing a SNES joypad
  extension cable and cutting off one end to wire directly to the schematic.

N64 Controllers
  Stephan Hans and Simon Nield have designed a parallel port interface for
  N64 controllers.  Get the schematic and more information from Stephan's
  website:
                           http://www.st-hans.de/N64.htm

  This interface is much more complicated than any of the others in
  DirectPad Pro, and requires a working knowledge of electronics and
  components.  If you can't identify the collector from the base on a
  transistor, or what pin on an IC is pin 1, then DO NOT ATTEMPT TO BUILD
  THE N64 INTERFACE.  I won't support you, and I'm sure Simon and Stephan
  don't have the time to hand-hold the hundreds of folks building this
  interface.

  Let me say again:  IF YOU ARE NOT FAMILIAR WITH ELECTRONICS, ICS,
  AND TRANSISTORS, DO NOT ATTEMPT TO BUILD THE N64 INTERFACE.  If you ARE
  familiar, and have built other projects, then by all means go and hack
  yourself a N64 interface!

Saturn Analog Controllers
  The Saturn interface had to be modified slightly to support analog
  controllers.  If you've built one already, the modification to make it
  match the schematic is simple:  Remove the diode from pin DB25-4, and
  the connections between the DB9-4 of both pads.  (i.e. DB9-4 is no longer
  connected to DB25-5, just DB25-4 without the diode.)

  If you're just running a digital pad and have an interface built
  already, it will still work.  It just won't support plugging an analog
  controller into it.

PlayStation Controllers
  To hook up the second controller duplicate all connections except DB25-10
  and DB25-12. For pad 2, replace the DB25-10 connection with a connection
  to DB25-13, and the DB25-12 with DB25-15.  Note that the parallel port
  may not be able to supply enough power to run a second controller, and
  you may only be able to run one at a time without using an external power
  supply.

  This interface has been built and tested by different folks on several
  analog, digital, Sony(tm) and clone pads. Be aware that it is different
  from SnesKey's interface, and that I will not be supporting SnesKey's
  version since I cannot get it running reliably on my system.

  The PSX-POV controller differs in that the d-pad is used as a POV hat
  instead of the U-V axis pair. Most games that support POV hats will
  work with this controller configuration.

  If you've double-checked your wiring and are still having troubles,
  try using the Advanced tab in the control panel to increase the PSX
  scan delay, try between 3-10 and hit Apply!, then check the Configure
  tab to see if the slowdown helped out.

Playstation Force Feedback
  The optional line is only necessary if you are running a Dual-Shock pad
  and want to use force feedback. If you're not running a dual-shock pad,
  or don't want to use force feedback, don't hook anything up to the
  optional (pad pin 3) pin/line.

  Please take care when hooking up the 9V supply! Incorrect hookup may
  cause problems with the pad or printer port. Do not attempt to power
  the shock motor from your parallel port, this will not work and could
  cause damage to the port.

  I've only got a few games to test the interface on, and most work
  just fine within the pad's simple limitations. A known issue with
  Flight Simulator 98 is that after a crash no shock vibrations will be
  felt. The simple workaround is to deselect "Crash Effects" in the
  forces setup dialog. Other games, like NFS3, Viper Racing (demo),
  and Rogue Squadron work fine with some tweaking.

**Note to Users of Genuine Sony Dual-Shock Pads
  I've been informed that the first time force feedback is initialized
  in the game your pads may switch from analog to digital mode. There's
  no workaround other than to just reselect analog mode on the pad. My
  clone pad uses a physical switch so it doesn't suffer from this
  problem, nor can I debug it.

TurboGrafx Controllers
  Up to 5 TurboGraFX controllers are now supported by DirectPad Pro,
  thanks to help from Steffen Schwenke.  Check his web page out at:
           http://www2.burg-halle.de/~schwenke/parport.html
  for the PCB you need to build to use these controllers.

SNES/NES/VirtualBoy Multiple Controllers
  This release has support for multiple SNES or NES pads, using the
  same interface as SNESKEY.  For pads 2..5 hook them up the same as
  pad 1, but don't make the DB25-10 connection.  Instead, make the
  connection according to the following table:
              (S)NES PAD      DB25 PIN
                    2            12
                    3            13
                    4            15
                    5            11

Software Installation
  Once you've got the interface built, it's time to install the drivers so
  that Windows can communicate with it.  Go to the "Control Panels" window,
  and select the "Game Controllers" icon.

  Select "DirectPad Pro Controller" from the list (this version does not
  have individual drivers for each joystick type). You will then be returned
  to the "Add Game Controller" dialog. For the second time, select the
  "DirectPad Pro Controller" and you're almost done.

  Finally, double-click on the newly installed joystick. Use the dialogs
  to configure to the proper interface, parallel port, and controller
  ID (when using multiple controllers).

  If you're using multiple pads you need to repeat this exercise for as
  many pads as you have connected.

  A new tab, "Advanced" has been added to the control panel to allow
  you to control the rate the computer clocks your PSX and SNES pads.
  Don't change the default value unless your pad isn't functioning properly.
  Values from 3-10 are reasonable settings to try, with larger numbers
  being "more compatible."

**Laptop Users Only
  DirectPad Pro requires certain files from the standard joystick driver
  to function properly. To use DirectPad Pro on a laptop without a
  gameport it is necessary to force Windows to add gameport support.
  Do this via
  Start->Control Panels->Add Hardware->Sound, Video, Game Controllers->
    Microsoft->Gameport Joystick.
  Then install the DirectPad Pro drivers per the instructions above.

Source Code
  I'm making the joystick scanning routine source code (see "JOYSRC.C")
  available.  However, the actual driver code is not public domain,
  and will not be made available. 

  The registry entries that are used to communicate with the VxD are
  documented on the DirectPad Pro web site.

Special Thanks
  Simon Nield and Stephan Hans worked across the North Atlantic sea to
  design a working N64 parallel port interface, and writing scanning code
  to support it!

  Dark Fader <http://www.blackthunder.demon.nl> reverse engineered the PSX
  Shock controller protocol.

  Thanks to Juan Berrocal <http://gran-berro.webjump.com> for the original
  PlayStation interface.

  Thanks to Sam Hu <sam_h@163.net> for the Saturn multi-controller interface.
  And thanks to Tom Berrodin for the Saturn analog controller protocol!

  Thanks in general to all the FAQ keepers for the various arcade systems.  Without
  their work I'd not have been able to design these interfaces.  Also, thanks to
  Benji York, who helped debug the SNES driver.  He has a similiar program and
  interface for DOS, Windows 3.x, and Win95, SNESKey.  Check out:
                  http://www.csc.tntech.edu/~jbyork/

Comments
  If you've had a good or bad experience with DirectPad Pro, I'd like to hear
  about it. Mail me at earle@ziplabel.com.

