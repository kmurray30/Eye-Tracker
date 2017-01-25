%% Clearing Memory
if exist('hVideoIn', 'var')
release(hVideoIn); % Release all memory and buffer used
release(vidDevice);
% clear all;
clc;
end

%% Input Data
vidDevice = imaq.VideoDevice('macvideo', 1, getResolution, ... % Acquire input video stream
                    'ROI', [440 160 400 400], ...
                    'ReturnedColorSpace', 'rgb');
vidInfo = imaqhwinfo(vidDevice); % Acquire input video property
%     sample = step(vidDevice);
ROI = get(vidDevice,'ROI');
hVideoIn = vision.VideoPlayer('Name', 'Final Video', ... % Output video player
                                'Position', [0 720 ROI(3) ROI(4)]);
coordinates = dlmread('coordinates.txt'); % Get coordinates from eye calibration
nFrame = 0; % Frame number initialization
    screenRes = get(0,'MonitorPositions');
set(0, 'DefaultFigurePosition', screenRes);
plotrange = [200 1300 150 750]; % Plot values based upon screen resolution coordinates
axis(plotrange); % Set up plotter to track eye movement
hold on;
shg

%% Processing Loop
while 1%nFrame < 100
    bodyparts = 0; % Counter to make sure we have both pupils and nose before plotting
    frame = step(vidDevice); % Acquire single frame
    frame = flip(frame,2); % obtain the mirror image for displaying

% Find eyes
detector = vision.CascadeObjectDetector;
lnb = 0; rnb = 0;
% Left Eye
set(detector, 'ClassificationModel', 'LeftEyeCART');
BBOX = step(detector,frame);

if ~isempty(BBOX)
[~, loc] = min(BBOX(:, 1));
BBOX = BBOX(loc, :);
x1 = BBOX(end-3);
y1 = BBOX(end-2);
x2 = BBOX(end-3)+BBOX(end-1);
y2 = BBOX(end-2)+BBOX(end);
frame(y1:y1+3, x1:x2, 1) = 255;
frame(y2-3:y2, x1:x2, 1) = 255;
frame(y1:y2, x1:x1+3, 1) = 255;
frame(y1:y2, x2-3:x2, 1) = 255;
BBOXXX=BBOX;
lnb = x1; % leftnosebound
end

% Find pupils
if ~isempty(BBOX)
leftEye = frame(y1:y2,x1:x2,:);

[centers, radii] = imfindcircles(leftEye,[10 30], 'ObjectPolarity','dark', 'Sensitivity',0.9,'Method','twostage','EdgeThreshold',.05);
if ~isempty(centers)
    
centers1 = centers(1,:) + [x1 y1];
centers1 = int32(centers1);

frame(centers1(2) - 1 : centers1(2) + 1, centers1(1) - 7 : centers1(1) + 7, 1) = 255;
frame(centers1(2) - 7 : centers1(2) + 7, centers1(1) - 1 : centers1(1) + 1, 1) = 255;

bodyparts = bodyparts + 1;
end
end
release(detector);

% Right Eye
set(detector, 'ClassificationModel', 'RightEyeCART');
BBOX = step(detector,frame);

if ~isempty(BBOX)
[~, loc] = max(BBOX(:, 1)+BBOX(:, 3));
BBOX = BBOX(loc, :);
x1 = BBOX(end-3);
y1 = BBOX(end-2);
x2 = BBOX(end-3)+BBOX(end-1);
y2 = BBOX(end-2)+BBOX(end);
frame(y1:y1+3, x1:x2, 3) = 255;
frame(y2-3:y2, x1:x2, 3) = 255;
frame(y1:y2, x1:x1+3, 3) = 255;
frame(y1:y2, x2-3:x2, 3) = 255;
rnb = x2; %rightnosebound
end

% Find pupils
if ~isempty(BBOX)
rightEye = frame(y1:y2,x1:x2,:);

[centers, radii] = imfindcircles(rightEye,[10 30], 'ObjectPolarity','dark', 'Sensitivity',0.9,'Method','twostage','EdgeThreshold',.05);
if ~isempty(centers)
    
centers2 = centers(1,:) + [x1 y1];
centers2 = int32(centers2);

frame(centers2(2) - 1 : centers2(2) + 1, centers2(1) - 7 : centers2(1) + 7, 3) = 255;
frame(centers2(2) - 7 : centers2(2) + 7, centers2(1) - 1 : centers2(1) + 1, 3) = 255;

bodyparts = bodyparts + 1;
end
end
release(detector);

% Nose
if lnb > 0 && rnb - lnb > 0
noseframe = frame(:, lnb : rnb, :);
set(detector, 'ClassificationModel', 'Nose');
BBOX = step(detector,noseframe);

if ~isempty(BBOX)
[~, loc] = max(BBOX(:, 4));
BBOX = BBOX(loc, :);
x = BBOX(end-3) + floor(BBOX(end-1)/2) + lnb;
y = BBOX(end-2) + floor(BBOX(end)/2);
frame(y:y+2, x-10:x+10, 2) = 255;
bodyparts = bodyparts + 1;
end
release(detector);
end

if bodyparts == 3
    coords = double([centers1 centers2 x y]);
    xdis = coords(3) - coords(1); % Find x distance of eyes
    ydis = coords(4) - coords(2);
    deg1 = atan(ydis/xdis); % Find the angle of the eyes
    
    Coords = [(coords(1)+coords(3))./2,(coords(2)+coords(4))./2,coords(5:6)];
    relLoc = [Coords(1,1)-Coords(1,3), Coords(1,2)-Coords(1,4)];
    deg2 = atan(relLoc(1)/relLoc(2)); % Find the angle from the nose to the midpoint of the eyes
    deg3 = deg2 + deg1; % Find the angle for adjustment
    hyp = sqrt(relLoc(1)^2 + relLoc(2)^2); % Hypoteneuse
    yadj = hyp*cos(deg3); % Adjusted y
    xadj = hyp*sin(deg3);
    newcoords = [xadj, yadj];
    
    % Convert eye movement to predicted location on screen
    screenw = screenRes(end-1);
    screenh = screenRes(end);
    
    eyerangex = coordinates(2) - coordinates(1);
    xrel = -(xadj - coordinates(1))/eyerangex;
    X = xrel*screenw + screenw;
    X = X;
    
    eyerangey = coordinates(4) - coordinates(3);
    yrel = (yadj - coordinates(3))/eyerangey;
    Y = yrel*screenh;
    Y = Y;
else
    X = 0;
    Y = 0;
end

if X < plotrange(1)
    X = plotrange(1);
elseif X > plotrange(2)
    X = plotrange(2);
end
if Y < plotrange(3)
    Y = plotrange(3);
elseif Y > plotrange(4)
    Y = plotrange(4);
end

% Plot eye location
    clf
    plot(X,Y,'o');
    axis(plotrange);

    step(hVideoIn, frame); % Output video stream 
%     H = vision.BlockMatcher;
    nFrame = nFrame + 1;
end
%% Clearing Memory
release(hVideoIn); %#ok<UNRCH> % Release all memory and buffer used
release(vidDevice);
% clear all;
clc;