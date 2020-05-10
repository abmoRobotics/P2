function MoveToFixture()

RDK = Robolink;

tool = RDK.Item('TCP_Cover');

%tool.AttachClosest();
MoveToGoal('ASM_APP_COVER', TCP_Cover, 0, 'M-6IB');
MoveToGoal('ASM_Bottom_cover', TCP_Cover, 1, 'M-6IB');
tool.DetachAll();
end