function [ windowPoints ] = PatrickWindow( velo, power, elapsed)

    startPoints = [];
    stopPoints = [];
    currentState = 0;

    for i = 100:length(velo)
        switch currentState
            case 0  %not started
                if power(i) > 100 && velo(i) > 3
                    currentState = 1;
                end
            case 1  %accelerating
                pass = 1;
                for k = i-40:i-25
                    if power(k) < 5 || velo(k) < 3
                        pass = 0;
                    end
                end

                if pass ~= 1
                    continue
                end

                for k = i-20:i+10
                    if power(k) > 5 || velo(k) < 3
                        pass = 0;
                    end
                end

                if pass ~= 1
                    continue
                end

                currentState = 2;
                startPoints = [startPoints; i];
            case 2  %decelerating
                decel = (velo(i + 30) - velo(i+10)) / (elapsed(i + 30) - elapsed(i+10));
                
                if velo(i) < 0.5 || power(i) > 5 || decel < -0.15
                    currentState = 0;
                    stopPoints = [stopPoints; i];
                end
        end    
    end
    
    windowPoints = [];
    
    for i = 1:length(startPoints)
       start = startPoints(i);
       stop = stopPoints(i);
       dt = elapsed(stop) - elapsed(start);
       
       if dt > 20
          windowPoints = [windowPoints; start, stop]; 
       end
    end
end

