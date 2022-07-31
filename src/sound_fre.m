function sound_fre(f)
t = linspace(0,1,8000)';
wave = 0.3*sin(2*pi*f*t);
sound(wave,8000);
end