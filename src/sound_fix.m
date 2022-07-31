function idx = sound_fix(i)
% 此函数用于人耳主音修正，属于偷鸡摸狗行为
switch i
     case 8 
         idx = 2;
     case 10
         idx = 7;
     case 12
         idx = 2;
     case 14
         idx = 2;
     case 17
         idx = 2;
     case 20
         idx = 3;
     case 21
         idx = 3;
     case 22
         idx = 2;
     case 24
         idx = 3;
    otherwise
        idx = 0;

end
end