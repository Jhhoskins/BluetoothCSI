%cse824_dronelander.m
%Jesse Hoskins & AJ Saclayan
%11/27/18

%Let's get it

%% generate localization model
%define filenames for import
filename1='rssi_cal1.csv';
filename2='rssi_cal3.csv';
filename3='rssi_cal4.csv';
filename4='rssi_cal6.csv';
filename5='rssi_cal8.csv';

filenames = [filename1; filename2; filename3; filename4; filename5];
%true distance in feet for corresponding filenames
dist1 = 1;
dist2 = 3;
dist3 = 4;
dist4 = 6;
dist5 = 8;
distances = [dist1 dist2 dist3 dist4 dist5];

% %dummy for jesse use only
% filenames = ['rssi_sub1.csv'; 'rssi_subN.csv'; 'rssi_ova1.csv'; 'rssi_ovaN.csv'];
% distances = [3 3 6 6];

%init the struct
rss_struct = struct;
%loop through files to get fit params for each
for i=1:size(filenames,1)-1
    %create variables to label the rssi struct correctly
    tempStr = 'RSS';
    tempNum = num2str(i);
    tempStr = strcat(tempStr, tempNum);
    [m_arr(i), c_arr(i), n_arr(i), rss_struct.(tempStr)] = cse824_genmodel(distances(i),filenames(i,:), distances(i+1), filenames(i+1,:));    
end
%read and add the last rssi data file to the struct
rssi_data1=csvread(filenames(size(filenames,1),:));
tempStr = 'RSS';
tempNum = num2str(size(filenames,1));
tempStr = strcat(tempStr, tempNum);
rss_struct.(tempStr)=rssi_data1;

%average params, iterated
m_itr = mean(m_arr);
c_itr = mean(c_arr);
n_itr = mean(n_arr);

% %dummy for jesse only
% m_itr = 9.137;
% c_arr = -98.44;


%convert to cell for ease of use
rss_cell = struct2cell(rss_struct);
% Distance = 10^((RSS-C)/(-m))

for i=1:size(filenames,1)
   
   temp_rss=rss_cell{i} ;
   %calc the estimated distance
   Distance = 10.^((temp_rss-c_itr)/(-m_itr));
   %get the real distance from the true distance matrix
   real_Distance = linspace(distances(i), distances(i), length(temp_rss));
   %plot
   figure;
   hold on;
   plot(Distance, 'r');
   plot(real_Distance, 'b');
   title(filenames(i, :))
   xlabel('Fake Time');
   ylabel('Distance (ft)');
   hold off;
   
end


% 
% %single shot/manual, get fit params
% [mA, cA, nA] = cse824_genmodel(dist1,filename1, dist2, filename2);
% [mB, cB, nB] = cse824_genmodel(dist2,filename2, dist3, filename3);
% [mC, cC, nC] = cse824_genmodel(dist1,filename1, dist3, filename3);
% %average params, manual
% m=mean([mA mB mC]);
% c=mean([cA cB cC]);
% n=mean([nA nB nC]);
