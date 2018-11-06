function [rssi_data] = cse824_DataPreprocess(filename, g_type)
rssi_data=csvread(filename);

std_rssi = std(rssi_data);
mean_rssi = mean(rssi_data);

rssi_data(rssi_data<(mean_rssi-abs(2*std_rssi)))=[];
rssi_data(rssi_data>(mean_rssi+abs(2*std_rssi)))=[];
rssi_data=rssi_data./abs(mean_rssi);
mean(rssi_data)
%rssi_data=rssi_data+abs(mean_rssi);
%rssi_data=rssi_data+abs(min(rssi_data));
rssi_data=rssi_data./abs(min(rssi_data));
rssi_data=rssi_data+1;
%rssi_data=rssi_data./abs(mean_rssi);
time = linspace(0, 50, length(rssi_data));

figure
hold on
plot(time, rssi_data, g_type)
xlabel('Time');
ylabel('RSSI Mag');
title(sprintf('RSSI from %s', string(filename)), 'Interpreter', 'none');
hold off

end
