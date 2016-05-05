% first 150 - 205
% third 25-38
% fourth 40-61
whichshot = 'first';
start = 150;
finish = 205;

allcenters = [];
allradii = [];
for i = start:finish
    % Load Frame
    original = imread(strcat(whichshot, 'shot/output-', num2str(i, '%03i'), '.png'));
    rgb = imread(strcat(whichshot, 'shot/output-', num2str(i, '%03i'), '.png'));
    % Pre-process Frame
    rgb = PreProcessBall(rgb);
    %find circle
    [centers, radii, metric] = imfindcircles(rgb,[20 30], 'Sensitivity', .975, 'ObjectPolarity', 'bright')
    if size(centers) >= 1
        centers = centers(1,:);
        radii = radii(1);
        metricStrong5 = metric(1);
        allcenters = [allcenters; centers];
        allradii = [allradii radii];
    end
    %figure
    %imshow(rgb);
    
    %h = viscircles(centers,radii);
end
%%
close all
figure
imshow(original);
hold on;
viscircles(allcenters, allradii);
%imshow(imread(strcat('../testvids/', whichshot, 'shot/output-', num2str(finish, '%03i'), '.png')));
%h = viscircles(allcenters,allradii);

% Finding the first bounce
for i = 2:size(allcenters, 1)
    if (allcenters(i, 2) < allcenters(i-1, 2))
        pivotIndex = i-1;
        break;
    end
end
pivot = allcenters(pivotIndex,:);
%Finging the Cup
[Loc, Height] = FindCup(original);
hold on;
h = viscircles(pivot, allradii(pivotIndex), 'EdgeColor', 'b', 'LineStyle', ':', 'LineWidth', .1);
hold on
plot(Loc(1), Loc(2), 'go', 'MarkerSize', 10);
plot([1, size(original, 2)], [Height, Height], 'g');

if (pivot(1) > Loc(1) + 60)
    fprintf('Right\n')
elseif (pivot(1) < Loc(1) - 60)
    fprintf('Left\n')
end

if (pivot(2) < Height)
    fprintf('Back\n')
elseif (pivot(2) > Height)
    fprintf('Front\n')
end

