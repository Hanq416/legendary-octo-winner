%color noise detect
%Author: Hankun Li
%University of Kansas
%Update: 04/20/2020

I = imread('iso100_0125.JPG');
I1 = imread('iso800.JPG');
% crop area
x = 2234; y = 984;
L1 = 3065 - x; L2 = 1525 - y;
J = imcrop(I,[x y L1 L2]);
J1 = imcrop(I1,[x y L1 L2]);
[v,w] = size(J1);
%pearson correlation of pixel intensity:
pc = corrcoef(imhist(rgb2gray(J)),imhist(rgb2gray(J1)));
fprintf('pearson correlation: %.4f\n', pc(1,2));

%RGB channel chi_sq score:
[r,g,b] = eval_color(J,J1);
fprintf('chisq_score:\nR: %.4f G: %.4f B: %.4f\n', r,g,b);

%RGB numbers of error pixels and error rate.
[r1,g1,b1] = eval_relerror(J,J1);
fprintf('number of error pixel:\nR: %d G: %d B: %d\n', r1(1),g1(1),b1(1));
fprintf('error rate of each channel:\nR: %.6f G: %.6f B: %.6f\n', ...
    r1(2),g1(2),b1(2));


% defective noise (salt&pepper noise) detection
if pc(1,2) < 0.99 % not have a strong relation(noisy)
    map = eval_defective(J1);
    perc = sum(sum(map))/(v*w);
    fprintf('defective noise ratio: %.9f\n', perc);
end
%hankun notes 4/24/2020 
%find reference to proof defective noise is 95%(statistic)