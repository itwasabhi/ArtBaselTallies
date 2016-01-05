clear all; clc; close all;
% close all;
% figure; 
hold on;
colormap gray;

% Constants
paperHeight = 3000;
paperWidth = 3000;
resolution = 30;
margin = 500;
currentX = margin;               % starting x
currentY = margin;              % starting y

% Seeds
globalAlpha = 1.0;              % location aware parameter

% Height
tallyWidthPercent = .5;          % percentage of resolution
tallyHeightPercent = 10;        % percentage of resolution
tallyHeightVariation = 0.02;    % max variation as percentage of height

% Spacing
xSpacingPercent = 0.1;         % percentage of width
ySpacingPercent = 0.02;         % percentage of width


paper = zeros(paperHeight, paperWidth);

tallyHeight = tallyHeightPercent * resolution;
tallyMinHeight = round(tallyHeight * 0.8);
tallyMaxHeight = round(tallyHeight * 1.2);

tallyWidth = tallyWidthPercent * resolution;

while currentY < paperHeight - margin
    
    currentX = margin;
    totalHeight = 0;
    tallyCount = 0;
    
    while currentX < paperWidth - margin
        
        heightDelta = round(tallyHeightVariation * tallyHeight * randn());
        newTallyHeight = tallyHeight + heightDelta;
        tallyHeight = max(tallyMinHeight, min(tallyMaxHeight, newTallyHeight));
        
        totalHeight = totalHeight + tallyHeight;
        tallyCount = tallyCount + 1;
        
        x = currentX;
        y = currentY;
        
        % Create a mark
        w = round(tallyWidth);
        h = round(tallyHeight);
        
        tally = DrawTally(w, h, 0.05);
        
        % Add the mark to the paper
        paper(y:y + h - 1, x:x + w - 1) = ...
            paper(y:y + h - 1, x:x + w - 1) + tally;
        
        % Change parameters
        deltaX = tallyWidth + xSpacingPercent * tallyWidth * randn();
        currentX = currentX + deltaX;
        
        deltaY = ySpacingPercent * tallyHeight * randn();
        currentY = currentY + deltaY;
        
    end
    
    currentY = currentY + totalHeight / tallyCount;
    
end
paper = 1-paper;
%paper = max(max(paper)) - paper;
imagesc(paper)
imwrite(paper, 'Large.png');



axis equal