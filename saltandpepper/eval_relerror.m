function [r,g,b] = eval_relerror(i,j)
R1 = i(:,:,1);
G1 = i(:,:,2);
B1 = i(:,:,3);
R2 = j(:,:,1);
G2 = j(:,:,2);
B2 = j(:,:,3);
[rs1,rs2] = eval_hist(R1,R2);
[gs1,gs2] = eval_hist(G1,G2);
[bs1,bs2] = eval_hist(B1,B2);
r = [rs1,rs2];
g = [gs1,gs2];
b = [bs1,bs2];
end

function [score1, score2] = eval_hist(J1,J2)
[v,w] = size(J1);
h1 = imhist(J1);
h2 = imhist(J2);
c1 = zeros(256,1); %to calculate total error pixel (TBD)
c2 = zeros(256,1); %to calculate weighted avg error rate.
%calculate total pixels
psum = v*w;
k1 = 1;
y = 8; %change the interval here
for i = 1:y:256 
    if i ~= 1
        c1(i,1) = abs(sum(h2(k1:i,1)) - sum(h1(k1:i,1)));
        c2(i,1) = (abs(sum(h2(i,1)) - sum(h1(i,1)))/sum(h1(i,1)))*sum(h1(i,1))/psum;
        k1 = i;
    end
end
c1(isnan(c1)) = 0;
c1(isinf(c1)) = 0;
c2(isnan(c2)) = 0;
c2(isinf(c2)) = 0;
score1 = sum(c1)/2;
score2 = sum(c2)/(256/y);
end