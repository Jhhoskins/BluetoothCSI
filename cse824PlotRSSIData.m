function [RSSIStats] = cse824PlotRSSIData(Mixed, k, Dataset)
%Mixed is RSSI Data
%K is the number of locations that have the most RSSI observations
%Dataset indicates if the data is from the iBeacon set or our own

if Dataset==1
    %sort the full matrix
    Mixed=sortrows(Mixed,1);
    %Create matrix to report stats
    RSSIStats=zeros(k,2);
    %create a matrix of just RSSI readings
    JustRSSI=table2array(Mixed(:,2:end));

    %find index of location of interest
    % get a table of just the locations
    JustLocations=Mixed(:,1);
    % get a cell array of just the locations
    JustLocations=table2array(JustLocations);
    % find the index of the location of interest, get unique locations
    [uniquesubcell, ~, J]=unique(JustLocations); 
    %count occurences of each location
    occ = histc(J, 1:numel(uniquesubcell));
    %find the top K values
    %k = 10;
    %find the index of the K locations that have the most RSSI observations
    [~, I]=maxk(occ, k);
    %this loop iterates through the data and finds and plots the RSSI data from
    %the locations that have the most values. It plots K different locations
    %and only plots the beacon with the most valid RSSI values per location
    for j=1:k
        %cell of the location name for this loop
        tempval=uniquesubcell(I(j));
        %find all indices of selected location
        d13idx=find(strcmp(JustLocations, tempval));

        %select the subset of rssi values that correspond with the location of
        %interest
        RSSILOI=JustRSSI(d13idx, :);
        minval = 100;
        %iterate through and find the beacon with the least number of bad RSSI
        %values (-200 represents bad values)
        for i=1:size(RSSILOI,2)
            %count how many bad values in a row
            tempmin=sum(RSSILOI(:,i)==-200);
            %if min is less than previous, record it
            if tempmin < minval
                minval=tempmin;
                idx = i;
            end
        end
        %subset of rssi values for only the beacon with most valid values
        RSSI=RSSILOI(:, idx);
        %delete any invalid values
        RSSI(RSSI==-200)=[];
        RSSIStats(j,1) = std(RSSI);
        RSSIStats(j,2) = mean(RSSI);
        %Beacon1 = BR(:,1);
        %Beacon1(Beacon1==-200)=[];
        %generate some fake X values, since we threw out time
        FakeTime = linspace(0, 100, size(RSSI,1));
        %FakeTime = linspace(0, 100, size(Beacon1,1));

        %Plot signal
        figure;
        hold on
        plot(FakeTime, RSSI, 'r+');
        %plot(FakeTime, Beacon1, 'r+');
        title(sprintf('Graph of location: %s with beacon: b30%d', string(tempval), idx));
        xlabel('Time');
        ylabel('RSSI Mag');
        hold off
    end
elseif Dataset==2
    Display('Training data invalid, good try');
end
end

