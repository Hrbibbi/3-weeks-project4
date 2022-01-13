function lim_signal =  signal_limited(signal,frac,options)
arguments
    signal double
    frac double
    options char = 'middle'
end
switch options
    case 'middle'
        lim_signal=zeros(size(signal));
        signal=fftshift(signal);
        C=round(length(signal)/2);
        length(signal);
        L=floor( (length(signal)*sqrt(frac))/2 );
        lim_signal(C-L:C+L,C-L:C+L)=signal(C-L:C+L,C-L:C+L);
        lim_signal=fftshift(lim_signal);
    case 'random'
        lim_signal=zeros(size(signal));
        K=rand(size(signal));
        i=find(K>=frac);
        lim_signal(i)=signal(i);

end

end