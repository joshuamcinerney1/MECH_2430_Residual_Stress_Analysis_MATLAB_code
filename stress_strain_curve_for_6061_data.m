clear all
clc
close all
format long

%stress strain data for 6061 

filename = '6061_stress_strain_data_2.txt';
fileID = fopen(filename);
B = textscan(fileID,'%s');
fclose(fileID);
whos B

A = [B{:}];
A = cellfun(@str2double,A);

%seperate the single cell into the two columns
%length of the test piece vector is L
%force applied is vector F

L = 1;
F = 1;

Totallength = length(A);

for i=1:2:Totallength
    
    Test_piece_length(L) = A(i,1);
    L = L +1;
end

for j=2:2:Totallength
    
    Force_applied(F) = A(j,1);
    F = F+1;
end
%now they are separated, can figure out the stress and strain
%calculate stress
%sigma (Kpa) = force (KN) * area (m^2)
%establish the area of the dogbone in m^2
Area = (62.5*(10^(-6)));

%the force in KN is in the Force vector

for i = 1:length(Force_applied)
    force = Force_applied(i);
    sigma(i) = (force * 10^3)/Area;
    
end

%sigma is the stress in MPa
%calculate strain
%strain = change in length / original length
%the original length(as stated in the lecture) is the first clip
%measurement

original_length = 39.965425670;

%the change in length is in the vector Test piece length

for i = 1: length(Test_piece_length)
    delta = Test_piece_length(i);
    strain(i) = (delta - original_length)/(original_length);
end

%calculate the modulus of elasticity of the material
%E = (stress2 - stress 1)/(strain2 - strain1)

E = (sigma(3000) - sigma (100))/(strain(3000) - strain(100));


figure, plot(strain,sigma)
xlabel('Strain')
ylabel('Stress (Pa)')
title('6061-T6 Aluminium Stress-Strain Curve')
ax = gca;
ax.YAxis.Exponent = 6;
dim = [0.5 0.3 0.3 0.3];
str = {'Modulus of Elasticity = 70.12 GPa','Yield Strength = 290 MPa'};
annotation('textbox',dim,'String',str,'FitBoxToText','on');







