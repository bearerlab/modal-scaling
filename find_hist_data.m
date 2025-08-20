function [hist_y, hist_x] = find_hist_data(a, nbins, delta)

 a(isnan(a)) = 0;
    [no,x] = hist(a(:), nbins);
    [peaks,troughs] = peakdet(no, delta);
    
    % whether data is ok..
    numpeak = size(peaks, 1);
    if ( numpeak < 2)
        fprintf('Data supposed to have 2 peaks. One near zero and one normal image peak. Cant find. Quitting');
        return
    end
    
    if ( numpeak == 4 )
        peak1 = peaks(3,1);
        peak2 = peaks(4,1);
        trough1 = troughs(3,1);
    elseif ( numpeak == 3 )
        peak1 = peaks(2,1);
        peak2 = peaks(3,1);
        trough1 = troughs(2,1);
    else
        peak1 = peaks(1,1);
        peak2 = peaks(2,1);
        trough1 = troughs(1,1);
    end
    
    if peak1 < trough1 && trough1 < peak2
        hist_y = no(trough1:end);
        hist_x = x(trough1:end);
    else
        fprintf('poorly formed data. Hopefully will be supported in future versions');
        return
    end