% CSE 824 Project Main
% Main Driver File
% Jesse Hoskins & AJ Saclayan
% Started on 10/22/18

%% import data

%import bluetooth rssi
%BR=csvread('iBeacon_RSSI_Labeled1.csv', 1, 1);
Mixed = readtable('iBeacon_RSSI_Labeled1.csv');

close all
% figure
% hold on
rssi_sub1=cse824_DataPreprocess('rssi_sub1.csv', 'b+');
rssi_sub1_n=cse824_DataPreprocess('rssi_sub1_noise.csv', 'b+');
rssi_ova1=cse824_DataPreprocess('rssi_ova1.csv', 'b+');
rssi_ova1_n=cse824_DataPreprocess('rssi_ova1_noise.csv', 'b+');
% legend('Sub 1', 'Sub 1 N', 'Ova 1', 'Ova 1 N');
% hold off

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