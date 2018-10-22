% CSE 824 Project Main
% Main Driver File
% Jesse Hoskins & AJ Saclayan
% Started on 10/22/18

%% import data

%import bluetooth rssi, in this case starting after the locations
BR=csvread('iBeacon_RSSI_Labeled1.csv', 1, 1);
%formatSpec='%C%%f%f%f%f%f%f%f%f%f%f%f%f';
Mixed = readtable('iBeacon_RSSI_Labeled1.csv');
%sort the full matrix
Copy=sortrows(Mixed,1);

%create a matrix of just RSSI readings
MatCopy=table2array(Copy(:,2:end));

%find index of location of interest
% get a table of just the lcoations
subcell=Copy(:,1);
% get a cell array of just the locations
subcell=table2array(subcell);
% find the index of the location of interest

[uniquesubcell, ~, J]=unique(subcell); 
occ = histc(J, 1:numel(uniquesubcell));
%find the top K values
k = 10;
[~, I]=maxk(occ, k);
for j=1:k
    tempval=uniquesubcell(I(j));
    d13idx=find(strcmp(subcell, tempval));

    %select the subset of rssi values that correspond with the location of
    %interest
    MatCopyNew=MatCopy(d13idx, :);
    minval = 100;
    for i=1:size(MatCopyNew,2)
        tempmin=sum(MatCopyNew(:,i)==-200);
        if tempmin < minval
            minval=tempmin
            idx = i
        end
    end
    %subset of rssi values
    RSSI=MatCopyNew(:, idx);
    RSSI(RSSI==-200)=[];
    %% 


    Beacon1 = BR(:,1);
    Beacon1(Beacon1==-200)=[];
    FakeTime = linspace(0, 100, size(RSSI,1));
    %FakeTime = linspace(0, 100, size(Beacon1,1));

    %Plot signal
    figure;
    hold on
    plot(FakeTime, RSSI, 'r+');
    %plot(FakeTime, Beacon1, 'r+');
    xlabel('Time');
    ylabel('RSSI Mag');
    hold off
end
%import estimated csi info

%% Initial data plots

%% Generate signal strength model

%filter

%plot the rssi to see where the most noise is
%apply a lpf to remove high frequency noise (comes from wifi csi)
%use PCA

%denoise

%dimensionality reduction?

%% Keystroke extraction

%% Print Results