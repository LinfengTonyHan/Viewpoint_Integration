function scatterBarPlot2_Dsc(Data, yBreaks)
%% function scatterBarPlot(Data, yBreaks)
% The variable Data should be organized in the way that each cell includes all the individual data-points in one condition
% Copyright: Linfeng Tony Han, graduate student at the University of Pennsylvania 
% Contact: hanlf@sas.upenn.edu

if ~iscell(Data)
    error("The input data must be organized in a cell!");
    return
end

nGroup = size(Data, 2); % number of groups (nColumns)
nCond = size(Data, 1);

Cyan = [7, 180, 170]/255;
Orange = [230, 135, 50]/255;
Gray = [68, 68, 68]/255;
%% Visualization parameter specification
groupColor = {Cyan, Cyan, Cyan, Gray; ...
                  Orange, Orange, Orange, [156, 156, 156]/255};
     
errorBarColor = [68, 68, 68]/255;
for i = 1:nGroup
    connectLineColor{i} = (groupColor{1, i} + groupColor{2, i})/2;
end

jitterIndex = 0; % X jitter of scatters;
scatterSize = 24; % scatter size
barWidth = 0.25; % Main bar width
barLineWidth = 2;
barGap = 0.04;
baselineWidth = 2;
errorBarWidth = 4.4; % Error bar line width
semHatLength = 0.00;
semHatWidth = 1.7;
errorBarAlpha = 70/100; % Error bar transparency
scatterAlpha = 85/100;
barAlpha = 60/100;
barEdgeAlpha = 85/100;
connectLineWidth = 1.4;
connectLineAlpha = 25/100;
jitterScatter = 0.000; % Move the scatter points a little aside from the midline of the bar
jitterErrorBar = 0.000; % Move the error bar a little aside
xRange = [0.24, nGroup + 0.76];

gap = 0.2; %yBreak gap (visualization)
tickLineWidth = 1.5; % yBreak tick line width
tickLineLengthIndex = 2.25; % yBreak tick line length (index: the scale relative to the ytick length)

axisFontSize = 24;
axisFontName = 'Myriad Pro';
if nargin == 1 % If the input variable "yBreaks" is empty, do not put breaks on the y-axis
    
    for iteGroup = 1:nGroup
        % errorBarColor = groupColor{iteGroup}; % If you want to change the
        % error bar color same to the bars
        % Generate the data for the two conditions separately
        Data1 = Data{1, iteGroup};
        Data2 = Data{2, iteGroup};
        
        nSub1{iteGroup} = length(Data1);
        nSub2{iteGroup} = length(Data2);
        
        if nSub1{iteGroup} ~= nSub2{iteGroup}
            error('Sample size in the two conditions must match!');
        else 
            nSub{iteGroup} = nSub1{iteGroup};
        end
 
        M1 = mean(Data1);
        SEM1 = std(Data1)/sqrt(nSub{iteGroup});
        M2 = mean(Data2);
        SEM2 = std(Data2)/sqrt(nSub{iteGroup});
        
        jitter{iteGroup} = (rand(nSub{iteGroup}, 1) - 0.5) * jitterIndex;
        
        jitter{iteGroup} = jitter{iteGroup} .* (1:nSub{iteGroup})' .* (nSub{iteGroup} : -1 : 1)' / mean((1:nSub{iteGroup})' .* (nSub{iteGroup} : -1 : 1)');
        
        X1{iteGroup} = iteGroup + jitter{iteGroup} - barWidth/2 - barGap/2 + jitterScatter;
        X2{iteGroup} = iteGroup + jitter{iteGroup} + barWidth/2 + barGap/2 - jitterScatter;
        
        %% Connect the individual data points
        % Why is it This step must be done before the data is sorted
        for iteLine = 1:nSub{iteGroup}
            plot([X1{iteGroup}(iteLine), X2{iteGroup}(iteLine)], [Data1(iteLine), Data2(iteLine)],  '-', ...
            'LineWidth', connectLineWidth, ...
            'Color', [connectLineColor{iteGroup}, connectLineAlpha]);
            hold on
        end

        Data1 = sort(Data1);
        Data2 = sort(Data2);
        scatter(X1{iteGroup}, Data1, scatterSize, 'filled', 'MarkerFaceColor', groupColor{1, iteGroup},'MarkerFaceAlpha', scatterAlpha);
        hold on
        scatter(X2{iteGroup}, Data2, scatterSize, 'filled', 'MarkerFaceColor', groupColor{2, iteGroup},'MarkerFaceAlpha', scatterAlpha);
        hold on
        
        %% Plot the mean bar
        bar1 = bar(iteGroup - barWidth/2 - barGap/2, M1, ...
            'FaceColor', groupColor{1, iteGroup}, ...
            'FaceAlpha', barAlpha, ...
            'BarWidth', barWidth, ...
            'EdgeColor', groupColor{1, iteGroup}, ...
            'LineWidth', barLineWidth, ...
            'EdgeAlpha', barEdgeAlpha);
        bar1(1).BaseLine.LineWidth = baselineWidth;
        bar1(1).BaseLine.Color = [0.7,0.7,0.7];
        hold on
        
        
        bar2 = bar(iteGroup + barWidth/2 + barGap/2, M2, ...
            'FaceColor', groupColor{2, iteGroup}, ...
            'FaceAlpha', barAlpha, ...
            'BarWidth', barWidth, ...
            'EdgeColor', groupColor{2, iteGroup}, ...
            'LineWidth', barLineWidth, ...
            'EdgeAlpha', barEdgeAlpha);
        bar2(1).BaseLine.LineWidth = baselineWidth;
        bar2(1).BaseLine.Color = [0.7,0.7,0.7];
        hold on
        
        
        %% Plot the SEM
        plot([iteGroup - barWidth/2 - barGap/2 - jitterErrorBar, iteGroup - barWidth/2 - barGap/2 - jitterErrorBar], [M1 + SEM1, M1 - SEM1], ...
            'LineWidth', errorBarWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        
        % Condition 2
        plot([iteGroup + barWidth/2 + barGap/2 + jitterErrorBar, iteGroup + barWidth/2 + barGap/2 + jitterErrorBar], [M2 + SEM2, M2 - SEM2], ...
            'LineWidth', errorBarWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        
        %% Plot the SEM hats
        % Condition 1
        plot([iteGroup - semHatLength/2 - barWidth/2 - barGap/2 - jitterErrorBar, iteGroup + semHatLength/2 - barWidth/2 - barGap/2 - jitterErrorBar], [M1 + SEM1, M1 + SEM1], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        
        plot([iteGroup - semHatLength/2 - barWidth/2 - barGap/2 - jitterErrorBar, iteGroup + semHatLength/2 - barWidth/2 - barGap/2 - jitterErrorBar], [M1 - SEM1, M1 - SEM1], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        
        % Condition 2
        plot([iteGroup - semHatLength/2 + barWidth/2 + barGap/2 + jitterErrorBar, iteGroup + semHatLength/2 + barWidth/2 + barGap/2 + jitterErrorBar], [M2 + SEM2, M2 + SEM2], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        
        plot([iteGroup - semHatLength/2 + barWidth/2 + barGap/2 + jitterErrorBar, iteGroup + semHatLength/2 + barWidth/2 + barGap/2 + jitterErrorBar], [M2 - SEM2, M2 - SEM2], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        
        % Connect individual data points in the two conditions
       
        
    end
    
    hold off
    
    
    %% if yBreaks is added, put a break on the y-axis to deal with extreme values
elseif nargin == 2 %
    if ~isnumeric(yBreaks)
        error('The yBreaks input must be a 1*2 numerical vector!');
        return;
    end
    
    if length(yBreaks)  ~= 2
        error('The yBreaks input must be a 1*2 matrix!');
        return;
    end
    
    skippedValues = yBreaks(2) - yBreaks(1);
    
    for iteGroup = 1:nGroup
        %errorBarColor = groupColor{iteGroup};
        nSub{iteGroup} = length(Data{iteGroup});
        M = mean(Data{iteGroup});
        SEM = std(Data{iteGroup})/sqrt(nSub{iteGroup});
        
        jitter{iteGroup} = (rand(nSub{iteGroup}, 1) - 0.5) * jitterIndex;
        
        jitter{iteGroup} = jitter{iteGroup} .* (1:nSub{iteGroup})' .* (nSub{iteGroup} : -1 : 1)' / mean((1:nSub{iteGroup})' .* (nSub{iteGroup} : -1 : 1)');
        
        X{iteGroup} = iteGroup + jitter{iteGroup};
        
        Data{iteGroup} = sort(Data{iteGroup});
       
        dataCur = Data{iteGroup}; % dataCur: Current group data
        adjustIndex = find(dataCur > yBreaks(2));
        dataCur(adjustIndex) = dataCur(adjustIndex) - skippedValues;
        scatter(X{iteGroup}, dataCur, scatterSize, 'filled', 'MarkerFaceColor', groupColor{iteGroup},'MarkerFaceAlpha', scatterAlpha);
        
        hold on
        %% Plot the mean bar
        bar(iteGroup, M, ...
            'FaceColor', groupColor{iteGroup}, ...
            'FaceAlpha', barAlpha, ...
            'BarWidth', barWidth, ...
            'EdgeAlpha', barEdgeAlpha);
        hold on
        
        %% Plot the SEM
        plot([iteGroup, iteGroup], [M + SEM, M-SEM], ...
            'LineWidth', errorBarWidth, ...
            'Color', [errorBarColor{iteGroup}, errorBarAlpha]);
        hold on
        
        %% Plot the SEM hats
        plot([iteGroup - semHatLength/2, iteGroup + semHatLength/2], [M + SEM, M + SEM], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor{iteGroup}, errorBarAlpha]);
        hold on
        
        plot([iteGroup - semHatLength/2, iteGroup + semHatLength/2], [M - SEM, M - SEM], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor{iteGroup}, errorBarAlpha]);
        
    end
    
    %% Now, put the y-axis breaks
    hold on
    
    %% Parse the inputs
    % Default values
    ax = gca;
    breakWidth = get(ax, 'ticklength');
    breakWidth = breakWidth(1) * tickLineLengthIndex;
    bottom_reset = '';
    xy = 'y';
    position = yBreaks(1);
    
    %% Put the breaks there
    % Get figure handle
    f = get(ax, 'parent');
    
    % Get number of ticks
    n = length(get(ax, strcat(xy, 'ticklabel'))) - 1;
    pos = get(ax, 'position');
    
    if strcmp(xy, 'x')
        
        % Get the spacing between ticks
        spacing = pos(3) / n;
        
        % Find the center along the axis
        cent = pos(2) + 0.5 * spacing;
        
        % Reset if a position was given
        if position < Inf
            lims = get(gca, 'xlim');
            cent = pos(1) + pos(3) * (position - lims(1))/(diff(lims));
        end
        
        % define the gaps of the bar
        X = [cent - gap*spacing/2;
            cent + gap*spacing/2];
        Y1 = [pos(2) - 0.005;
            pos(2) + 0.005];
        Y2 = [pos(2) - breakWidth/2;
            pos(2) + breakWidth/2];
        
        % Make the bar and ticks
        h1 = annotation(f, 'rectangle', [X(1), Y1(1), diff(X), diff(Y1)]);
        annotation(f, 'line', [X(1), X(1)], [Y2(1), Y2(2)]);
        annotation(f, 'line', [X(2), X(2)], [Y2(1), Y2(2)]);
        
    elseif strcmp(xy, 'y')
        % Get the spacing between ticks
        spacing = pos(4)/n;
        
        % Find the center along the axis
        cent = pos(2) + 0.5*spacing;
        
        % Reset if a position was given
        if position < Inf
            lims = get(gca, 'ylim');
            cent = pos(2) + pos(4) * (position - lims(1))/(diff(lims));
        end
        
        % define the gaps of the bar
        X1 = [pos(1) - 0.005; pos(1) + 0.005];
        X2 = [pos(1) - breakWidth/2; pos(1) + breakWidth/2];
        Y = [cent - gap*spacing/2; cent + gap*spacing/2];
        
        % Make the bar and ticks
        tickRect = annotation(f, 'rectangle', [X1(1), Y(1), diff(X1), diff(Y)]);
        tickLine1 = annotation(f, 'line', [X2(1) X2(2)], [Y(1) Y(1)]);
        tickLine2 = annotation(f, 'line', [X2(1) X2(2)], [Y(2) Y(2)]);
        
    end
    
    % Reset the color and line widths
    tickRect.FaceColor = 'w';
    tickRect.Color = 'w';
    tickLine1.LineWidth = tickLineWidth;
    tickLine2.LineWidth = tickLineWidth;
    
    % Reset the bottom value
    if strcmp(bottom_reset, '')
        list = get(ax, [xy 'ticklabel']);
        list(1) = {bottom_reset};
        set(gca, [xy 'ticklabel'], list);
    end
    
end

hold off

curFig = gca;
curFig.FontSize = axisFontSize;
curFig.FontName = axisFontName;

xlim(xRange);
xticks(1:nGroup);
end


