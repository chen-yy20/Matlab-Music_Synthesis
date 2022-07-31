function tunes = my_get_tunes(major)
    C_ori = [261.6,293.6,329.6,349.2,392,440,493.8];
    mid_do = C_ori(1);
    switch (major)
        case 'A'
            mid_do = C_ori(6);
        case 'B'
            mid_do = C_ori(7);
        case 'C'
            mid_do = C_ori(1);
        case 'D'
            mid_do = C_ori(2);
        case 'E'
            mid_do = C_ori(3);        
        case 'F'
            mid_do = C_ori(4);
        case 'G'
            mid_do = C_ori(5);
        otherwise
            error('Error: The parameter major is invalid!');
    end
    major_dis = [2,2,1,2,2,2];
    mid_tunes = [mid_do,zeros(1,6)];
    for i = 2:7
        mid_tunes(i) = mid_tunes(i-1)*2^(major_dis(i-1)/12);
    end

    tunes = [mid_tunes./2;mid_tunes;mid_tunes.*2];
    tunes = reshape(tunes',[1,21]);
    tunes = [tunes,0];

end