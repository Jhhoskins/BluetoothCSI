function [m, c, n, rss_data1] = cse824_genmodel(dist1,filename1, dist2, filename2)

%rssi offset value to convert rssi to rss
offset = -45;
%read rssi data. Assuming just 1 column, all csv, all doubles
rssi_data1=csvread(filename1);
rssi_data2=csvread(filename2);
%convert to rss, assumes rssi1 and rssi2 have same bluetooth chip
rss_data1=rssi_data1+offset;
rss_data2=rssi_data2+offset;
% potentially apply a filter here, see if it improves
%take mean of data
rss1 = mean(rss_data1);
rss2 = mean(rss_data2);
%calc coefficients for first order linear fit
m = (rss1-rss2)/log10(dist2/dist1);
c = rss1+m*log10(dist1);
%path loss factor
n=m/10;

end

