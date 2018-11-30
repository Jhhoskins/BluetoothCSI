%cse824_dronelander.m
%Jesse Hoskins & AJ Saclayan
%11/27/18

%Let's get it


% Instructions
% Change the filenames to be whatever the calibration data is. As long as 
% the filenames are the same length, in theory, running dronelander in a 
% directory with genmodel and the files should generate the model and plot 
% the est dist vs the real dist. Note you need to set the real distances 
% manually. Also calculates the mean error and places in the title
%% 
% 
% data1 = xlsread('Datasets_Network.xlsx', 'BLE1_1FT', 'P:P');
% data2 = xlsread('Datasets_Network.xlsx', 'BLE1_3FT', 'P:P');
sheet_names1= ['BLE1_1FT'; 'BLE1_3FT'; 'BLE1_4FT'; 'BLE1_6FT'; 'BLE1_8FT']; 
sheet_names2= ['BLE2_1FT'; 'BLE2_3FT'; 'BLE2_4FT'; 'BLE2_6FT'; 'BLE2_8FT']; 
sheet_names3= ['BLE3_1FT'; 'BLE3_3FT'; 'BLE3_4FT'; 'BLE3_6FT'; 'BLE3_8FT']; 
filename = 'Datasets_Network.xlsx';
%true distance in feet for corresponding filenames
dist1 = 1;
dist2 = 3;
dist3 = 4;
dist4 = 6;
dist5 = 8;
distances = [dist1 dist2 dist3 dist4 dist5];
%for calibration
num_exp = length(distances);

% initialize struct for raw data
rssi_raw_struct = struct;
% what column is rssi in
rssi_col = 'P:P';
ttl_col='H:H';
rssi_raw_node1=[];
rssi_raw_node2=[];
rssi_raw_node3=[];
ttl_raw1=[];
ttl_raw2=[];
ttl_raw3=[];
%loop through and read in all data
for i=1:num_exp
    tempStr = 'RSSI_RAW';
    tempStr1 = strcat(tempStr, sheet_names1(i,:));
    tempStr2 = strcat(tempStr, sheet_names2(i,:));
    tempStr3 = strcat(tempStr, sheet_names3(i,:));
    rssi_raw_struct.(tempStr1) = xlsread(filename, sheet_names1(i,:), rssi_col);
    ttl_temp=xlsread(filename, sheet_names1(i,:), ttl_col);
    ttl_raw1= [ttl_raw1 ttl_temp];
    
    rssi_raw_node1 = [rssi_raw_node1 rssi_raw_struct.(tempStr1)];
    rssi_raw_struct.(tempStr2) = xlsread(filename, sheet_names2(i,:), rssi_col);
    ttl_temp=xlsread(filename, sheet_names2(i,:), ttl_col);
    ttl_raw2= [ttl_raw2 ttl_temp];
    rssi_raw_node2 = [rssi_raw_node2 rssi_raw_struct.(tempStr2)];
    rssi_raw_struct.(tempStr3) = xlsread(filename, sheet_names3(i,:), rssi_col);
    rssi_raw_node3 = [rssi_raw_node3 rssi_raw_struct.(tempStr3)];
    ttl_temp=xlsread(filename, sheet_names3(i,:), ttl_col);
    ttl_raw3= [ttl_raw3 ttl_temp];
    %[m_arr_1(i), c_arr_1(i), n_arr_1(i), rss_struct.(tempStr1)] = cse824_genmodel(distances(i),sheet_names1(i,:), distances(i+1), sheet_names1(i+1,:));    
end


%%
% rssi_raw_cell_copy = struct2cell(rssi_raw_struct);
% 
% 
% for j = 1:5
%     
%    adjust_rssi(rssi_raw_cell_copy, ttl_raw1, 1, j);
%    adjust_rssi(rssi_raw_cell_copy, ttl_raw2, 2, j);
%    adjust_rssi(rssi_raw_cell_copy, ttl_raw3, 3, j);
%     
%     
%     
% end

%%


%init the struct
rss_struct = struct;
rssi_raw_cell = struct2cell(rssi_raw_struct);
%loop through files to get fit params for each
for i=1:num_exp-1
    %create variables to label the rssi struct correctly
    tempStr = 'RSS';
    tempStr1 = strcat(tempStr, sheet_names1(i,:));
    tempStr2 = strcat(tempStr, sheet_names2(i,:));
    tempStr3 = strcat(tempStr, sheet_names3(i,:));
    iterator_1 = i;
    iterator_2 = num_exp+i;
    iterator_3 = 2*num_exp+i;
    [m_arr(i,1), c_arr(i,1), n_arr(i,1), rss_struct.(tempStr1)] = cse824_genmodel(distances(i),rssi_raw_cell{iterator_1}, distances(i+1), rssi_raw_cell{iterator_1+1});
    [m_arr(i,2), c_arr(i,2), n_arr(i,2), rss_struct.(tempStr2)] = cse824_genmodel(distances(i),rssi_raw_cell{iterator_2}, distances(i+1), rssi_raw_cell{iterator_2+1});    
    [m_arr(i,3), c_arr(i,3), n_arr(i,3), rss_struct.(tempStr3)] = cse824_genmodel(distances(i),rssi_raw_cell{iterator_3}, distances(i+1), rssi_raw_cell{iterator_3+1});    
    if i==(num_exp-1)
        tempStr = 'RSS';
        tempStr1 = strcat(tempStr, sheet_names1(i+1,:));
        tempStr2 = strcat(tempStr, sheet_names2(i+1,:));
        tempStr3 = strcat(tempStr, sheet_names3(i+1,:));
        [ ~, ~, ~, rss_struct.(tempStr1)] = cse824_genmodel(distances(i+1),rssi_raw_cell{iterator_1+1}, distances(i), rssi_raw_cell{iterator_1});
        [ ~, ~, ~, rss_struct.(tempStr2)] = cse824_genmodel(distances(i+1),rssi_raw_cell{iterator_2+1}, distances(i), rssi_raw_cell{iterator_2});
        [ ~, ~, ~, rss_struct.(tempStr3)] = cse824_genmodel(distances(i+1),rssi_raw_cell{iterator_3+1}, distances(i), rssi_raw_cell{iterator_3});
        
    end
end

%average params, iterated
m_itr = mean(m_arr);
c_itr = mean(c_arr);
n_itr = mean(n_arr);

% %dummy for jesse only
% m_itr = -9.137;
% c_arr = -98.44;


%convert to cell for ease of use
rss_cell = struct2cell(rss_struct);
dist_cell = struct;
dist_cell = struct2cell(dist_cell);
%% 
% Distance = 10^((RSS-C)/(-m))
ctemp=-36.5435;
mtemp=24.0188;
mtemp=20.8225;
ctemp=-32.8303;

for i=1:num_exp
   
   iterator_1 = i;
   iterator_2 = num_exp+i;
   iterator_3 = 2*num_exp+i;
   temp_rss1=rss_cell{iterator_1};
   temp_rss2=rss_cell{iterator_2};
   temp_rss3=rss_cell{iterator_3};
   %calc the estimated distance
   Distance1 = 10.^((temp_rss1-ctemp)/(-mtemp));
   dist_cell{iterator_1} = Distance1;
   Distance2 = 10.^((temp_rss2-ctemp)/(-mtemp));
   dist_cell{iterator_2} = Distance2;
   Distance3 = 10.^((temp_rss3-ctemp)/(-mtemp));
   dist_cell{iterator_3} = Distance3;
   
   %get the real distance from the true distance matrix
   real_Distance1 = linspace(distances(i), distances(i), length(temp_rss1));
   real_Distance1 = real_Distance1';
   real_Distance2 = linspace(distances(i), distances(i), length(temp_rss2));
   real_Distance2 = real_Distance2';
   real_Distance3 = linspace(distances(i), distances(i), length(temp_rss3));
   real_Distance3 = real_Distance3';
  % error(i,:)=real_Distance - Distance;
   mean_dist1(i) = mean(Distance1);
   mean_dist2(i) = mean(Distance2);
   mean_dist3(i) = mean(Distance3);
   
   mean_error1(i) = mean(real_Distance1 - Distance1);
   mean_error2(i) = mean(real_Distance2 - Distance2);
   mean_error3(i) = mean(real_Distance3 - Distance3);
   
%    figure;
%    hold on;
%    plot(temp_rss1, 'r');
%    plot(temp_rss2, 'b');
%    plot(temp_rss3, 'k');
%    title([sheet_names1(i, :)], 'Interpreter', 'none')
%    legend('1', '2', '3');
%    axis([0 30 -60 0]);
%    xlabel('Fake Time');
%    ylabel('RSSI');
%    hold off;
  
%    figure;
%    hold on;
%    plot(temp_rss2, 'r');
%    title([sheet_names2(i, :)], 'Interpreter', 'none')
%    xlabel('Fake Time');
%    ylabel('Distance (ft)');
%    hold off;
%    
%    figure;
%    hold on;
%    plot(temp_rss3, 'r');
%    title([sheet_names3(i, :)], 'Interpreter', 'none')
%    xlabel('Fake Time');
%    ylabel('Distance (ft)');
%    hold off;
   

   figure;
   hold on;
   plot(real_Distance1, 'k');
   plot(Distance1, 'r');
   plot(Distance2, 'b');
   plot(Distance3, 'g');
   title(['Mean Error1: ', num2str(mean_error1(i)), ' Mean Error2: ', num2str(mean_error2(i)) , ' Mean Error3: ', num2str(mean_error3(i)) ], 'Interpreter', 'none')
   legend('Real', 'Node 1', 'Node 2', 'Node 3');
   axis([0 30 0 10]);
   xlabel('Fake Time');
   ylabel('Distance (ft)');
   hold off;
   
% 
%    figure;
%    hold on;
%    plot(Distance1, 'r');
%    plot(real_Distance1, 'b');
%    title([sheet_names1(i, :), ' Mean Error: ', mean_error1(i) ], 'Interpreter', 'none')
%    xlabel('Fake Time');
%    ylabel('Distance (ft)');
%    hold off;
%    
%    figure;
%    hold on;
%    plot(Distance2, 'r');
%    plot(real_Distance2, 'b');
%    title([sheet_names2(i, :), ' Mean Error: ', mean_error2(i) ], 'Interpreter', 'none')
%    xlabel('Fake Time');
%    ylabel('Distance (ft)');
%    hold off;
%    
%    figure;
%    hold on;
%    plot(Distance3, 'r');
%    plot(real_Distance3, 'b');
%    title([sheet_names3(i, :), ' Mean Error: ', mean_error3(i) ], 'Interpreter', 'none')
%    xlabel('Fake Time');
%    ylabel('Distance (ft)');
%    hold off;
end


figure; 
hold on; 
plot(distances, mean_error1, distances, mean_error2, distances, mean_error3); 
title('Mean Errors'); 
legend('1', '2', '3'); 
xlabel('Distance (ft)');
ylabel('Error (ft)');
hold off;


fit1=polyfit(mean_error1, distances,1);
fit2=polyfit(mean_error2, distances,1);
fit3=polyfit(mean_error3, distances,1);


fit1=polyfit(mean_dist1, distances,1);
fit2=polyfit(mean_dist2, distances,1);
fit3=polyfit(mean_dist3, distances,1);



for i=1:num_exp
   iterator_1 = i;
   iterator_2 = num_exp+i;
   iterator_3 = 2*num_exp+i;
    
   distfit1 = polyval(fit1, dist_cell{iterator_1});
   distfit2 = polyval(fit2, dist_cell{iterator_1});
   distfit3 = polyval(fit3, dist_cell{iterator_1});
   real_Distance1 = linspace(distances(i), distances(i), length(dist_cell{iterator_1}));
   real_Distance1 = real_Distance1';
   real_Distance2 = linspace(distances(i), distances(i), length(dist_cell{iterator_2}));
   real_Distance2 = real_Distance2';
   real_Distance3 = linspace(distances(i), distances(i), length(dist_cell{iterator_3}));
   real_Distance3 = real_Distance3';

   figure;
   hold on;
   plot(real_Distance1, 'k');
   plot(distfit1, 'r');
   plot(distfit2, 'b');
   plot(distfit3, 'g');
   title(['Distance Fits, Dist: ', num2str(distances(i)) ], 'Interpreter', 'none')
   legend('Real', 'Node 1', 'Node 2', 'Node 3');
   axis([0 30 0 10]);
   xlabel('Fake Time');
   ylabel('Distance (ft)');
   hold off;
   
end





   figure;
   hold on;
   plot(real_Distance1, 'k');
   plot(Distance1, 'r');
   plot(Distance2, 'b');
   plot(Distance3, 'g');
   title(['Mean Error1: ', num2str(mean_error1(i)), ' Mean Error2: ', num2str(mean_error2(i)) , ' Mean Error3: ', num2str(mean_error3(i)) ], 'Interpreter', 'none')
   legend('Real', 'Node 1', 'Node 2', 'Node 3');
   axis([0 30 0 10]);
   xlabel('Fake Time');
   ylabel('Distance (ft)');
   hold off;

   
   figure;
   hold on;
   plot(real_Distance1, 'k');
   plot(distfit1, 'r');
   plot(distfit2, 'b');
   plot(distfit3, 'g');
   title('Distance Fits', 'Interpreter', 'none')
   legend('Real', 'Node 1', 'Node 2', 'Node 3');
   axis([0 30 0 10]);
   xlabel('Fake Time');
   ylabel('Distance (ft)');
   hold off;
   
figure;
hold on;
plot(distfit1);
hold off;

figure;
hold on;
plot(rss_cell{1});
plot(rss_cell{2});
plot(rss_cell{3});
plot(rss_cell{4});
plot(rss_cell{5});
title('Node 1 All Data')
legend('1ft', '3ft', '4ft', '6ft', '7ft');
axis([0 30 -60 -40]);
xlabel('Fake Time');
ylabel('RSSI');
hold off;

figure;
hold on;
plot(distances, [mean(rss_cell{1}) mean(rss_cell{2}) mean(rss_cell{3}) mean(rss_cell{4}) mean(rss_cell{5})],'+');
title('Node 1 Mean RSSI vs Dist Data')
axis([0 8 -60 -40]);
xlabel('Distance (ft)');
ylabel('RSSI');
hold off;

mean_ttl1=mean(ttl_raw1);
mean_ttl2=mean(ttl_raw2);
mean_ttl3=mean(ttl_raw3);

power_watts=(10^(ttl_raw1(1,1)/10))/1000;
figure;
hold on;
plot(distances, [mean(ttl_raw1(:,1)) mean(ttl_raw1(:,2)) mean(ttl_raw1(:,3)) mean(ttl_raw1(:,4)) mean(ttl_raw1(:,5))],'+');
title('Node 1 Mean TPL vs Dist Data')
xlabel('Distance (ft)');
ylabel('dBm');
hold off;


figure;
hold on;
plot(rss_cell{6});
plot(rss_cell{7});
plot(rss_cell{8});
plot(rss_cell{9});
plot(rss_cell{10});
title('Node 2 All Data')
legend('1ft', '3ft', '4ft', '6ft', '7ft');
axis([0 30 -60 -40]);
xlabel('Fake Time');
ylabel('RSSI');
hold off;

figure;
hold on;
plot(distances, [mean(rss_cell{6}) mean(rss_cell{7}) mean(rss_cell{8}) mean(rss_cell{9}) mean(rss_cell{10})],'+');
title('Node 2 Mean RSSI vs Dist Data')
axis([0 8 -60 -40]);
xlabel('Distance (ft)');
ylabel('RSSI');
hold off;


figure;
hold on;
plot(distances, mean_ttl2, '+');
title('Node 2 Mean TPL vs Dist Data')
xlabel('Distance (ft)');
ylabel('dBm');
hold off;

figure;
hold on;
plot(rss_cell{11});
plot(rss_cell{12});
plot(rss_cell{13});
plot(rss_cell{14});
plot(rss_cell{15});
title('Node 3 All Data')
legend('1ft', '3ft', '4ft', '6ft', '7ft');
axis([0 30 -60 -40]);
xlabel('Fake Time');
ylabel('RSSI');
hold off;

figure;
hold on;
plot(distances, [mean(rss_cell{11}) mean(rss_cell{12}) mean(rss_cell{13}) mean(rss_cell{14}) mean(rss_cell{15})],'+');
title('Node 3 Mean RSSI vs Dist Data')
axis([0 8 -60 -40]);
xlabel('Distance (ft)');
ylabel('RSSI');
hold off;


figure;
hold on;
plot(distances, mean_ttl3, '+');
title('Node 3 Mean TPL vs Dist Data')
xlabel('Distance (ft)');
ylabel('dBm');
hold off;

%%

% %% generate localization model
% %define filenames for import
% filename1='rssi_cal1.csv';
% filename2='rssi_cal3.csv';
% filename3='rssi_cal4.csv';
% filename4='rssi_cal6.csv';
% filename5='rssi_cal8.csv';
% 
% filenames = [filename1; filename2; filename3; filename4; filename5];
% 
% % %dummy for jesse use only
% % filenames = ['rssi_sub1.csv'; 'rssi_subN.csv'; 'rssi_ova1.csv'; 'rssi_ovaN.csv'];
% % distances = [3 3 6 6];
% 
% %init the struct
% rss_struct = struct;
% %loop through files to get fit params for each
% for i=1:size(filenames,1)-1
%     %create variables to label the rssi struct correctly
%     tempStr = 'RSS';
%     tempNum = num2str(i);
%     tempStr = strcat(tempStr, tempNum);
%     [m_arr(i), c_arr(i), n_arr(i), rss_struct.(tempStr)] = cse824_genmodel(distances(i),sheet_names1(i,:), distances(i+1), sheet_names1(i+1,:));    
% end
% %read and add the last rssi data file to the struct
% rssi_data1=csvread(filenames(size(filenames,1),:));
% tempStr = 'RSS';
% tempNum = num2str(size(filenames,1));
% tempStr = strcat(tempStr, tempNum);
% rss_struct.(tempStr)=rssi_data1;
% 
% %average params, iterated
% m_itr = mean(m_arr);
% c_itr = mean(c_arr);
% n_itr = mean(n_arr);
% 
% % %dummy for jesse only
% % m_itr = -9.137;
% % c_arr = -98.44;
% 
% 
% %convert to cell for ease of use
% rss_cell = struct2cell(rss_struct);
% % Distance = 10^((RSS-C)/(-m))
% 
% for i=1:size(filenames,1)
%    
%    temp_rss=rss_cell{i} ;
%    %calc the estimated distance
%    Distance = 10.^((temp_rss-c_itr)/(-m_itr));
%    %get the real distance from the true distance matrix
%    real_Distance = linspace(distances(i), distances(i), length(temp_rss));
%    real_Distance = real_Distance';
%   % error(i,:)=real_Distance - Distance;
%    mean_error(i) = mean(real_Distance - Distance);
%    figure;
%    hold on;
%    plot(Distance, 'r');
%    plot(real_Distance, 'b');
%    title([filenames(i, :), ' Mean Error: ', mean_error ])
%    xlabel('Fake Time');
%    ylabel('Distance (ft)');
%    hold off;
%    
% end


% 
% %single shot/manual, get fit params
% [mA, cA, nA] = cse824_genmodel(dist1,filename1, dist2, filename2);
% [mB, cB, nB] = cse824_genmodel(dist2,filename2, dist3, filename3);
% [mC, cC, nC] = cse824_genmodel(dist1,filename1, dist3, filename3);
% %average params, manual
% m=mean([mA mB mC]);
% c=mean([cA cB cC]);
% n=mean([nA nB nC]);
