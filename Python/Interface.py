# RoboDK API
from robolink import * 
# Robot toolbox
from robodk import *
import os
import time
import matlab
import matlab.engine
import sys

def myexcepthook(type, value, traceback, oldhook=sys.excepthook):
    oldhook(type, value, traceback)
    input("Press RETURN. ")    # use input() in Python 3.x

sys.excepthook = myexcepthook
#Generate a Robolink object RDK. This object interfaces with RoboDK.
print('Starting RoboDK')    
RDK = Robolink()
# Set filedirectiry for placement of matlab code and RoboDK file
filedirectoryRoboDK = os.path.normpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, 'RoboDK'))
filedirectoryMatlab = os.path.normpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, 'Matlab'))

#Open RoboDK file
RoboDKFile = filedirectoryRoboDK + r'\Assembly Cell.rdk'
#RDK.AddFile(RoboDKFile)
robot = RDK.Item('M-6IB', 2)

# Start MATLAB engine, and set cd to placement of matlab functions.
print('Starting Matlab engine')
eng=matlab.engine.start_matlab()
eng.cd(filedirectoryMatlab)

keepGoing = True
while keepGoing == True:

    #Initilies all the programs 
    programInterior = RDK.Item('AssembleInterior')
    programTop1 = RDK.Item('Attach_Top_Cover_Blue')
    programTop2 = RDK.Item('Attach_Top_Cover_Red')
    programDetach = RDK.Item('Detach_Top')
    ProgramFinalStep = RDK.Item('Final step')

    #Makes sure that alle the parts are in the right places before starting the assembly 
    reset = RDK.Item('Reset')
    reset.RunProgram()

    #Lets you choose the color for the bottom and top cover 
    colorBottom = int(input('Choose a color for the bottom cover: \n 0 = Red \n 1 = Blue \n'))
    colorTop = int(input('Choose a color for the top cover: \n 0 = Red \n 1 = Blue \n'))
    proceed = input('Do you want custom text? [yes/no]\n')
    # Notify user:
    if proceed == 'yes':
        text = input('Write custom text: ')
        #If text is not upper case or too long, try again
        while text.isupper() != True or len(text)>4:
            text = input('Text should be upper case and less than 5 characters.\nTry again: ')
    if colorBottom == 0:
        #Attatch the red bottom cover 
        print('Picking up bottom cover...\n')
        eng.AttachBottomCoverRed(0.0)
    elif colorBottom == 1:
        #Attatch the blue bottom cover 
        print('Picking up bottom cover...\n')
        eng.AttachBottomCoverBlue(0.0)
    else:
        print('ERROR:\n')

    if proceed == 'yes':
        print('Engraving text...')
        #Initialise program
        item = RDK.Item('base')
        gcodeGenerator = RDK.Item('Generate G-Code')
        gcodeImport = RDK.Item('Import G-Code')
        pickupPhone = RDK.Item('Attach_phone')
        viaPoint = RDK.Item('Via_engraver')


        #Generate g-code for engraving text
        text = str(('%s' % text))
        gcodeGenerator.RunProgram([('%s' % text)])
        while gcodeGenerator.Busy():
            time.sleep(.300)

        #Run program to import g-code
        gcodeImport.RunProgram()
        while gcodeImport.Busy():
            time.sleep(.300)

        #Move to via point
        robot.MoveJ(viaPoint)

        #Run g-code
        Milling = RDK.Item('Millingsettings',8)
        time.sleep(.300)
        Milling.RunProgram()
        while Milling.Busy():
            time.sleep(.100)

        #Delete auto-generated files
        Milling.Delete()
        Milling = RDK.Item('Millingsettings')
        Milling.Delete()

        #Move to via point
        robot.MoveJ(viaPoint)
    
    print('Putting down buttom cover...')
    eng.DetachBottomCover(0.0)
    programInterior.RunProgram()
    while programInterior.Busy():
        print('Placing interior...\n')
        time.sleep(1)

    if colorTop == 0:
        #Calls the 'Assemble Red Phone' program 
        programTop2.RunProgram()
        while programTop2.Busy(): 
            print('Placing top cover...\n')
            time.sleep(1)
    elif colorTop == 1:
        #Calls the 'Assemble Blue Phone' program 
        programTop1.RunProgram()
        while programTop1.Busy():
            print('Placing top cover...\n')
            time.sleep(1)
    else:
        print('ERROR:\n')

    programDetach.RunProgram()
    while programDetach.Busy():
        print('Placing top cover...\n')
        time.sleep(1)

    ProgramFinalStep.RunProgram()
    while ProgramFinalStep.Busy():
        print('Placing to the side...\n')
        time.sleep(1)
    
    #Want antoher one?  
    answer=input('Want another one? [yes/no]\n')
    keepGoing=(answer=='yes')