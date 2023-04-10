clc
clear
close all

% Read SurveyResult.xlsx file as input
filename = 'SurveyResult.xlsx';
[num,txt,raw] = xlsread(filename);

% Convert the raw data to a table
variableNames = {'ID','Department','EmployeeType','Gender','Age','Value','Satisfaction','Balance','Communication','Responsibilities','Compensation','Recommendation'};
T = cell2table(raw(2:end,:),'VariableNames',variableNames);

% Process and analyze the data
departments = unique(T.Department);
employeetypes = {'Full-Time','Part-Time','Contracted Third-Party'};
gendertypes = {'Male','Female','Other'};
resulttypes = {'Value','Satisfaction','Balance','Communication','Responsibilities','Compensation','Recommendation'};

% Calculate the mean score for each result type, department, employee type, and gender type
mean_score = zeros(length(resulttypes),length(departments),length(employeetypes),length(gendertypes));
for r=1:length(resulttypes)
    for d=1:length(departments)
        for e=1:length(employeetypes)
            for g=1:length(gendertypes)
                idx = strcmp(T.Department,departments{d}) & strcmp(T.EmployeeType,employeetypes{e}) & strcmp(T.Gender,gendertypes{g});
                mean_score(r,d,e,g) = mean(T.(resulttypes{r})(idx));
            end
        end
    end
end

% Visualize the survey result using Matlab plots
% Bar plots for department-wise analysis
for r=1:length(resulttypes)
    figure;
    bar(mean_score(r,:,:,:));
    set(gca,'XTick',1:length(departments),'XTickLabel',departments);
    legend(employeetypes);
    title(['Department-wise ' resulttypes{r} ' Analysis']);
    xlabel('Departments');
    ylabel('Mean Score');
end

% Stacked bar plots for employee type and gender type analysis
for r=1:length(resulttypes)
    for d=1:length(departments)
        figure;
        bar(squeeze(mean_score(r,d,:,:)),'stacked');
        set(gca,'XTick',1:length(employeetypes),'XTickLabel',employeetypes);
        legend(gendertypes);
        title([departments{d} ' ' resulttypes{r} ' Analysis']);
        xlabel('Employee Types');
        ylabel('Mean Score');
    end
end

% Generate SurveySummary.xlsx as output
Summary = table();
for r=1:length(resulttypes)
    for d=1:length(departments)
        for e=1:length(employeetypes)
            for g=1:length(gendertypes)
                Summary = [Summary; {departments{d}}, {employeetypes{e}}, {gendertypes{g}}, {resulttypes{r}}, mean_score(r,d,e,g)];
            end
        end
    end
end
Summary.Properties.VariableNames = {'Department','EmployeeType','Gender','ResultType','MeanScore'};
writetable(Summary,'SurveySummary.xlsx');

