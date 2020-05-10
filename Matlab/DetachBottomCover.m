function value = DetachBottomCover(input)

RDK = Robolink;

tool = RDK.Item('TCP_Cover');
TCP = tool.PoseTool();

MoveToGoal('ASM_APP_COVER', TCP, 0, 'M-6IB');
MoveToGoal('ASM_Bottom_cover', TCP, 1, 'M-6IB');
tool.DetachAll();
RDK.Item('Open gripper').RunProgram();

MoveToGoal('ASM_APP_COVER', TCP, 1, 'M-6IB');

value = input;

end

