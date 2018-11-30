%cse824_dabbling
%Jesse Hoskins
%Time to figure out how the heck to get CSI

%Need 2 parameters, SNR, N
%average SNR
%SNR = (E_s/N_0)*E*(alpha^2);
%normrnd(mean, sigma)
%makedist('Nakagami')
% pd=makedist('Nakagami', 'mu', 1.5, 'omega', 1010);
% plot(50:1:250, pdf(pd, 50:1:250))


%%
sheet_names1= ['BLE1_1FT'; 'BLE1_3FT'; 'BLE1_4FT'; 'BLE1_6FT'; 'BLE1_8FT']; 
sheet_names2= ['BLE2_1FT'; 'BLE2_3FT'; 'BLE2_4FT'; 'BLE2_6FT'; 'BLE2_8FT']; 
sheet_names3= ['BLE3_1FT'; 'BLE3_3FT'; 'BLE3_4FT'; 'BLE3_6FT'; 'BLE3_8FT']; 
filename = 'Datasets_Network.xlsx';
data_arr1 = xlsread(filename, sheet_names1(4,:), 'P:P');
data_arr2 = xlsread(filename, sheet_names1(4,:), 'H:H');

%% 

figure;
hold on;
plot(data_arr1)
title('RSSI');
hold off


figure;
hold on;
plot(data_arr2);
title( 'TTL');
hold off

%%
%0=ax^2+bx+c
a = 209.459174179830;
b = -632.893088576470;
c1 =478.443659510047;
%y_quad=209.459174179830*(x.^2)-632.893088576470*x+478.443659510047
c=[-4.77 -3.77 -2.77 -1.77 -.77 .23 1.23 2.23 3.23];
outpos = (-b+ sqrt(b^2-4*a*(c1-c)))/(2*a);
outneg = (-b- sqrt(b^2-4*a*(c1-c)))/(2*a);

b0=-1566.0419834643;
b1= 6973.4026101590;
b2=-10357.0288229892;
b3= 5131.6668286643;
for i=1:length(c)
    p = [b0 b1 b2 b3-c(1)];
  A=roots(p)
  out(i)=real(A(1));
end
%d is in meters
%% 
d=0:20:500;
d0=1;
n=3
n1=3.5
n2=4
c = 2.998e+8;
f = 2.4*1e+9;
Pt = 70;
PL0=Pt*((c/f)^2)./(((4*pi)^2).*d.^2);

PL = PL0 + 10*n*log10(d/d0);
PL1 = PL0 + 10*n1*log10(d/d0);
PL2 = PL0 + 10*n2*log10(d/d0);
N0=-114;
N0=0;
R = 1000000;
R=1;
Pr=Pt-PL;
Pr1=Pt-PL1;
Pr2=Pt-PL2;
snr = Pr+R+N0;
snr1 = Pr1+R+N0;
snr2 = Pr2+R+N0;
 figure;
hold on;
plot(d, snr)
plot(d,snr1)
plot(d,snr2)
legend('3', '3.5','4');
hold off