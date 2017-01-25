
close all;
clear all;

vid=videoinput('macvideo',1,getResolution());
triggerconfig(vid,'manual');
set(vid,'ReturnedColorSpace','rgb' );
start(vid);

% Take head movement frames 
% Top Right
    input('Position head 1 to 2 feet from screen. Look directly into the webcam. Keep your head pointed forward \nand upright. Then, press the enter key.');
while true
    input('Using only your eyes, look at the top right corner of your computer screen.  Then, press the enter key.\n')
    snapshot = getsnapshot(vid);
    frame = snapshot(160:560, 440:840, :); % Acquire single frame
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
end
release(detector);
end
    
    imshow(frame);
    shg;
    str = input('If you want to use this photo, press enter. If not, type any character and then enter to retake photo.\n', 's');
    if strcmp(str,'')
    coords1 = [centers1 centers2 x y];
    break
    end
end

% Top Left
while true
    input('Using only your eyes, look at the top left corner of your computer screen.  Then, press the enter key.\n')
    snapshot = getsnapshot(vid);
    frame = snapshot(160:560, 440:840, :); % Acquire single frame
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
end
release(detector);
end
    
    imshow(frame);
    shg;
    str = input('If you want to use this photo, press enter. If not, type any character and then enter to retake photo.\n', 's');
    if strcmp(str,'')
    coords2 = [centers1 centers2 x y];
    break
    end
end

% Bottom Left
while true
    input('Using only your eyes, look at the bottom left corner of your computer screen.  Then, press the enter key.\n')
    snapshot = getsnapshot(vid);
    frame = snapshot(160:560, 440:840, :); % Acquire single frame
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
end
release(detector);
end
    
    imshow(frame);
    shg;
    str = input('If you want to use this photo, press enter. If not, type any character and then enter to retake photo.\n', 's');
    if strcmp(str,'')
    coords3 = [centers1 centers2 x y];
    break
    end
end

% Bottom Right
while true
    input('Using only your eyes, look at the bottom right corner of your computer screen.  Then, press the enter key.\n')
    snapshot = getsnapshot(vid);
    frame = snapshot(160:560, 440:840, :); % Acquire single frame
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
end
release(detector);
end
    
    imshow(frame);
    shg;
    str = input('If you want to use this photo, press enter. If not, type any character and then enter to retake photo.\n', 's');
    if strcmp(str,'')
    coords4 = [centers1 centers2 x y];
    break
    end
end

% Adjust and create box for eye movement
coords = double([coords1; coords2; coords3; coords4]);
newcoords = zeros(4, 2);
for i = 1:4
    xdis = coords(i, 3) - coords(i, 1); % Find x distance of eyes
    ydis = coords(i, 4) - coords(i, 2);
    deg1 = atan(ydis/xdis); % Find the angle of the eyes
    
    Coords = [(coords(i,1)+coords(i,3))./2,(coords(i,2)+coords(i,4))./2,coords(i,5:6)];
    relLoc = [Coords(1,1)-Coords(1,3), Coords(1,2)-Coords(1,4)];
    deg2 = atan(relLoc(1)/relLoc(2)); % Find the angle from the nose to the midpoint of the eyes
    deg3 = deg2 + deg1; % Find the angle for adjustment
    hyp = sqrt(relLoc(1)^2 + relLoc(2)^2); % Hypoteneuse
    yadj = hyp*cos(deg3); % Adjusted y
    xadj = hyp*sin(deg3);
    newcoords (i, :) = [xadj, yadj];
end

a = (newcoords(1,1) + newcoords(4,1))/2;
b = (newcoords(2,1) + newcoords(3,1))/2;
c = (newcoords(3,2) + newcoords(4,2))/2;
d = (newcoords(1,2) + newcoords(2,2))/2;
finalcoords = [a,b,c,d];


    fh = fopen('coordinates.txt','wt');
    fprintf(fh, num2str(finalcoords(1,:)));
    
stop(vid);
