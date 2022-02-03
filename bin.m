function [bin_1hr_patient, bin_30min_patient, bin_1min_patient,...
    bin_1hr_control, bin_30min_control, bin_1min_control] = bin (X, Y)

validateattributes(X,{'table'},{'ncols',12})
validateattributes(Y,{'table'},{'ncols',12})

%%% OUTPUT: graphs (and timetables) of averaged activity and light exposure 
%%%         across days binned per hour, 30 minutes and 1 minute.
%%%
%%% INPUTS:
%%% X: loaded actigraphy raw file from chronic insomnia.
%%% Y: loaded actigraphy raw file from healthy bed partner.
%%% Both tables should include Line, Date, Time, DateTime, Activity
%%% and IntervalStatus.
%%% Line (double) is row # starting with 1.
%%% Activity (double) is the actigraphy raw movement count.
%%% IntervalStatus is the ACTIVE, REST, REST-S designation from the
%%%                 actigraph software.
%%% Date, Time and Datetime are in datetime format.

% START

% format X table

X.Time = datestr(X.Time,'HH:MM');
X.Time = datetime(X.Time,'Format','HH:mm');                                                              
X.Date.Format = 'dd.MM.uuuu HH:mm';
X.Time.Format = 'dd.MM.uuuu HH:mm';
X.Datetime = X.Date + timeofday(X.Time);                 % added field for plotting

WhiteLight = str2double(X.WhiteLight);
RedLight = str2double(X.RedLight);
GreenLight = str2double(X.GreenLight);
BlueLight = str2double(X.BlueLight);
X.WhiteLight = WhiteLight;
X.RedLight = RedLight;
X.GreenLight = GreenLight;
X.BlueLight = BlueLight;

% format Y table

Y.Time = datestr(Y.Time,'HH:MM');
Y.Time = datetime(Y.Time,'Format','HH:mm');
Y.Date.Format = 'dd.MM.uuuu HH:mm';
Y.Time.Format = 'dd.MM.uuuu HH:mm';
Y.Datetime = Y.Date + timeofday(Y.Time);                  % added field for plotting

WhiteLight = str2double(Y.WhiteLight);
RedLight = str2double(Y.RedLight);
GreenLight = str2double(Y.GreenLight);
BlueLight = str2double(Y.BlueLight);
Y.WhiteLight = WhiteLight;
Y.RedLight = RedLight;
Y.GreenLight = GreenLight;
Y.BlueLight = BlueLight;

% binning act and light exp - 1hr, 30min, 1min 

% X 

bins = table2timetable(X(:,[3:10 13]));
bins(:, [1 3 8]) = [];
bin_1hr_patient = retime(bins,'hourly','mean');
dt = minutes(30);
bin_30min_patient = retime(bins,'regular','TimeStep',dt);
bin_1min_patient = retime(bins,'minutely','mean');

% Y 

bins2 = table2timetable(Y(:,[3:10 13]));
bins2(:, [1 3 8]) = [];
bin_1hr_control = retime(bins2,'hourly','mean');
dt = minutes(30);
bin_30min_control = retime(bins2,'regular','TimeStep',dt);
bin_1min_control = retime(bins2,'minutely','mean');

% plot X and Y values binned (1hr, 30min, 1min)

tt_X = timetable2table((bin_1hr_patient));
tt_Y = timetable2table((bin_1hr_control));

figure;
subplot(5,1,1)
x = tt_Y.Time;
plot(x,tt_X.Activity,'r');
hold on;
plot(x,tt_Y.Activity,'b');
legend('Insomnia','Healthy Control','Location','NW')
ylabel('Activity');
datetick('x', 'HH:MM','keepticks');
title('Hourly Average Activity and Light Exposure','FontSize',15);

subplot(5,1,2)
x = tt_Y.Time;
plot(x,tt_X.WhiteLight,'r');
hold on;
plot(x,tt_Y.WhiteLight,'b');
ylabel('White (lux)');
datetick('x', 'HH:MM','keepticks');

subplot(5,1,3)
x = tt_Y.Time;
plot(x,tt_X.RedLight,'r');
hold on;
plot(x,tt_Y.RedLight,'b');
ylabel('Red (lux)');
datetick('x', 'HH:MM','keepticks');

subplot(5,1,4)
x = tt_Y.Time;
plot(x,tt_X.GreenLight,'r');
hold on;
plot(x,tt_Y.GreenLight,'b');
ylabel('Green (lux)');
datetick('x', 'HH:MM','keepticks');

subplot(5,1,5)
x = tt_Y.Time;
plot(x,tt_X.BlueLight,'r');
hold on;
plot(x,tt_Y.BlueLight,'b');
ylabel('Blue (lux)');
datetick('x', 'HH:MM','keepticks');
hold off;

tt_X = timetable2table((bin_30min_patient));
tt_Y = timetable2table((bin_30min_control));

figure;
subplot(5,1,1)
x = tt_Y.Time;
plot(x,tt_X.Activity,'r');
hold on;
plot(x,tt_Y.Activity,'b');
legend('Insomnia','Healthy Control','Location','NW')
ylabel('Activity');
datetick('x', 'HH:MM','keepticks');
title('Half-hour Average Activity and Light Exposure','FontSize',15);

subplot(5,1,2)
x = tt_Y.Time;
plot(x,tt_X.WhiteLight,'r');
hold on;
plot(x,tt_Y.WhiteLight,'b');
ylabel('White (lux)');
datetick('x', 'HH:MM','keepticks');

subplot(5,1,3)
x = tt_Y.Time;
plot(x,tt_X.RedLight,'r');
hold on;
plot(x,tt_Y.RedLight,'b');
ylabel('Red (lux)');
datetick('x', 'HH:MM','keepticks');

subplot(5,1,4)
x = tt_Y.Time;
plot(x,tt_X.GreenLight,'r');
hold on;
plot(x,tt_Y.GreenLight,'b');
ylabel('Green (lux)');
datetick('x', 'HH:MM','keepticks');

subplot(5,1,5)
x = tt_Y.Time;
plot(x,tt_X.BlueLight,'r');
hold on;
plot(x,tt_Y.BlueLight,'b');
ylabel('Blue (lux)');
datetick('x', 'HH:MM','keepticks');
hold off;

tt_X = timetable2table((bin_1min_patient));
tt_Y = timetable2table((bin_1min_control));

figure;
subplot(5,1,1)
x = tt_Y.Time;
plot(x,tt_X.Activity,'r');
hold on;
plot(x,tt_Y.Activity,'b');
legend('Insomnia','Healthy Control','Location','NW')
ylabel('Activity');
datetick('x', 'HH:MM','keepticks');
title('Per Minute Average Activity and Light Exposure','FontSize',15);

subplot(5,1,2)
x = tt_Y.Time;
plot(x,tt_X.WhiteLight,'r');
hold on;
plot(x,tt_Y.WhiteLight,'b');
ylabel('White (lux)');
datetick('x', 'HH:MM','keepticks');

subplot(5,1,3)
x = tt_Y.Time;
plot(x,tt_X.RedLight,'r');
hold on;
plot(x,tt_Y.RedLight,'b');
ylabel('Red (lux)');
datetick('x', 'HH:MM','keepticks');

subplot(5,1,4)
x = tt_Y.Time;
plot(x,tt_X.GreenLight,'r');
hold on;
plot(x,tt_Y.GreenLight,'b');
ylabel('Green (lux)');
datetick('x', 'HH:MM','keepticks');

subplot(5,1,5)
x = tt_Y.Time;
plot(x,tt_X.BlueLight,'r');
hold on;
plot(x,tt_Y.BlueLight,'b');
ylabel('Blue (lux)');
datetick('x', 'HH:MM','keepticks');
hold off;

end 

% END