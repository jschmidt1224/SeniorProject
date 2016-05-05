% first 45-69
% third 25-38
% fourth 40-61
whichshot = 'first';
start = 47;
finish = 69;

allcenters = [];
allradii = [];
for i = start:finish
    % Load Frame
    original = imread(strcat('../testvids/', whichshot, 'shot/output-', num2str(i, '%03i'), '.png'));
    rgb = imread(strcat('../testvids/', whichshot, 'shot/output-', num2str(i, '%03i'), '.png'));
    % Pre-process Frame
%     hsvImage = rgb2hsv(rgb);
%     hPlane = 360.*hsvImage(:,:,1);
%     sPlane = hsvImage(:,:,2);
%     vPlane = hsvImage(:,:,3);
%     nonRedIndex = (hPlane > 54) | (hPlane < 18);
%     nonRedIndex = nonRedIndex | (sPlane < .14);
%     nonRedIndex = nonRedIndex | (vPlane < .8);
%     sPlane(nonRedIndex) = 0;
%     vPlane(nonRedIndex) = vPlane(nonRedIndex) / 20;
%     hsvImage(:,:,2) = sPlane;
%     hsvImage(:,:,3) = vPlane;
%     rgb = hsv2rgb(hsvImage);
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

%figure
%imshow(imread(strcat('../testvids/', whichshot, 'shot/output-', num2str(finish, '%03i'), '.png')));
%h = viscircles(allcenters,allradii);

[pivot, index] = max(allcenters);
index = index(2);
pivot = [allcenters(index, 1) pivot(2)];
% 
% pivotframe = imread(strcat('../testvids/', whichshot, 'shot/output-', num2str(start+index, '%03i'), '.png'));
% grayframe = im2bw(pivotframe, graythresh(pivotframe));
% edges = edge(grayframe, 'canny');
% %imshow(edges)
% [H,theta,rho] = hough(edges);
% P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
% x = theta(P(:,2));
% y = rho(P(:,1));
% lines = houghlines(edges,theta,rho,P,'FillGap',5,'MinLength',7);
% figure, imshow(pivotframe), hold on
% h = viscircles(pivot, allradii(index))
% max_len = 0;
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    %plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
% end
% % highlight the longest line segment
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');