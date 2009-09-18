function [l, L_rf, L_sf, L_obs, L_n, N] = retroProjLmk(Rob,Sen,Obs,Opt)

% RETROPROJLMK  Retro project landmark.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


switch Sen.type

    % camera pinHole
    case {'pinHole'}
        % type of lmk to init
        switch Opt.init.initType
            case {'idpPnt'}
                % INIT LMK OF TYPE: Inverse depth point
                [l, L_rf, L_sf, L_sk, L_sd, L_obs, L_n] = ...
                    retroProjIdpPntFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.c, ...
                    Obs.meas.y, ...
                    Opt.init.idpPnt.nonObsMean) ;

                N = Opt.init.idpPnt.nonObsStd^2 ;

            case {'hmgPnt'}
                % INIT LMK OF TYPE: Homogeneous point
                [l, L_rf, L_sf, L_sk, L_sd, L_obs, L_n] = ...
                    retroProjHmgPntFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.c, ...
                    Obs.meas.y, ...
                    Opt.init.idpPnt.nonObsMean) ;

                N = Opt.init.idpPnt.nonObsStd^2 ;

            case {'ahmPnt'}
                % INIT LMK OF TYPE: Homogeneous point
                [l, L_rf, L_sf, L_sk, L_sd, L_obs, L_n] = ...
                    retroProjAhmPntFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.c, ...
                    Obs.meas.y, ...
                    Opt.init.idpPnt.nonObsMean) ;

                N = Opt.init.idpPnt.nonObsStd^2 ;

            case {'plkLin'}
                % INIT LMK OF TYPE: Plucker line
                [hm, HM_obs] = seg2hmgLin(Obs.meas.y);
                [l, L_rf, L_sf, L_sk, L_hm, L_n] = ...
                    retroProjPlkLinFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    hm, ...
                    Opt.init.plkLin.nonObsMean) ;
                L_obs = L_hm*HM_obs;

                N = diag(Opt.init.plkLin.nonObsStd.^2) ;
                
            case 'aplLin'
                % INIT LMK OF TYPE: Anchored Plucker line
                [hm, HM_obs] = seg2hmgLin(Obs.meas.y);
                [l, L_rf, L_sf, L_sk, L_hm, L_n] = ...
                    retroProjAplLinFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    hm, ...
                    Opt.init.plkLin.nonObsMean) ;
                L_obs = L_hm*HM_obs;

                N = diag(Opt.init.plkLin.nonObsStd.^2) ;
                
            case 'idpLin'
                % INIT LMK TYPE: Inverse-depth line.
                nMean = Opt.init.idpPnt.nonObsMean*[1;1]; % non-measured prior
                nStd  = Opt.init.idpPnt.nonObsStd*[1;1];
                
                [l, L_rf, L_sf, L_sk, L_obs, L_n] = ...
                    retroProjIdpLinFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Obs.meas.y, ...
                    nMean) ;

                N = diag(nStd.^2);

            otherwise
                error('??? Unknown landmark type ''%s'' for initialization.',Opt.init.initType)
        end

    otherwise % -- Sen.type
        % Print an error and exit
        error('??? Unknown sensor type ''%s''.',Sen.type);
end % -- Sen.type




% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

