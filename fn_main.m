function [ eq_string ] = fn_main( fileName, showFigs, outputName )
% fn_main Generate a .tex file of LaTeX code for equation in input image
%       This function will generate the LaTeX code to reproduce the equation in
%       the input image. The input image is assumed to be a jpg of a single
%       equation (black on white) without other text. Can handle skew and
%       uneven lighting.
%
%   fileName: file name to jpg input image, assume in subfolder 'Equations'
%   showFigs: Set true to show all figure outputs of process. default is false
%   outputName: Optional filename for output .tex file (no extension). If
%       none specified, will use input file name.
%
%   eq_string: Returns the string of the equation LaTeX code.

if nargin == 1
    showFigs = false;
    outputName = fileName(1:end-4);
elseif nargin == 2
    outputName = fileName(1:end-4);
end

%% Load Template Character Template Data and Identity Info
% If not available, see importCharacterTemplates.m to create
load('red_charPalette_withText_demo2.mat');
load('red_charPalette_Classifier_demo2.mat');

%% Read in desired equation
dir = strcat(pwd,'/Equations/');
eq = imread(strcat(dir,fileName));
if(showFigs)
    figure(1);
    imshow(eq);
end

%% Optimize page and binarize
eq_bin = fn_lighting_compensation(eq);
if(showFigs)
    figure(2);
    imshow(eq_bin);
end

[eq_deskew, ~] = fn_deskew2(eq_bin,true,true, 5);

if(showFigs)
    figure(3);
    imshow(eq_deskew);
end

%% Segment Equation Characters and Create Identifier
if(showFigs)
    eq_chars = fn_segment(eq_deskew,true,4);
else
    eq_chars = fn_segment(eq_deskew);
end
for i = 1:length(eq_chars)
   eq_chars(i).ident = fn_createIdent(eq_chars(i).img); 
end

%% Match Characters (pass in struct of segmented chars and related info. 
for i = 1:length(eq_chars)
    idx_matched = knnsearch(X_orig(:,1:length(chars(1).ident)),...
            eq_chars(i).ident,'distance','cityblock');
    % Set the matched character value
    eq_chars(i).char = chars(X_orig(idx_matched,end)).char;
    
    % Code to show input characters and their determined matches
    if(showFigs)
        figure(6);
        subplot(2,length(eq_chars),i);
        imshow(eq_chars(i).img);
        title('Input');
        subplot(2,length(eq_chars),i+length(eq_chars));
        imshow(chars(X_orig(idx_matched,end)).img);
        if(eq_chars(i).char(1) == '\')
            printChar = strcat('\',eq_chars(i).char);
        else
           printChar = eq_chars(i).char;
        end
        str = sprintf('Match: %s',printChar);
        title(str);
    end
end

%% Pass struct of segmented characters (eq_chars) with matched character 
% data to equation creator

EqStruct.characters = eq_chars;
eq_string = fn_assemble_eq(EqStruct);

%% Output LaTeX Code
writeTex(eq_string, strcat(dir,outputName));

end

