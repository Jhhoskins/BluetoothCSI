function [ Distance, ex1_node1, ex1_node2, ex1_node3, real_time ] = cse824_calc_distance(ex1_rssi, ex1_ttl, ex1_dev , ex1_time, mtemp, ctemp)

%extract time info from excel and transform into something useful
time= datestr(ex1_time, 'HH:MM:SS');
time = datetime(time);
[h, m, s] = hms(time);
minutes=(m-m(1))*60;
seconds = s-s(1);
real_time = minutes+seconds;


ex1 = [ex1_rssi ex1_ttl ex1_dev real_time ];
ex1_node1 = ex1(ex1(:,3)==1 , :);
ex1_node2 = ex1(ex1(:,3)==2 , :);
ex1_node3 = ex1(ex1(:,3)==3 , :);
%adjust for ttl 
rssi_adj_node1 = adjust_rssi(ex1_node1(:,1), ex1_node1(:,2), 1, 1,1);
rssi_adj_node2 = adjust_rssi(ex1_node2(:,1), ex1_node2(:,2), 2, 1,1);
rssi_adj_node3 = adjust_rssi(ex1_node3(:,1), ex1_node3(:,2), 3, 1,1);

%apply distance caluclation
Distance1 = 10.^((rssi_adj_node1-ctemp)/(-mtemp));
Distance2 = 10.^((rssi_adj_node2-ctemp)/(-mtemp));
Distance3 = 10.^((rssi_adj_node3-ctemp)/(-mtemp));

Distance = struct;
Distance.('Distance1') = Distance1;
Distance.('Distance2') = Distance2;
Distance.('Distance3') = Distance3;

figure;
hold on;
plot(ex1_node1(:,4), Distance1)
title('Node 1 Position');
xlabel('Time(seconds)');
ylabel('Distance (ft');
hold off;

figure;
hold on;
plot(ex1_node2(:,4), Distance2)
title('Node 2 Position');
xlabel('Time(seconds)');
ylabel('Distance (ft');
hold off;

figure;
hold on;
plot(ex1_node3(:,4), Distance3)
title('Node 3 Position');
xlabel('Time(seconds)');
ylabel('Distance (ft');
hold off;

figure;
hold on;
plot(ex1_node1(:,4), Distance1)
plot(ex1_node2(:,4), Distance2)
plot(ex1_node3(:,4), Distance3)
title('All Node Position');
xlabel('Time(seconds)');
ylabel('Distance (ft');
legend('Node 1', 'Node 2', 'Node 3');
hold off;

end

