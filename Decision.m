clear all; close all; clc;
RLStep = 10;
FBStep = 2000;
count = 0;
LastLeft = false;
LastRight = false;
LastFront = false;
LastBack = false;
while (true)
    % firstshot 150 - 205
    % Back_Right_3708 12 - 70
    % Back_Right_3709 79 - 137
    % Front_Right_3706 33 - 120
    % Back_Left_3719 89 - 104
    % Back_Right_3711 29 - 72
    % Back_Right_3713 14 - 34
    % Front_EdgeCase 25 - 57
    % Front_3724 53 - 78
    if (count ~= 0)
        Continue = input('Continue? (Y or N):  ', 's');
        if (Continue ~= 'Y')
            break;
        end
    end
    
    
    whichshot = input('Enter name of folder with Frames: ', 's');
    start = input('Start Frame: ');
    finish = input('End Frame: ');
    
    count = count + 1;
    allcenters = [];
    allradii = [];
    for i = start:finish
        % Load Frame
        original = imread(strcat(whichshot, '/output-', num2str(i, '%03i'), '.png'));
        rgb = imread(strcat(whichshot, '/output-', num2str(i, '%03i'), '.png'));
        % Pre-process Frame
        rgb = PreProcessBall(rgb);
        %find circle
        [centers, radii, metric] = imfindcircles(rgb,[20 30], 'Sensitivity', .975, 'ObjectPolarity', 'bright');
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
    
    %close all
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
        LastRight = true;
        fprintf(strcat('Right: ', '2 ', RLStep, '\n'))
        if (LastLeft == true)
            RLStep = RLStep / 2;
        end
        LastLeft = false;
    elseif (pivot(1) < Loc(1) - 60)
        LastLeft = true;
        fprintf(strcat('Left: ', '-2 ', RLStep, '\n'))
        if (LastRight == true)
            RLStep = RLStep / 2;
        end
        LastRight = false;
    end
    
    if (abs(Loc(1) - pivot(1)) < 100)
        if (pivot(2) < Height)
            LastBack = true;
            fprintf(strcat('Back: ', '1 ', FBStep, '\n'))
            if (LastFront == true)
                FBStep = FBStep / 2;
            end
            LastFront = false;
        elseif (pivot(2) > Height)
            LastFront = true;
            fprintf(strcat('Front: ', '-1 ', FBStep, '\n'))
            if (LastBack == true)
                FBStep = FBStep / 2;
            end
            LastBack = false;
        end
    end
    
end