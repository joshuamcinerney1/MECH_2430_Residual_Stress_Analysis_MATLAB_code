clear all
clc
close all

format long

%reading the neutron diffraction data

filename = 'Diffraction_data_7075_2.txt';
fileID = fopen(filename);
B = textscan(fileID,'%s');
fclose(fileID);
whos B

A = [B{:}];
A = cellfun(@str2double,A);

%seperate the single cell into the 5 columns
%spacings are in angstroms
L = 1;
F = 1;
LL = 1;
FF = 1;
LLL = 1;


Totallength = length(A);

for i=1:5:Totallength
    
    y_spacing(L) = A(i,1);
    L = L +1;
end

for j=2:5:Totallength
    
    Axial_Spacing(F) = A(j,1);
    F = F+1;
end
for i=3:5:Totallength
    
    Axial_Error(LL) = A(i,1);
    LL = LL +1;
end

for j=4:5:Totallength
    
    Transverse_Spacings(FF) = A(j,1);
    FF = FF+1;
end
for i=5:5:Totallength
    
    Transverse_Error(LLL) = A(i,1);
    LLL = LLL +1;
end
%stuff for error analysis section
mean = mean(Transverse_Error)
max= max(Transverse_Error)
standard = std(Transverse_Error)

%eastablish the orginal d spacing (angstroms)
d0 = 1.2188861;
%establish the original error measurement
d0_error = (5*(10^-6));

%calculate the percentage error for both the axial and transverse
%measurements

%Percent error calculations
for i = 1:19
    percent_error_Transverse(i) = (Transverse_Error(i)/Transverse_Spacings(i))*100;
    percent_error_Axial(i) = (Axial_Error(i)/Axial_Spacing(i))*100;
end

%strain calculations for both the axial and transverse directions
for i = 1:length(Axial_Spacing)
    Axial_Strain(i) = (Axial_Spacing(i) - d0)/d0;
    Axial_Strain_error(i) = (percent_error_Axial(i) + d0_error + d0_error);
    Axial_Strain_error1(i)= Axial_Strain_error(i) .* Axial_Strain(i);
    Transverse_Strain(i) = (Transverse_Spacings(i) - d0)/d0;
    Transverse_Strain_error(i) = (percent_error_Transverse(i) + d0_error + d0_error);
    Transverse_Strain_error1(i) = Transverse_Strain_error(i).* Transverse_Strain(i);
end
%make new variables for error bars(werent inplemented on graph, were way
%too small)
for i = 1:length(Axial_Spacing)
A_top(i) = Axial_Strain(i) + Axial_Strain_error1(i);
A_bottom(i) = Axial_Strain(i) - Axial_Strain_error1(i);
end
%find the residual elastic stress in the material
%since its elastic, can use hookes law
E = 71.26*(10^9);

for i = 1:length(Axial_Spacing)
    Axial_Stress(i) = E * Axial_Strain(i);
    Transverse_Stress(i) = E * Transverse_Strain(i);
end

% figure (1)
% plot(y_spacing,Axial_Stress, '-r')
% title('7075-T6 Residual Stress in the Axial Direction')
% xlabel('Position Along the Samples Cross Section (mm)')
% ylabel('Axial Residual Stress (Pa)')
% ax = gca;
% ax.YAxis.Exponent = 6;
% 
% figure (2)
% plot(y_spacing,Transverse_Stress, '-k')
% title('7075-T6 Residual Stress in the Transverse Direction')
% xlabel('Position Along the Samples Cross Section (mm)')
% ylabel('Transverse Residual Stress (Pa)')
% ax = gca;
% ax.YAxis.Exponent = 6;

for i = 1:length(Axial_Spacing)
    Total_Stress(i) = Axial_Stress(i) + Transverse_Stress(i);
end

figure (3)
plot(Total_Stress,y_spacing, '-r')
title('7075-T6 Residual Stress Distribution')
xlabel('Transverse Residual Stress (Pa)')
ylabel('Position Along the Samples Cross Section (mm)')
ax = gca;
ax.XAxis.Exponent = 6;
