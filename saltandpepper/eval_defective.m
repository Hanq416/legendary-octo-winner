function map = eval_defective(I) %evaluating defective noise
t = rgb2gray(I);
Ib = imgaussfilt(t,2);
raw = abs(double(t)-double(Ib));
resp = reshape(raw,[],1);
th = prctile(resp,99.5);
y = imbinarize(raw, th);
%edge area detection
blur = imgaussfilt(t,4);
BW1 = edge(blur,'canny');
BW2 = imdilate(BW1, strel('disk',4));
%get defective noise map
map = imbinarize((y - BW2),0);
end