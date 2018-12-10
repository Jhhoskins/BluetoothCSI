function [ refPoints, errorRate ] = cse824_trilateration(dist)
%%

refPoints = [];  
errorRate = [0 0 0];
    %x and y coords of the three beacons in ft.
    %ble1(jbl)
%     ble1 = [2.875 0 0]';
%     %ble2(minijacket)
%     ble2 = [-2.125 -2.20833 0]';
%     %ble3(tao)
%     ble3 = [-2.125 2.20833 0]';
%     
    ble1 = [2.875 0 0]';
    %ble2(minijacket)
    ble2 = [-2.125 -2.20833 0]';
    %ble3(tao)
    ble3 = [-2.125 2.20833 0]';
    
    
    for i=1:length(dist.Distance1)
        da = dist.Distance1(i,1)
        db = dist.Distance2(i,1)
        dc = dist.Distance3(i,1)

        P = [ble1 ble2 ble3];
        S = [da db dc];
        A = []; b = [];
        
        %setup alpha and beta coefficients
        for beaconIdx=1:3
            x = P(1,beaconIdx); y = P(2,beaconIdx); z = P(3,beaconIdx);
            s = S(beaconIdx);
            A = [A ; 1 -2*x  -2*y  -2*z]; 
            b = [b ; s^2-x^2-y^2-z^2 ];
        end


        %setup polynomial coefficients 
        warning off;
        Xp= A\b; 

        xp = Xp(2:4,:);
        Z = null(A,'r');
        z = Z(2:4,:);

        a2 = z(1)^2 + z(2)^2 + z(3)^2 ;
        a1 = 2*(z(1)*xp(1) + z(2)*xp(2) + z(3)*xp(3))-Z(1);
        a0 = xp(1)^2 +  xp(2)^2+  xp(3)^2-Xp(1);
        p = [a2 a1 a0];
        t = roots(p);

        %store s1
        s1 = Xp + t(1)*Z;
        s1 = s1(2:4,1);
        refPoints = [refPoints; s1'];
         
        %calculate errorRate based on distance
        distanceToSolution = [norm(ble1 - s1) norm(ble2 - s1) norm(ble3 - s1)];        
        errorRate = errorRate + ([da db dc] - distanceToSolution);

    end
    errorRate = errorRate/length(dist.Distance1);
end