function output=DrawTally(width, height, alpha)
a = zeros(height, width);

%Define spline of tally mark
y = 1:1:height;
x = ones(length(y),1)*inf;

%Use perturbed-polynomial get tally-mark spline. If spline goes out of
%bounds, try again
while (OutsideWidth(x(1), width) || OutsideWidth(x(end), width))
    c1 = normrnd(0,0.0003);
    c2 = normrnd(0,10^-5);
	x = c1*(y-height/2).^2+ c2*(y-height/2).^3+width/2+1;
end

%Bolden line with thickness function
p1 = floor(height*.7);
p2 = floor(p1+height*.2);
region1 = y<p1;
region2 = (p1<=y) & (y<=p2);
region3 = (p2<y);

r2_val = width*randInRange(0.5, 0.85);
r1_slope=r2_val/p1;
r3_slope = -r2_val/(height-p2);

thickness = zeros(size(y));
thickness(region1)=y(region1)*r1_slope;
thickness(region2) = r2_val;
thickness(region3) = y(region3)*r3_slope -p2*r3_slope+thickness(p2);%very top
for s=1:height
    xl = x(s)-thickness(s)/2;
    xr = x(s)+thickness(s)/2;
    ixl=MatrixRound(xl);
    ixr=MatrixRound(xr);
    a(s, ixl:ixr)=1;
end

% %filter
G = fspecial('gaussian',[5 5],0.7);
B = imfilter(a,G,'same');
trimmedB = B;
if ~(size(B,1) == height) ||~(size(B,2) == width)
    trimmedB = B(1:height, 1:width);
end

%inverse such that 0 = white, 1=black
output = trimmedB;
%output = 1-trimmedB;
end

function retval = OutsideWidth(val, width)
   retval = false;
   if ((val<1) || (val>width))
       retval = true;
   end
end

function x=MatrixRound(xval)
x = round(xval);
if (x<=0)
    x = 1;
end
end


function val = randInRange(low, high)
val = rand(1)*(high-low)+low;
end