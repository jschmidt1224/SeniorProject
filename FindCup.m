function [ Loc, Height ] = FindCup( input_arg )
%FINDCUP Finds the location of the front left cup
%   Removes all colors except the red of solo cups and finds the first
%   pixel from the bottom left most pixel that is still red


hsvImage = rgb2hsv(input_arg);
%imshow(original);
%figure;
hPlane = 360.*hsvImage(:,:,1);
sPlane = hsvImage(:,:,2);
vPlane = hsvImage(:,:,3);
nonRedIndex = (hPlane > 30) & (hPlane < 330);
nonRedIndex = nonRedIndex | vPlane < .4;
nonRedIndex = nonRedIndex | sPlane < .6;
sPlane(nonRedIndex) = 0;
vPlane(nonRedIndex) = 0;%vPlane(nonRedIndex);
hsvImage(:,:,2) = sPlane;
hsvImage(:,:,3) = vPlane;
rgbImage = hsv2rgb(hsvImage);
%figure
%imshow(rgbImage);
Loc = [0, 0];
for y = size(sPlane, 1):-1:1
    for x = 1:size(sPlane, 2)
        if (sPlane(y,x) ~= 0 && sPlane(y+1, x) ~= 0 && sPlane(y+2, x) ~= 0)
            Loc = [x, y];
            break
        end
    end
    if (Loc ~= [0, 0])
        break;
    end
end
Height = Loc(2) - 100
for y = Loc(2):-1:1
    y
    if (sPlane(y, Loc(1)) == 0)
        Height = y + 60;
        break;
    end
end



%plot(Loc(1), Loc(2), 'go', 'MarkerSize', 20)


end

