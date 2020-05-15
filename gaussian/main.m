%gaussian noise estimation
img = imread('IMG_0063.JPG');
mskflg = 0;

if mskflg
    [nlevel, th] = NoiseLevel(noise); %#ok<UNRCH>
    msk = WeakTextureMask( noise, th );
    imwrite(uint8(msk*255), sprintf('msk_test.png'));
end

%final test
t1_crop = imcrop(img,[2854 1182 900 800]);
test_noise = NoiseLevel(double(t1_crop));
display(test_noise);
%display the normal distribution of noise
dis_noise = normrnd(0,mean(test_noise),[1,20000]);
figure; histogram(dis_noise,200);
