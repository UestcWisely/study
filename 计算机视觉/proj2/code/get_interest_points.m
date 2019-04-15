% Local Feature Stencil Code
% CS 143 Computater Vision, Brown U.
% Written by James Hays

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or(b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Placeholder that you can delete. 20 random points

%function:
%       Harris�ǵ���
%ע�⣺
%       matlab�Դ���corner��������ʵ��harris�ǵ��⡣�����ǵ�harris�ǵ�ľ����ԣ���������ʵ�֣��������ѧϰĿ�ģ��˽���������ķ�����
%       �������в�������matlabĬ�ϱ���һ��
%referrence��
%      Chris Harris & Mike Stephens��A COMBINED CORNER AND EDGE DETECTOR
%date:2015-1-11
%author:chenyanan
%ת����ע��������http://blog.csdn.net/u010278305

%��ձ�������ȡͼ��
clear;close all

%����X�����Y������ݶȼ���ƽ��
X=imfilter(image,[-1 0 1]);
X2=X.^2;
Y=imfilter(image,[-1 0 1]');
Y2=Y.^2;
XY=X.*Y;

%���ɸ�˹����ˣ���X2��Y2��XY����ƽ��
h=fspecial('gaussian',[5 1],1.5);
w=h*h';
A=imfilter(X2,w);
B=imfilter(Y2,w);
C=imfilter(XY,w);

%kһ��ȡֵ0.04-0.06
k=0.04;
RMax=0;
size=size(image);
height=size(1);
width=size(2);
R=zeros(height,width);
for h=1:height
    for w=1:width
        %����M����
        M=[A(h,w) C(h,w);C(h,w) B(h,w)];
        %����R�����ж��Ƿ��Ǳ�Ե
        R(h,w)=det(M) - k*(trace(M))^2;
        %���R�����ֵ��֮������ȷ���жϽǵ����ֵ
        if(R(h,w)>RMax)
            RMax=R(h,w);
        end
    end
end

%��Q*RMax��Ϊ��ֵ���ж�һ�����ǲ��ǽǵ�
Q=0.01;
R_corner=(R>=(Q*RMax)).*R;

%Ѱ��3x3�����ڵ����ֵ��ֻ��һ��������8�������Ǹ����������ʱ������Ϊ�õ��ǽǵ�
fun = @(x) max(x(:)); 
%��R��[3,3]����Ѱ�����ֵ
R_localMax = nlfilter(R,[feature_width feature_width],fun); 

%Ѱ�Ҽ�����ǵ���ֵ��������8�����������ֵ��ĵ���Ϊ�ǵ�
%ע�⣺��Ҫ�޳���Ե��
[y,x]=find(R_localMax(2:height-1,2:width-1)==R_corner(2:height-1,2:width-1));





end

