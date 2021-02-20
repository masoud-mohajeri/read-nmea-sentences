clc
clear
close all
format longg
%%
file1 = fopen('test3.nmea') ;
gga_l = 0 ;
while feof(file1) == 0
    line = fgetl(file1) ;
    if line(1:6) == '$GPGGA'
        gga_l = gga_l + 1 ;
        delimiter = find(line == ',' ) ;
        gga_data(gga_l,1) = 1 ; % ==> '$GPGGA'
        a = delimiter(1) ;
        utc(gga_l,1:3) = [str2double(line(a+1:a+2)) , str2double(line(a+3:a+4)) , str2double(line(a+5:delimiter(2)-1)) ] ; % [ h , m , s ] 
        a = delimiter(2) ; 
        Latitude(gga_l,1) = dm2degrees([ str2double(line(a+1:a+2)) , str2double(line(a+3:delimiter(3)-1 )) ]) ; 
        if line(delimiter(3)+1) =='S' 
            Latitude(gga_l,1) = Latitude(gga_l,1)*(-1) ;
        end
        a = delimiter(4) ; 
        Longitude(gga_l,1) = dm2degrees([ str2double(line(a+1:a+3)) , str2double(line(a+4:delimiter(5)-1)) ]) ;
        if line(delimiter(5)+1) =='W' 
            Longitude(gga_l,1) = Longitude(gga_l,1)*(-1) ;
        end 
        a = delimiter(6) ;
        Fix_quality(gga_l,1) = str2double(line(a:delimiter(7))) ;
        a = delimiter(7) ;
        tracked_sat(gga_l,1) = str2double(line(a+1:delimiter(8)-1)) ;  
        a = delimiter(8) ;
        hdop(gga_l,1) = str2double(line(a:delimiter(9))) ; 
        a = delimiter(9) ;
        Altitude(gga_l,1) = str2double(line(a:delimiter(10)-1)) ; 
        a = delimiter(11) ;
        hof_geoid(gga_l,1) = str2double(line(a:delimiter(12))) ;  
    elseif line(1:6) == '$GPGSA'
        star = find(line == '*' ) ;
        delimiter = find(line == ',' ) ;
        pdop(gga_l,1) = str2double(line(delimiter(end)+1:star-1)) ;
        vdop(gga_l,1) = str2double(line(delimiter(end-2)+1:delimiter(end-1)-1)) ;
    elseif line(1:6) == '$GPRMC'
        delimiter = find(line == ',' ) ;
        speed_knot(gga_l,1) = str2double(line(delimiter(7):delimiter(8))) ;
        angle(gga_l,1) = str2double(line(delimiter(8):delimiter(9))) ;
        date(gga_l,1) = datetime([ str2double(line(delimiter(9)+5:delimiter(10))),...
                                   str2double(line(delimiter(9)+3:delimiter(9)+4)) ,... 
                                   str2double(line(delimiter(9):delimiter(9)+2)) ]) ;
    elseif line(1:6) == '$GPVTG' % gps some times lc instead gp
        delimiter = find(line == ',' ) ;
        track_madegood(gga_l,1) = str2double(line(delimiter(1):delimiter(2))) ;
        Magnetic_track(gga_l,1) = str2double(line(delimiter(3):delimiter(4))) ;
        speed_knot(gga_l,1) = str2double(line(delimiter(6):delimiter(5))) ;
        speed_kmph(gga_l,1) = str2double(line(delimiter(7):delimiter(8))) ;
    elseif line(1:6) == '$GPGSV' 
        delimiter = find(line == ',' ) ;
        sates_view(gga_l,1) = str2double(line(delimiter(3):delimiter(4))) ;
        sentence_num(gga_l,1) = str2double(line(delimiter(1):delimiter(2))) ;
        t = 1 ;
        for i=1:sentence_num(gga_l,1)
            if i~=1 
              line = fgetl(file1) ;  
              delimiter = find(line == ',' ) ;
            end
            for j=1:((length(delimiter)-4)/4)
                obs(gga_l,1).prn(t,1:4) = [ str2double(line(delimiter(4*j  ):delimiter(4*j+1))) , ...
                                            str2double(line(delimiter(4*j+1):delimiter(4*j+2))) , ...
                                            str2double(line(delimiter(4*j+2):delimiter(4*j+3))) , ...
                                            0 ] ;
                if (delimiter(4*j+3)-delimiter(4*j+4))~=1 
                    obs(gga_l,1).prn(t,4) = str2double(line(delimiter(4*j+3):delimiter(4*j+4))) ;
                end
                t = t + 1 ;
            end           
        end       
%     elseif line(1:6) == '$GPGLL'       
%     elseif line(1:6) == '$GPZDA'       
    end
    clear delimiter
end




















