function [TIB_pat, TIB_con, p, stats] = nocturnal_actigraph (X, Y)

validateattributes(X,{'table'},{'ncols',12})
validateattributes(Y,{'table'},{'ncols',12})

%%% OUTPUT: graph of nocturnal activity of X (red) and Y (blue)
%%%         across sleep periods including sleepstart/end for X
%%%         and Ys to be used to check full sleep period per night.
%%%         This function also includes Wilcoxon Rank-sum Test of the 
%%%         nocturnal activity of X vs Y.
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

% format patient table

X.Time = datestr(X.Time,'HH:MM');
X.Time = datetime(X.Time,'Format','HH:mm');                                                              
X.Date.Format = 'dd.MM.uuuu HH:mm';
X.Time.Format = 'dd.MM.uuuu HH:mm';
X.Datetime = X.Date + timeofday(X.Time);                                    % added field for plotting

% patient: find all sleep periods in full dataset

index = ismember(X.IntervalStatus, 'REST');
index2 = ismember(X.IntervalStatus, 'REST-S');
ind = index|index2;

% patient: get row index of ALL REST & REST-S (all sleep periods in 9.5 days)

x = find(ind);              
evening = X(x,:);

% patient : group sleep periods per night using row index of REST & REST-S
% (i.e. consecutive REST & REST-S)

x2 = diff(evening.Line)==1;                                                 % 1: consecutive numbers
sleepend = find(x2==0);                                                     % 0: break in row number (total 7), i.e. new sleep prd
sleepstart = [1; sleepend(1:end-1,1)+1];
TIB_pat = [evening(sleepstart,13) evening(sleepend,3)];
TIB_pat.Time = timeofday(TIB_pat.Time);

% format control table

Y.Time = datestr(Y.Time,'HH:MM');
Y.Time = datetime(Y.Time,'Format','HH:mm');
Y.Date.Format = 'dd.MM.uuuu HH:mm';
Y.Time.Format = 'dd.MM.uuuu HH:mm';
Y.Datetime = Y.Date + timeofday(Y.Time);                                    % added field for plotting

% control: find all sleep periods in full dataset

index3 = ismember(Y.IntervalStatus, 'REST');
index4 = ismember(Y.IntervalStatus, 'REST-S');
ind2 = index3|index4;

% control: get row index of REST & REST-S

y = find(ind2);              
evening2 = Y(y,:);

% control: group sleep periods per night using row index of REST & REST-S

y2 = diff(evening2.Line)==1;                                                % 1: consecutive numbers
sleepend2 = find(y2==0);                                                    % 0: break in row number (total 7), i.e. new sleep prd
sleepstart2 = [1; sleepend2(1:end-1,1)+1];
TIB_con = [evening2(sleepstart2,13) evening2(sleepend2,3)];
TIB_con.Time = timeofday(TIB_con.Time);

% STATS TESTING

% normality and ranksum test of nocturnal activity insomnia vs Y

% histogram(evening.Activity); % insomnia
% hold on; 
% histogram(evening2.Activity); % healthy control
[p,h,stats]=ranksum(evening.Activity, evening2.Activity);                   %p<0.001

% PLOT ALL DATA FOR BOTH INSOMNIA & CONTROL PER NIGHT IN ONE FIGURE

total_rows = height(TIB_pat);

for i = 1:length(sleepstart)
    if i == 1
        figure;
        subplot(total_rows,1,i);
        a = sleepstart(i);
        b = sleepend(i);
        plot(evening.Datetime(a:b), evening.Activity(a:b),'Color','r');
        hold on;
        c = sleepstart2(i);
        d = sleepend2(i);
        plot(evening2.Datetime(c:d), evening2.Activity(c:d),'Color','b');
        datetick('x',0,'keepticks');
        legend('Insomnia', 'Healthy Control', 'Location', 'NW');
    else
        subplot(total_rows,1,i);
        a = sleepstart(i);
        b = sleepend(i);
        plot(evening.Datetime(a:b), evening.Activity(a:b),'Color','r');
        hold on;
        c = sleepstart2(i);
        d = sleepend2(i);
        plot(evening2.Datetime(c:d), evening2.Activity(c:d),'Color','b');
    end
        han=axes('visible','off');
        han.Title.Visible='on';
        han.XLabel.Visible='on';
        han.YLabel.Visible='on';
        label_h = ylabel(han,'Movement (actigraph raw)','FontSize',12);
        label_h.Position(1) = -0.04;                                        % change horizontal position of ylabel
        label_h.Position(2) = 0.5; 
        xlabel(han,'Sleep Period','FontSize',12);
        title(han,'Nocturnal Actigraph Chronic Insomnia > Healthy Bed Partner*** (p<0.001)',...
            'FontSize',18);
end

end

% END