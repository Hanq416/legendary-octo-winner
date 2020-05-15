function [upr, upl, lowr, lowl] = img_split(img)
J = rgb2gray(img);
[v, w] = size(J);
upr = imcrop(img, [1 1 (w/2)-1 (v/2)-1]);
upl = imcrop(img, [w/2 1 w-1 (v/2)-1]);
lowr = imcrop(img, [1 v/2 (w/2)-1 v-1]);
lowl = imcrop(img, [w/2 v/2 (w/2)-1 v/2-1]);
end