function MoveToGoal(Target, TCP_Matrix, TrajectoryMethod, robot)
%This funtion moves the robot to a target from RoboDK, by calculating the
%the joint angles using the function 'inversekinematicsMatrix'

%Generate a Robolink object RDK. This object interfaces with RoboDK.
RDK = Robolink;

%Initilies the robot
robot = RDK.Item(robot);
%Find the base refference frame for the 'robot'
ref_base = robot.Parent();
  
%Finds a transformation matrix to the 'target' 
Target_postition = RDK.Item(Target).PoseAbs() * inv(TCP_Matrix); 
Target_postition(3,4) = Target_postition(3,4) - 450;

%Finds the joint angles using the funtion 'inversekinematicsMatrix'
Goal_Angles = inversekinematicsMatrix(Target_postition);
disp(Goal_Angles)

%moves either with joint movement or linary movement
if TrajectoryMethod == 0 
    robot.MoveJ(Goal_Angles);
else 
    robot.MoveL(Goal_Angles);
end

end

 