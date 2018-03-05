% RunMe.m

%% Run this file to execute the LaTeX Generation Code on a specified image.
% Follow the comments below for directions to run the code.

clear all; close all;

%% Specify the name of the input file to run the code on. 
%   The function fn_main assumes the files or folders will be in a 
%   subfolder called "Equations." To change this, modify fn_main.m

% For a clean PDF export image (comment out the other one):
 input = 'Clean/demo_equation_hr.jpg';

% For a real-world equation photograph (comment out the other one):
% file = 'Images/eq1_hr.jpg';

%% Runs the entire pipeline on the input image. Outputs a *.tex file in the
%   input image directory with the same name as the input image.
%   Remove the "true" or set to false to process without showing intermediate
%   figures.
%   Add an optional third argument string to specify the name of the output
%   file (without *.tex extension):
%       "test" will place test.tex in the "Equations" folder.
%       "../test" will place test.tex in the current working folder
fn_main(input, true, '../test');