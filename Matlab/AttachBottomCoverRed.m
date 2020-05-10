function value = AttachBottomCoverRed(input)
RDK = Robolink;
 
tool = RDK.Item('TCP_Cover');

TCP = tool.PoseTool();

RDK.Item('Open gripper').RunProgram();

MoveToGoal('APP_Red_bottom', TCP, 0, 'M-6IB');

MoveToGoal('APP_Red_bottom', TCP, 0, 'M-6IB');
MoveToGoal('Red_bottom', TCP, 1, 'M-6IB');
RDK.Item('Close gripper').RunProgram();
tool.AttachClosest();
MoveToGoal('APP_Red_bottom', TCP, 1, 'M-6IB');

value = input;

end 