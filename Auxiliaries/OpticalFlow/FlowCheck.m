function flag = FlowCheck( file1, file2 )
%FLOWCHECK Summary of this function goes here
flag = false;
% load the two frames
im1 = im2double(imread(file1));
im2 = im2double(imread(file2));

% set optical flow parameters (see Coarse2FineTwoFrames.m for the definition of the parameters)
alpha = 0.012;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

% this is the core part of calling the mexed dll file for computing optical flow
% it also returns the time that is needed for two-frame estimation
tic;
[vx,vy,warpI2] = Coarse2FineTwoFrames(im1,im2,para);
toc

% visualize flow field
clear flow;
flow(:,:,1) = vx;
flow(:,:,2) = vy;
[imflow, thres] = flowToColor(flow);
% fprintf('max flow: %.4f', thres);
if (thres < 15)
    flag = true;
end
end

