function ab = hist_costfn(a_b,tx, ty, x, y)
a = a_b(1);
b = a_b(2);

xi = x .* a;
yi = interp1(x, y, xi);
yi(isnan(yi)) = 0;


ab = ty - b .* yi;