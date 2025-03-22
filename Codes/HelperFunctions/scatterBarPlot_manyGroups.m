function scatterBarPlot_manyGroups(Data, yBreaks)
%% function scatterBarPlot(Data, yBreaks)
% The variable Data should be organized in the way that each cell includes all the individual data-points in one condition
% Copyright: Linfeng Tony Han, graduate student at the University of Pennsylvania 
% Contact: hanlf@sas.upenn.edu

if ~iscell(Data)
    error("The input data must be organized in a cell!");
    return
end

%% Visualization parameter specification
groupColor = {[210, 100, 100]/255, [0, 120, 210]/255, [160, 110, 255]/255, [50, 160, 50]/255, [127, 127, 127]/255, [210, 100, 100]/255, [0, 120, 210]/255, [160, 110, 255]/255, [127, 127, 127]/255, [127, 127, 127]/255};
errorBarColor = {[68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255, [68, 68, 68]/255};
errorBarWidth = 3.7; % Error bar line width
errorBarAlpha = 78/100; % Error bar transparency
nGroup = size(Data, 2); % number of groups (nColumns)
jitterIndex = 0.12; % X jitter of scatters;
scatterSize = 28; % scatter size
barWidth = 0.75; % Main bar width
semHatLength = 0.00;
semHatWidth = 2.1;
scatterAlpha = 70/100;
barAlpha = 55/100;
barEdgeAlpha = 0;
xRange = [0.24, nGroup + 0.76];
baselineWidth = 2;

gap = 0.2; %yBreak gap (visualization)
tickLineWidth = 1.5; % yBreak tick line width
tickLineLengthIndex = 2.25; % yBreak tick line length (index: the scale relative to the ytick length)

axisFontSize = 24;
axisFontName = 'Myriad Pro';
if nargin == 1 % If the input variable "yBreaks" is empty, do not put breaks on the y-axis
    
    for iteGroup = 1:nGroup
        %errorBarColor = groupColor{iteGroup}; % If you want to change the
        %error bar color same to the bars
        
        nSub{iteGroup} = length(Data{iteGroup});
        M = mean(Data{iteGroup});
        SEM = std(Data{iteGroup})/sqrt(nSub{iteGroup});
        
        jitter{iteGroup} = (rand(nSub{iteGroup}, 1) - 0.5) * jitterIndex;
        
        jitter{iteGroup} = jitter{iteGroup} .* (1:nSub{iteGroup})' .* (nSub{iteGroup} : -1 : 1)' / mean((1:nSub{iteGroup})' .* (nSub{iteGroup} : -1 : 1)');
        
        X{iteGroup} = iteGroup + jitter{iteGroup};
        
        Data{iteGroup} = sort(Data{iteGroup});
        scatter(X{iteGroup}, Data{iteGroup}, scatterSize, 'filled', 'MarkerFaceColor', groupColor{iteGroup},'MarkerFaceAlpha', scatterAlpha);
        
        hold on
        
        %% Plot the mean bar
        barGraph = bar(iteGroup, M, ...
            'FaceColor', groupColor{iteGroup}, ...
            'FaceAlpha', barAlpha, ...
            'BarWidth', barWidth, ...
            'EdgeAlpha', barEdgeAlpha);
        
        barGraph(1).BaseLine.LineWidth = baselineWidth;
        barGraph(1).BaseLine.Color = [0.7,0.7,0.7];
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
        barGraph = bar(iteGroup, M, ...
            'FaceColor', groupColor{iteGroup}, ...
            'FaceAlpha', barAlpha, ...
            'BarWidth', barWidth, ...
            'EdgeAlpha', barEdgeAlpha);
        barGraph(1).BaseLine.LineWidth = baselineWidth;
        barGraph(1).BaseLine.Color = [0.7,0.7,0.7];
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


