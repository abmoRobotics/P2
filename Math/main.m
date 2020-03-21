clear all
%Dette dokument bruges til at kalde funktionerne der er defineret hhv.
%Forwardkinematics(from,to)
%ForwardKinematicsRoboDK(from,to)

%%RoboDK
T0_6=forwardKinematicsRoboDK(1,6);     %Joint 0 to Joint 6
T0_3=forwardKinematicsRoboDK(1,3);     %Joint 0 to Joint 3
T3_6=forwardKinematicsRoboDK(4,6);     %Joint 3 to Joint 6
T0_W=forwardKinematicsRoboDK(1,'W');   %Joint 0 to Wrist
simplify(T3_6)

%%RoboGuide
T0_6=forwardKinematics(1,6);     %Joint 0 to Joint 6
T0_3=forwardKinematics(1,3);     %Joint 0 to Joint 3
T3_6=forwardKinematics(4,6);     %Joint 3 to Joint 6
T0_W=forwardKinematics(1,'W');   %Joint 0 to Wrist
simplify(T3_6)                   %Joint 3 to 6
simplify(inv(T0_3)*T0_6)         %Joint 3 to 6

