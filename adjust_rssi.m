function [ rssi_adj ] = adjust_rssi(rssi, ttl, nodeID, i, distances)
%hardcoded offset, this was determined iteratively/experimentally
m=.6;
rssi_adj=-m*mean(ttl)+rssi;

% %Uncomment code below to plot adjusted rssi figures (gets annoying in
% %testing but useful for visualization
% figure;
% hold on;
% plot(rssi)
% plot(rssi_adj);
% title(['RSSI Node', num2str(nodeID)]);%, ' ', num2str(distances(i)), 'ft']);
% legend('Old', 'New');
% xlabel('Time');
% ylabel('dBm');

end

