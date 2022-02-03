function [Rsq, Rsq_p] = R_acti_wrgb(X)

validateattributes(X,{'timetable'},{'ncols',5})

%%% OUTPUT: scatter plot with regression line of activity and white,
%%%         red, green, blue light exposure along with calculated R^2
%%%         and associated p-value for each activity-light exposure
%%%         combination.
%%%
%%% INPUT: X is a timetable with 5 columns containing binned actigraphy
%%%        data, and white/red/green/blue light exposure. 

% START    

% plot

acti_light_data = timetable2table(X);
color=['1'; '2'; 'y'; 'r'; 'g'; 'b']; 
figure;
for i = 3:6
    x = table2array(acti_light_data(:,2));
    y = table2array(acti_light_data(:,i));
    scatter(x,y,'o', color(i));
    xlabel('Movement (acti raw)','FontSize', 14, 'FontWeight','bold');
    ylabel('Light Exposure (lux)', 'FontSize', 14, 'FontWeight','bold');
    Fit = polyfit(x,y,1);
    rl = refline(Fit(1),Fit(2));
    rl.Color = color(i,1);
    rl.LineWidth = 2;
    [b,~,~,~,stats] = regress(y(:),[ones(size(x(:))),x(:)]);                % R and p-val
    Rsq(i,1) = stats(1);
    Rsq_p(i,1) = stats(3);
    hold on;
end

list = ["White"; "Red"; "Blue"; "Green"];
list = table(list);
Rsq(1:2) = [];
Rsq = table(Rsq);
Rsq(:,2) = list;
Rsq_p(1:2) = [];
Rsq_p = table(Rsq_p);
Rsq_p(:,2) = list;

end 