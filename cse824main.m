% CSE 824 Project Main
% Main Driver File
% Jesse Hoskins & AJ Saclayan
% Started on 10/22/18

%% import data

%import bluetooth rssi
%BR=csvread('iBeacon_RSSI_Labeled1.csv', 1, 1);
Mixed = readtable('iBeacon_RSSI_Labeled1.csv');

%import estimated csi info

%% Initial data plots
cse824PlotRSSIData(Mixed, 10, 1);

%% Generate signal strength model

%filter

%plot the rssi to see where the most noise is
%apply a lpf to remove high frequency noise (comes from wifi csi)
%use PCA

%denoise

%dimensionality reduction?

%% Keystroke extraction

%% Print Results