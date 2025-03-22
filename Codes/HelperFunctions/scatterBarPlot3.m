function scatterBarPlot3(Data, yBreaks)
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
%% Visualization parameter specification
groupColor = {[255, 69, 64]/255, [0, 185, 69]/255, [76, 87, 216]/255, [235, 180, 113]/255; ...
                            [235, 122, 119]/255, [134, 193, 102]/255, [125, 185, 222]/255, [255, 177, 27]/255; ...
                            [245, 150, 170]/255, [181, 202, 160]/255, [165, 222, 228]/255, [249, 191, 69]/255};
errorBarColor = [68, 68, 68]/255;

for i = 1:nGroup
    connectLineColor{i} = (groupColor{1, i} + groupColor{2, i} + groupColor{3, i})/3;
end

jitterIndex = 0; % X jitter of scatters;
scatterSize = 21; % scatter size
barWidth = 0.2; % Main bar width
barGap = 0.026;
errorBarWidth = 3; % Error bar line width
semHatLength = 0.00;
semHatWidth = 1.7;
errorBarAlpha = 50/100; % Error bar transparency
scatterAlpha = 85/100;
barAlpha = 45/100;
barEdgeAlpha = 0;
connectLineWidth = 1.4;
connectLineAlpha = 25/100;
jitterScatter = 0.025;
jitterErrorBar = 0;
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
        Data3 = Data{3, iteGroup};
        
        nSub1{iteGroup} = length(Data1);
        nSub2{iteGroup} = length(Data2);
        nSub3{iteGroup} = length(Data3);
        
        if nSub1{iteGroup} ~= nSub2{iteGroup} || nSub1{iteGroup} ~= nSub3{iteGroup} || nSub2{iteGroup} ~= nSub3{iteGroup}
            error('Sample size in the three conditions must match!');
        else 
            nSub{iteGroup} = nSub1{iteGroup};
        end
 
        M1 = mean(Data1);
        SEM1 = std(Data1)/sqrt(nSub{iteGroup});
        M2 = mean(Data2);
        SEM2 = std(Data2)/sqrt(nSub{iteGroup});
        M3 = mean(Data3);
        SEM3 = std(Data3)/sqrt(nSub{iteGroup});
        
        jitter{iteGroup} = (rand(nSub{iteGroup}, 1) - 0.5) * jitterIndex;
        
        jitter{iteGroup} = jitter{iteGroup} .* (1:nSub{iteGroup})' .* (nSub{iteGroup} : -1 : 1)' / mean((1:nSub{iteGroup})' .* (nSub{iteGroup} : -1 : 1)');
        
        X1{iteGroup} = iteGroup + jitter{iteGroup} - barWidth - barGap/2 + jitterScatter;
        X2{iteGroup} = iteGroup + jitter{iteGroup} + 0 + 0 + jitterScatter;
        X3{iteGroup} = iteGroup + jitter{iteGroup} + barWidth + barGap/2 + jitterScatter;
        
        %% Connect the individual data points
        % Why is it This step must be done before the data is sorted
        for iteLine = 1:nSub{iteGroup}
            plot([X1{iteGroup}(iteLine), X2{iteGroup}(iteLine)], [Data1(iteLine), Data2(iteLine)],  '-', ...
            'LineWidth', connectLineWidth, ...
            'Color', [connectLineColor{iteGroup}, connectLineAlpha]);
            hold on
            
            plot([X2{iteGroup}(iteLine), X3{iteGroup}(iteLine)], [Data2(iteLine), Data3(iteLine)],  '-', ...
            'LineWidth', connectLineWidth, ...
            'Color', [connectLineColor{iteGroup}, connectLineAlpha]);
            hold on
        end

        scatter(X1{iteGroup}, Data1, scatterSize, 'filled', 'MarkerFaceColor', groupColor{1, iteGroup},'MarkerFaceAlpha', scatterAlpha);
        hold on
        scatter(X2{iteGroup}, Data2, scatterSize, 'filled', 'MarkerFaceColor', groupColor{2, iteGroup},'MarkerFaceAlpha', scatterAlpha);
        hold on
        scatter(X3{iteGroup}, Data3, scatterSize, 'filled', 'MarkerFaceColor', groupColor{3, iteGroup},'MarkerFaceAlpha', scatterAlpha);
        hold on
        
        %% Plot the mean bar
        bar(iteGroup - barWidth - barGap/2, M1, ...
            'FaceColor', groupColor{1, iteGroup}, ...
            'FaceAlpha', barAlpha, ...
            'BarWidth', barWidth, ...
            'EdgeAlpha', barEdgeAlpha);
        hold on
        
       bar(iteGroup + 0 + 0, M2, ...
            'FaceColor', groupColor{2, iteGroup}, ...
            'FaceAlpha', barAlpha, ...
            'BarWidth', barWidth, ...
            'EdgeAlpha', barEdgeAlpha);
        hold on
        
        bar(iteGroup + barWidth + barGap/2, M3, ...
            'FaceColor', groupColor{3, iteGroup}, ...
            'FaceAlpha', barAlpha, ...
            'BarWidth', barWidth, ...
            'EdgeAlpha', barEdgeAlpha);
        hold on
        
        %% Plot the SEM
        plot([iteGroup - barWidth - barGap/2 - jitterErrorBar, iteGroup - barWidth - barGap/2 - jitterErrorBar], [M1 + SEM1, M1 - SEM1], ...
            'LineWidth', errorBarWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        
        % Condition 2
        plot([iteGroup + 0 + 0 + jitterErrorBar, iteGroup + 0 + 0 + jitterErrorBar], [M2 + SEM2, M2 - SEM2], ...
            'LineWidth', errorBarWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        
        % Condition 3
        plot([iteGroup + barWidth + barGap/2 + jitterErrorBar, iteGroup + barWidth + barGap/2 - jitterErrorBar], [M3 + SEM3, M3 - SEM3], ...
            'LineWidth', errorBarWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        %% Plot the SEM hats
        % Condition 1
        plot([iteGroup - semHatLength/2 - barWidth - barGap/2 - jitterErrorBar, iteGroup + semHatLength/2 - barWidth - barGap/2 - jitterErrorBar], [M1 + SEM1, M1 + SEM1], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        
        plot([iteGroup - semHatLength/2 - barWidth - barGap/2 - jitterErrorBar, iteGroup + semHatLength/2 - barWidth - barGap/2 - jitterErrorBar], [M1 - SEM1, M1 - SEM1], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        
        % Condition 2
        plot([iteGroup - semHatLength/2 + 0 + 0 + jitterErrorBar, iteGroup + semHatLength/2 + 0 + 0 + jitterErrorBar], [M2 + SEM2, M2 + SEM2], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        
        plot([iteGroup - semHatLength/2 + 0 + 0 + jitterErrorBar, iteGroup + semHatLength/2 + 0 + 0 + jitterErrorBar], [M2 - SEM2, M2 - SEM2], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        
        % Condition 3
        plot([iteGroup - semHatLength/2 + barWidth + barGap/2 + jitterErrorBar, iteGroup + semHatLength/2 + barWidth + barGap/2 + jitterErrorBar], [M3 + SEM3, M3 + SEM3], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        hold on
        
        plot([iteGroup - semHatLength/2 + barWidth + barGap/2 + jitterErrorBar, iteGroup + semHatLength/2 + barWidth + barGap/2 + jitterErrorBar], [M3 - SEM3, M3 - SEM3], ...
            '-', ...
            'LineWidth', semHatWidth, ...
            'Color', [errorBarColor, errorBarAlpha]);
        
        
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


