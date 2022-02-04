%% STEP 1: Load raw actigraphy data for patient and control
%%% C1045.xls and P1045.xls are the raw file from the actigraph software
%%% where the headers are removed and converted into an xls file using 
%%% comma as delimiter. The space between the column header and the data
%%% was likewise deleted.

clear all
clc

patient = readtable("C1045.xls");
control = readtable("P1045.xls");

%% STEP 2: Plot and test nocturnal actigraphy data (chronic insomina vs control)

[TIB_pat, TIB_con, p, stats] = nocturnal_actigraph(patient, control);      % TIB represents sleep prd;
                                                                           % p & stats non-para test res


%% STEP 3: Average and plot activity and light exposure across days binned per hr, 30m and 1m

[bin_1hr_patient, bin_30min_patient, ... 
    bin_1min_patient, bin_1hr_control,... 
    bin_30min_control, bin_1min_control] = bin (patient, control);

%% STEP 3.1: Validation of bins

% create table (row: averaged activity per bin / col: day)

clear r
clear s
clear day
clear bin_mean
clear ave_bin_mean

m = unique(patient.Date);
m([1 9])=[];
r = 60;                                                                    % # of rows to average (60, 30, 1)
s = 24;                                                                    % # of bins per day (24, 48, 1440)
day=nan(s,7);

for i = 1:length(m)
    a = m(i,1);
    index = patient.Date == a;
    x = patient(index,:);
    for ii = 1:ceil(height(x)/r)
        if ii == 1
            bin_mean(ii,1) = mean(x.Activity(1:r),'omitnan');
        else
            start = ii*r-r+1;
            finish = ii*r;
            bin_mean(ii,1) = mean(x.Activity(start:finish),'omitnan');
        end
    end
    day(:,i) = bin_mean;
end

% create averaged bin activity across days

ave_bin_mean = nan(s,1);

for i = 1:s
    ave_bin_mean(i,1) = mean(day(i,1:7),'omitnan');
end

% plot ave hourly activity across days

figure;
plot(ave_bin_mean)


%% STEP 4: Calculate and plot correlation of activity and light exposure

[Rsq, Rsq_p] = R_acti_wrgb(bin_1hr_patient);                               % input can be any timetable
                                                                           % from STEP 3

%% STEP 5: Determine period of activity and fit data points with double harmonic curve

tau = cosinor(patient.Activity);                                           % input can be patient.Activity

%% END

save MPI-BC.mat

