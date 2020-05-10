# RoboDK API
from robolink import *
# Robot toolbox
from robodk import *
import os
import time
import matlab
import matlab.engine
import sys


# Create an exception when an error occurs and wait for a button to be pressed
def myexcepthook(type, value, traceback, oldhook=sys.excepthook):
    oldhook(type, value, traceback)
    input("Press RETURN. ")
sys.excepthook = myexcepthook

# Generate a Robolink object RDK. This object interfaces with RoboDK.
print('Starting RoboDK')
RDK = Robolink()
# Set filedirectiry for placement of matlab code and RoboDK file
filedirectoryRoboDK = os.path.normpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, 'RoboDK'))
filedirectoryMatlab = os.path.normpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, 'Matlab'))

# Open RoboDK file
RoboDKFile = filedirectoryRoboDK + r'\Assembly Cell.rdk'
# RDK.AddFile(RoboDKFile)
robot = RDK.Item('M-6IB', 2)

# Start MATLAB engine, and set cd to placement of matlab functions.
print('Starting Matlab engine')
eng = matlab.engine.start_matlab()
eng.cd(filedirectoryMatlab)

keepGoing = True
while keepGoing == True:

    # Initilize all RoboDK programs
    program_interior = RDK.Item('AssembleInterior')
    program_top_blue = RDK.Item('Attach_Top_Cover_Blue')
    program_top_red = RDK.Item('Attach_Top_Cover_Red')
    program_detach = RDK.Item('Detach_Top')
    program_final_step = RDK.Item('Final step')

    # Makes sure that alle the parts are in the right places before starting the assembly
    reset_program = RDK.Item('Reset')
    reset_program.RunProgram()

    # Lets you choose the color for the bottom and top cover
    color_bottom = int(
        input('Choose a color for the bottom cover: \n 0 = Red \n 1 = Blue \n'))
    color_top = int(
        input('Choose a color for the top cover: \n 0 = Red \n 1 = Blue \n'))
    engraving_prompt = input('Do you want custom text? [yes/no]\n')
    # Notify user:
    if engraving_prompt == 'yes':
        text = input('Write custom text: ')
        # If text is not upper case or too long, try again
        while text.isupper() != True or len(text) > 4:
            text = input(
                'Text should be upper case and less than 5 characters.\nTry again: ')
    if color_bottom == 0:
        # Attatch the red bottom cover
        print('Picking up bottom cover...\n')
        eng.AttachBottomCoverRed(0.0)
    elif color_bottom == 1:
        # Attatch the blue bottom cover
        print('Picking up bottom cover...\n')
        eng.AttachBottomCoverBlue(0.0)
    else:
        print('ERROR:\n')

    ###################################
    # Engraving Program
    ###################################
    if engraving_prompt == 'yes':
        print('Engraving text...')
        # Initialise program
        gcode_generator = RDK.Item('Generate G-Code')
        gcode_import = RDK.Item('Import G-Code')
        via_point = RDK.Item('Via_engraver')
        # Generate g-code for engraving text
        text = str(('%s' % text))
        gcode_generator.RunProgram([('%s' % text)])
        while gcode_generator.Busy():
            time.sleep(.300)

        # Run program to import g-code
        gcode_import.RunProgram()
        while gcode_import.Busy():
            time.sleep(.300)

        # Move to via point
        robot.MoveJ(via_point)

        # Run g-code
        Milling = RDK.Item('Millingsettings', 8)
        time.sleep(.300)
        Milling.RunProgram()
        while Milling.Busy():
            time.sleep(.100)

        # Delete auto-generated files
        Milling.Delete()
        Milling = RDK.Item('Millingsettings')
        Milling.Delete()

        # Move to via point
        robot.MoveJ(via_point)




    print('Putting down buttom cover...')
    eng.DetachBottomCover(0.0)
    program_interior.RunProgram()
    while program_interior.Busy():
        print('Placing interior...\n')
        time.sleep(1)

    if color_top == 0:
        # Calls the 'Assemble Red Phone' program
        program_top_red.RunProgram()
        while program_top_red.Busy():
            print('Placing top cover...\n')
            time.sleep(1)
    elif color_top == 1:
        # Calls the 'Assemble Blue Phone' program
        program_top_blue.RunProgram()
        while program_top_blue.Busy():
            print('Placing top cover...\n')
            time.sleep(1)
    else:
        print('ERROR:\n')

    program_detach.RunProgram()
    while program_detach.Busy():
        print('Placing top cover...\n')
        time.sleep(1)

    program_final_step.RunProgram()
    while program_final_step.Busy():
        print('Placing to the side...\n')
        time.sleep(1)

    # Want antoher one?
    answer = input('Want another one? [yes/no]\n')
    keepGoing = (answer == 'yes')

