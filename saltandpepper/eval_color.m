function [r,g,b] = eval_color(i,j) %evaluating by chisq
R1 = i(:,:,1);
G1 = i(:,:,2);
B1 = i(:,:,3);
R2 = j(:,:,1);
G2 = j(:,:,2);
B2 = j(:,:,3);
r = eval_chi(R1,R2);
g = eval_chi(G1,G2);
b = eval_chi(B1,B2);
end

function chisq = eval_chi(J1,J2)
[m,n] = size(J1);
[m1,n1] = size(J2);
h1 = imhist(J1)/(m*n);
h2 = imhist(J2)/(m1*n1);
c = zeros(256,1);
for i = 1:256
    c(i,1) = ((h2(i,1) - h1(i,1))^2)/(h1(i,1));
end
c(isnan(c)) = 0;
c(isinf(c)) = 0;
chisq = sum(c);
end
