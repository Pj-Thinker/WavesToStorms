clear,clc
% Reading the demo.csv file
% The “readtable” function automatically detects the header and the
% number of lines to skip.
%ds = readtable('demoRefine.csv');

% Alternatively, you can specify the number of lines to skip using:
T = readtable('demo.csv', 'HeaderLines',23);

% Deleting the unwanted columns from table
% starting from the last column (21) backward to the desired column 
for i = 21:-1:9;
    T(:, i) = [];
end

% We also don't need the 6'th and 5'th columns
% The order in which we delete the columns is important!
% Since by removing any columns the columns from right will shift to
% the left.
T(:, 6) = [];
T(:, 5) = [];

% Converting Table to Matrix for convenient
T = T{:,:};

figure(1)
scatter( T(:,6), T(:,5), 1 )
title('Wave height vs direction for all waves')
xlabel('Wave direction [degN]') 
ylabel('Wave height, H_s [m]') 

% Quantity of the whole observations
L = length(T);
% each 8 rows correspond to a day. Therefore, each 24 rows correspond to
% 3 days (D)
D = 24;
% L/D : Divides the whole data into groups of 3days

temp = zeros(D,1);
wHeightPeaks = zeros(2800,5); % Wave height Peaks filter

for p = 1 : L/D
    for j=1:D   
        temp(j) = T((p-1)*D + j , 5); % Getting Hs from each D time
        % Note that the time between some peaks may be less than 3 days!
    end
    [wHeightPeaks(p,5), i] = max(temp);
    wHeightPeaks(p,1) = T((p-1)*D +i, 1);
    wHeightPeaks(p,2) = T((p-1)*D +i, 2);
    wHeightPeaks(p,3) = T((p-1)*D +i, 3);
    wHeightPeaks(p,4) = T((p-1)*D +i, 4);
    wHeightPeaks(p,6) = T((p-1)*D +i, 6);
end

% Store consists of time periods with higest wave heights
% Now we consider the heights above threshold and the wind direction
% above 150
Ls = length(wHeightPeaks);
Hss = zeros(Ls,6); % Wave Height of storms
j=1;

for i = 1 : Ls
    if wHeightPeaks(i,5) > 7.5 && wHeightPeaks(i,6) > 150 && wHeightPeaks(i,6) < 300
        Hss(j,6)=wHeightPeaks(i,6);
        Hss(j,5)=wHeightPeaks(i,5);
        Hss(j,4)=wHeightPeaks(i,4);
        Hss(j,3)=wHeightPeaks(i,3);
        Hss(j,2)=wHeightPeaks(i,2);
        Hss(j,1)=wHeightPeaks(i,1);
        j=j+1;
    end
end

% Obviously the Hss matrix length is less than the store so we need to
% remove the excesive rows of Hss. (j-1) indicates the last row of
% Target
Hss = Hss( 1:j-1, :);
% There are some storms with less than a day time gap between them
% Which could be considered as a single storm

% Giving proper headers to the columns
% 1- Year  2- Month  3- Day 4- Hour 5- Hs 6- Hsd
header = {'Year', 'Month', 'Day', 'Hour', 'Hs', 'Hsd'};
Table = array2table( Hss, 'VariableNames', header);

% To Get the datetime format
%dates = datetime(T.Year, T.Month, T.Day, T.Hour, 0, 0);
dates = datetime(Table.Year, Table.Month, Table.Day);

% Making a new Table
Table = table (dates, Table.Hour, Table.Hs, Table.Hsd);

% To rename the selected columns we can use
Table.Properties.VariableNames([2 3 4]) = {'Hour' 'Hs' 'Hsd'};

writetable(Table, 'Date_Hs.csv')