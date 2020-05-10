function returntarget = inversekinematicsMatrix(GoalMatrix)
%INVERSEKINEMATICS
%This function does inverse kinematics for a fanuc M-6IB/6s robot
%Variables for storing measurements of robot
L3=430;
L2=360;
a4=100;
a2=150;

%Translational matrix from axis6 to wrist
T6_W=[  1,  0,  0,  0;
        0,  -1, 0,  0;
        0,  0,  -1, -100;
        0,  0,  0,  1];
  

%Find goalcoordinates for axis 0-6.
Joint06Goal=GoalMatrix*inv(T6_W);


%Joint1 - First possible solution
t1a=atan2(Joint06Goal(2,4),Joint06Goal(1,4));
%Joint1 - Second possible solution
t1b=t1a+pi;
if rad2deg(t1b)>170
    t1b=t1b-2*pi;
end

%Numbers for use in calculation of first possible solutions for Joint 2 & 3
l3a = Joint06Goal(1,4)/cos(t1a)-a2;
l1a =sqrt(l3a^2+(Joint06Goal(3,4))^2);
l2a = sqrt(L3^2+a4^2);
phi1a=acos((L2^2+l2a^2-l1a^2)/(2*L2*l2a));
phi2a=acos((L2^2+l1a^2-l2a^2)/(2*L2*l1a));
phi3a=atan2(a4,L3);
phi4a=atan2(Joint06Goal(3,4),l3a);
phi5a=pi-phi1a-phi2a;

%Numbers for use in calculation of second possible solutions for Joint 2 & 3
l3b = Joint06Goal(1,4)/cos(t1b)-a2;
l1b =sqrt(l3b^2+(Joint06Goal(3,4))^2);
l2b = sqrt(L3^2+a4^2);
phi1b=acos((L2^2+l2b^2-l1b^2)/(2*L2*l2b));
phi2b=acos((L2^2+l1b^2-l2b^2)/(2*L2*l1b));
phi3b=atan2(a4,L3);
phi4b=atan2(Joint06Goal(3,4),l3b);
phi5b=pi-phi1b-phi2b;

%Joint2 - four possible solutions
t2a=pi/2-phi2a-phi4a;
t2b=pi/2+phi2a-phi4a;
t2c=pi/2-phi2b-phi4b;
t2d=pi/2+phi2b-phi4b;

%Joint3 - four possible solutions
t3a=phi4a+phi2a-(pi-phi1a)-phi3a;
t3b=phi4a-phi2a+(pi-phi1a)-phi3a;
t3c=phi4b+phi2b-(pi-phi1b)-phi3b;
t3d=phi4b-phi2b+(pi-phi1b)-phi3b;

%Solutions are stored in a matrix
Solutions = [rad2deg(t1a), rad2deg(t2a), rad2deg(t3a);
             rad2deg(t1a), rad2deg(t2b), rad2deg(t3b);
             rad2deg(t1b), rad2deg(t2c), rad2deg(t3c);
             rad2deg(t1b), rad2deg(t2d), rad2deg(t3d)];
        

%Counter for amount of real solutions to t1,t2,t3
j=0;
%Store all possible solutions in a matrix
for i=1:4
    if (-170<Solutions(i,1)) && (Solutions(i,1)<170) && (-90<Solutions(i,2)) && (Solutions(i,2)<160) && (-80-Solutions(i,2)<Solutions(i,3)) && (Solutions(i,3)<80-Solutions(i,2))
        j = j+1;
        LegalSolutions13(j,:) = Solutions(i,:);        
    end
end

%Counter for amount of solutions to t4,t5
k=0;
%Matrix from 4-6 is calcualted for all possible solutions
for i=1:j
    Joint46Goal = inv(matrix13(deg2rad(LegalSolutions13(i,1)),deg2rad(LegalSolutions13(i,2)),deg2rad(LegalSolutions13(i,3))))*Joint06Goal;
    t5a=acos(Joint46Goal(2,3));
    t5b=-acos(Joint46Goal(2,3));
    t4a=atan2(Joint46Goal(3,3)*sin(t5a),-Joint46Goal(1,3)*sin(t5a));
    t4b=atan2(Joint46Goal(3,3)*sin(t5b),-Joint46Goal(1,3)*sin(t5b));
    %Solutions are stored in a matrix
    k=k+1;
    LegalSolutions15(k,:) = [LegalSolutions13(i,1), LegalSolutions13(i,2), LegalSolutions13(i,3), rad2deg(t4a), rad2deg(t5a)];
    k=k+1;
    LegalSolutions15(k,:) = [LegalSolutions13(i,1), LegalSolutions13(i,2), LegalSolutions13(i,3), rad2deg(t4b), rad2deg(t5b)];     
end

%Counter for amount of solutions to t6
n=0;
for i=1:k
   Joint6Goal=inv(matrix15(deg2rad(LegalSolutions15(i,1)), deg2rad(LegalSolutions15(i,2)), deg2rad(LegalSolutions15(i,3)), deg2rad(LegalSolutions15(i,4)), deg2rad(LegalSolutions15(i,5))))*Joint06Goal;
   t6a=rad2deg(atan2(Joint6Goal(1,2), -Joint6Goal(1,1)));
   %t6b is t6a+-360 degress, depending on value of t6a.
   if t6a>0
       t6b=rad2deg(deg2rad(t6a)-2*pi);
   else 
       t6b=rad2deg(deg2rad(t6a)+2*pi);
   end
   %Solutions are stored in a matrix
   n=n+1;
   LegalSolutions16(n,:) = [LegalSolutions15(i,1), LegalSolutions15(i,2), LegalSolutions15(i,3), LegalSolutions15(i,4), LegalSolutions15(i,5), t6a];
   n=n+1;
   LegalSolutions16(n,:) = [LegalSolutions15(i,1), LegalSolutions15(i,2), LegalSolutions15(i,3), LegalSolutions15(i,4), LegalSolutions15(i,5), t6b];
end
%Counter for amount of legal solutions to t1,t2,t3,t4,t5,t6.
l=0;
for i=1:n
    if (-190<LegalSolutions16(i,4)) && (LegalSolutions16(i,4)<190) && (-140<LegalSolutions16(i,5)) && (LegalSolutions16(i,5)<140) && (-360<LegalSolutions16(i,6)) && (LegalSolutions16(i,6)<360)
        l=l+1;
        %Solutions are stored in a matrix
        FinalSolutions16(l,:)= LegalSolutions16(i,:);        
    end
end
%Display all solutions
% disp('The legal solutions to t1,t2,t3,t4,t5,t6 are:');
% disp(FinalSolutions16);

%Return first possible solution

returntarget = FinalSolutions16(1,:);

end