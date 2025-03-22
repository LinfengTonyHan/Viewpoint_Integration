    function corrZ = r2z(corrR)
        corrZ = log(1 + corrR) - log(1 - corrR);
        corrZ = corrZ/2;
    end
