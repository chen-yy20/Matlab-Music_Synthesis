function y = envelop(t)
   len_t = length(t); 
   T = t(end);
   y = linspace(0,T,len_t);
   % 二次函数的系数
   a = -49/T^2;
   b = 35/(2*T);
   % 三角函数的系数
   c = (7*pi)/(3*1.4*T);
   % 分段函数
   y = ...
       (t>=0 & t<2*T/7) .* (a.*t.^2+b.*t)+...
       (t>=2*T/7 & t<4*T/7).*(1)+...
       (t>=4*T/7) .* (0.5.*cos(c.*(t-(4*T/7)))+0.5);
end
