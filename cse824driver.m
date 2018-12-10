%cse824 Driver - Applies calibration and calls the trilateration

% Add the sheet names you want and lets go
%note, you have to manually swap out the mac addresses in the spreadsheet
%to a coresponding 1, 2, 3. Other than that, this should be plug and play.
%You need this file, cse824_calc_distance.m, cse824_trilateration.m and adjust_rssi.m

%this file reads in experiment data as specified by the "filename" and
%sheet_names variables. It then runs through the previously generated
%signal strength model to turn the rssi/tpl measurements from each node
%into distance calculations. It then calls the trilateration function and
%outputs the results. Plots of the node distances over time are outputed.
%Note that the "actual" values are generated manually and artificially
%smoothed to account for operator movement. We realize this introduces
%potential error into the solution and it is listed in the future work
sheet_names= ['EX1'; 'EX2'; 'EX3'; 'EX4']; 
filename = 'Datasets_Network';
rssi_col = 'P:P';
ttl_col='H:H';
dev_col = 'E:E';
time_col = 'B:B';
%change the sheet_names(1,:) to try a different experiments
ex1_rssi = xlsread(filename, sheet_names(4,:), rssi_col);
ex1_ttl = xlsread(filename, sheet_names(4,:), ttl_col);
ex1_dev = xlsread(filename, sheet_names(4,:), dev_col);
ex1_time = xlsread(filename, sheet_names(4,:), time_col);

%hardcoded. Provided from the signal strength model
mtemp=25.3540;
ctemp=-33.3031;

%Distance struct is it, this is the calculated distance for each time
%reading per sensor
[Distance_struct, ex1_node1, ex1_node2, ex1_node3, real_time] = cse824_calc_distance(ex1_rssi, ex1_ttl, ex1_dev , ex1_time, mtemp, ctemp);



%% This section generates the "true" position as outlined in the excel sheet
%hardcoded number of seconds that we need to generate data for
data_elements = 70;
real_time = xlsread(filename, 'Path', 'D:D');
real_time = real_time(1:data_elements,1);
ex1_coordinates_x = zeros(data_elements,1);
ex1_coordinates_y = zeros(data_elements,1);
ex1_coordinates_y(real_time<=10)=6;
ex1_coordinates_x((real_time>=11)&(real_time<=20))=1;
ex1_coordinates_y((real_time>=11)&(real_time<=20))=6;
ex1_coordinates_x((real_time>=21)&(real_time<=30))=1;
ex1_coordinates_y((real_time>=21)&(real_time<=30))=5;
ex1_coordinates_x((real_time>=31)&(real_time<=40))=0;
ex1_coordinates_y((real_time>=31)&(real_time<=40))=5;
ex1_coordinates_x((real_time>=41)&(real_time<=50))=-1;
ex1_coordinates_y((real_time>=41)&(real_time<=50))=3;
ex1_coordinates_x((real_time>=51)&(real_time<=60))=0;
ex1_coordinates_y((real_time>=51)&(real_time<=60))=3;

windowSize = 5; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
xcoordf = filter(b,a,ex1_coordinates_x);
ycoordf = filter(b,a,ex1_coordinates_y);

figure;
hold on;
plot(real_time, ex1_coordinates_x)
plot(real_time, xcoordf)
title( 'X Coord True');
xlabel('Time (seconds)');
ylabel('X Coor');
hold off

figure;
hold on;
plot(real_time, ex1_coordinates_y)
plot(real_time, ycoordf)
title( 'Y Coord True');
xlabel('Time (seconds)');
ylabel('Y Coor');
hold off


%calculate estimated x,y,z
[est_region, errorRate] = cse824_trilateration(Distance_struct)
disp('ErrorRate');
disp(errorRate);
%%

x = est_region(1:data_elements,1);
y = est_region(1:data_elements, 2);
z = est_region(1:data_elements, 3);
scatter3(x,y,z)
hold on
x_cord = xcoordf(1:data_elements,1);
y_cord = zeros(data_elements, 1);
z_cord = ycoordf(1:data_elements,1);


view(-30,10)
%apply error correction
x_cord(:,1) = x_cord(:,1) - 6;

y_cord(:,1) = y_cord(:,1) + 3.5;

%calculate expirement error
disp('X Abs error')
disp(abs(mean(x_cord - est_region(:,1))));
disp('Y Abs error')
disp(abs(mean(y_cord - est_region(:,2))));
disp('Z Abs error')
disp(abs(mean(z_cord - est_region(:,3))));
