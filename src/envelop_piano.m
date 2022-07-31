function y = envelop_piano(t)
   len_t = length(t); 
   T = t(end);
   y = linspace(0,T,len_t);
   % 二次函数的系数
   a = -49/(T^2);
   % 指数函数的系数
   b = 14/(T);
   % 分段函数
   y = ...
       (t>=0 & t<T/7) .* (a.*t.^2+b.*t)+...
       (t>=T/7) .* (exp(-3*(t-T/7)));
end
