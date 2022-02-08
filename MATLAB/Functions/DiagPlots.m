function  DiagPlots(Metadata, labs)

% Pie chart for social group composition
figure(1)
p1 = pie(categorical(Metadata.Group),string(unique(Metadata.Group)))
set(findobj(p1,'type','text'),'fontsize',30)
set(gca,'fontsize',30)
%title('Social Group Proportion in Random Validation Sets, 5 Reps')
title('Social Group Proportion of the dataset')

% Pie chart for dataset breakdown by week
figure(2)
p1 = pie(categorical(Metadata.Week),string(unique(Metadata.Week)))
set(findobj(p1,'type','text'),'fontsize',32)
set(gca,'fontsize',32)
title('#Episodes breakdown by Week')
T = p1(strcmpi(get(p1,'Type'),'text'));
P = cell2mat(get(T,'Position'));
set(T,{'Position'},num2cell(P*0.5,2))

% Feeder Breakdown
figure(3)
bar(unique(Metadata.Feeder),countcats(categorical(Metadata.Feeder)))
set(gca,'fontsize',38)
title('#Episodes by Feeder')

% Mark Breakdown
figure(4)
bar(countcats(categorical(Metadata.Mark)))
set(gca,'fontsize',38)
set(gca,'xticklabel',unique(Metadata.Mark))
title('#Episodes by Mark')

% Behavior category breakdown
figure(5)
bar(countcats(labs))
set(gca,'fontsize',32)
set(gca,'xticklabel',unique(labs))
end