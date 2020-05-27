# RoboDK API
from robolink import *
# Robot toolbox
from robodk import *
import os
import time
import sys


# Create an exception when an error occurs and wait for a button to be pressed
def myexcepthook(type, value, traceback, oldhook=sys.excepthook):
    oldhook(type, value, traceback)
    input("Press RETURN. ")
sys.excepthook = myexcepthook


class Interface:

    # Constructor
    def __init__(self):
        # Set filedirectiry for placement of matlab code and RoboDK file
        filedirectoryRoboDK = os.path.normpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, 'RoboDK'))

        # Generate a Robolink object RDK. This object interfaces with RoboDK.
        print('Starting RoboDK')
        self.RDK = Robolink()

        # Open RoboDK file
        RoboDK_file = filedirectoryRoboDK + r'\Assembly Cell.rdk'
        self.RDK.AddFile(RoboDK_file)
        self.robot = self.RDK.Item('M-6IB', 2)

        # Initilize all RoboDK programs
        self.program_interior = self.RDK.Item('AssembleInterior')
        self.program_top_blue = self.RDK.Item('Attach_Top_Cover_Blue')
        self.program_top_red = self.RDK.Item('Attach_Top_Cover_Red')
        self.program_detach = self.RDK.Item('Detach_Top')
        self.program_final_step = self.RDK.Item('Final step')
        self.program_bottom_blue = self.RDK.Item('Attach_Bottom_Cover_Blue')
        self.program_bottom_red = self.RDK.Item('Attach_Bottom_Cover_Red')
        self.program_detach_bottom = self.RDK.Item('Detach_Bottom')
        
        #Run the program
        self.run_program()

    def run_program(self):
        run_assembly = True
        while run_assembly == True:
            # Reset program
            self.reset()
            # Get user input
            self.user_prompts()
            # Place bottom cover in assembly fixture by using inverse kinematics
            self.place_buttom_cover()
            # Assemble interior of the phone
            self.assemble_interior()
            # Place the final product on an conveyour belt.
            self.program_final_step.RunProgram()
            while self.program_final_step.Busy():
                time.sleep(.300)
            # Ask the user if they want to produce another phone.
            answer = input('Want another one? [yes/no]\n')
            run_assembly = (answer == 'yes')

    #User input
    def user_prompts(self):
        # Lets you choose the color for the bottom and top cover
        self.color_bottom = int(input('Choose a color for the bottom cover: \n 0 = Red \n 1 = Blue \n'))
        self.color_top = int(input('Choose a color for the top cover: \n 0 = Red \n 1 = Blue \n'))
        self.engraving_prompt = input('Do you want custom text? [yes/no]\n')
        
        # Notify user:
        if self.engraving_prompt == 'yes':
            self.text = input('Write custom text: ')
            # If text is not upper case or too long, try again
            while self.text.isupper() != True or len(self.text) > 5:
                self.text = input(
                    'Text should be upper case and less than 6 characters.\nTry again: ')


    def assemble_interior(self):
        print('Placing interior...\n')
        self.program_interior.RunProgram()
        while self.program_interior.Busy():
            time.sleep(.300)

        if self.color_top == 0:
            # Calls the 'Assemble Red Phone' program
            print('Placing top cover...\n')
            self.program_top_red.RunProgram()
            while self.program_top_red.Busy():
                time.sleep(.300)
        elif self.color_top == 1:
            # Calls the 'Assemble Blue Phone' program
            print('Placing top cover...\n')
            self.program_top_blue.RunProgram()
            while self.program_top_blue.Busy():
                time.sleep(.300)
        else:
            print('ERROR:\n')

        print('Placing top cover...\n')
        self.program_detach.RunProgram()
        while self.program_detach.Busy():
            time.sleep(.300)

    def reset(self):
        # Makes sure that alle the parts are in the right places before starting the assembly
        reset_program = self.RDK.Item('Reset')
        reset_program.RunProgram()

    # params text engraving or not
    def engrave_run(self):
        print('Engraving text...')
        # Initialise program
        gcodeGenerator = self.RDK.Item('Generate G-Code')
        gcodeImport = self.RDK.Item('Import G-Code')
        pickupPhone = self.RDK.Item('Attach_phone')
        viaPoint = self.RDK.Item('Via_engraver')
        # Generate g-code for engraving text
        text = str(('%s' % self.text))
        gcodeGenerator.RunProgram([('%s' % text)])
        while gcodeGenerator.Busy():
            time.sleep(.300)

        # Run program to import g-code
        gcodeImport.RunProgram()
        while gcodeImport.Busy():
            time.sleep(.300)

        # Move to via point
        self.robot.MoveJ(viaPoint)

        # Run g-code
        Milling = self.RDK.Item('Millingsettings', 8)
        time.sleep(.300)
        Milling.RunProgram()
        while Milling.Busy():
            time.sleep(.100)

        # Delete auto-generated files
        Milling.Delete()
        Milling = self.RDK.Item('Millingsettings')
        Milling.Delete()

        # Move to via point
        self.robot.MoveJ(viaPoint)

    def place_buttom_cover(self):
        
        if self.color_bottom == 0:
            # Attatch the red bottom cover
            print('Picking up bottom cover...\n')
            self.program_bottom_red.RunProgram()
            while self.program_bottom_red.Busy():
                time.sleep(.300)
        elif self.color_bottom == 1:
            # Attatch the blue bottom cover
            print('Picking up bottom cover...\n')
            self.program_bottom_blue.RunProgram()
            while self.program_bottom_blue.Busy():
                time.sleep(.300)
        else:
            print('ERROR:\n')

        # Run engraving
        if self.engraving_prompt == 'yes':
            self.engrave_run()

        # Detatch bottom cover
        print('Putting down buttom cover...')
        self.program_detach_bottom.RunProgram()
        while self.program_detach_bottom.Busy():
            time.sleep(.300)


program = Interface()
