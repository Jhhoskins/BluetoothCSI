function [ rssi_adj ] = adjust_rssi(rssi, ttl, nodeID, i, distances)
m=.6;
rssi_adj=-m*mean(ttl)+rssi;
figure;
hold on;
plot(rssi)
plot(rssi_adj);
title(['RSSI Node', num2str(nodeID)]);%, ' ', num2str(distances(i)), 'ft']);
legend('Old', 'New');
xlabel('Time');
ylabel('dBm');

end

