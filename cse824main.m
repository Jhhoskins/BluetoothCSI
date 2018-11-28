% CSE 824 Project Main
% Main Driver File
% Jesse Hoskins & AJ Saclayan
% Started on 10/22/18

%% import data

%import bluetooth rssi
%BR=csvread('iBeacon_RSSI_Labeled1.csv', 1, 1);
Mixed = readtable('iBeacon_RSSI_Labeled1.csv');

close all
 figure
 hold on
[rssi_sub1, time1] = cse824_DataPreprocess('rssi_sub1.csv', 'k+');
[rssi_sub1_n, time2] = cse824_DataPreprocess('rssi_sub1_noise.csv', 'b+');
[rssi_ova1, time3] = cse824_DataPreprocess('rssi_ova1.csv', 'r+');
[rssi_ova1_n, time4] = cse824_DataPreprocess('rssi_ova1_noise.csv', 'g+');
xlabel('Time');
ylabel('RSSI Mag');
title('RSSI');
legend('Sub 1', 'Sub 1 N', 'Ova 1', 'Ova 1 N');
 hold off

 %% perform filtering
MedianFilterWindow = [1/5 12/5 15/5]*5;         % NO median filtering actually smoother for phase, and may be more finegrained/precise as well. Might not be accurate
MovingAvgWindow = [10/5 15/5 15/5]*5;           %just an array of [10 15 15]. Don't know why there's scalar mult. Doesn't seem like types are diff

 RSSI_1 = rssi_ova1_n;
 RSSI_1 = medfilt1(RSSI_1,MedianFilterWindow(3));
 RSSI_1 = conv(RSSI_1, ones(1,MovingAvgWindow(3))/MovingAvgWindow(3), 'valid');
 
figure
hold on
plot(RSSI_1)
plot(rssi_ova1_n)
xlabel('Time');
ylabel('RSSI Mag');
title('RSSI with Kams Filter');
legend('Filtered', 'Original');
hold off
%import estimated csi info

%% Initial data plots
%RSSIStats = cse824PlotRSSIData(Mixed, 10, 1);

%% Generate signal strength model

%filter

%plot the rssi to see where the most noise is
%apply a lpf to remove high frequency noise (comes from wifi csi)
%use PCA

%denoise

%dimensionality reduction?

%% Keystroke extraction

%% Print Results