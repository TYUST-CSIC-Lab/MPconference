function NSGAIII(Global)
% <algorithm> <H-N>
% An Evolutionary Many-Objective Optimization Algorithm Using
% Reference-point Based Non-dominated Sorting Approach, Part I: Solving
% Problems with Box Constraints

%--------------------------------------------------------------------------
% The copyright of the PlatEMO belongs to the BIMK Group. You are free to
% use the PlatEMO for research purposes. All publications which use this
% platform or any code in the platform should acknowledge the use of
% "PlatEMO" and reference "Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu
% Jin, PlatEMO: A MATLAB Platform for Evolutionary Multi-Objective
% Optimization, 2016".
%--------------------------------------------------------------------------

% Copyright (c) 2016-2017 BIMK Group

    %% Generate the reference points and random population
    [Z,Global.N] = UniformPoint(Global.N,Global.M);%Z为参考点
    Population   = Global.Initialization();
    Zmin         = min(Population(all(Population.cons<=0,2)).objs,[],1);

    %% Optimization
    while Global.NotTermination(Population)
        MatingPool = TournamentSelection(2,Global.N,sum(max(0,Population.cons),2));
        Offspring  = Global.Variation(Population(MatingPool));
        Zmin       = min([Zmin;Offspring(all(Offspring.cons<=0,2)).objs],[],1);%理想点
        Population = EnvironmentalSelection([Population,Offspring],Global.N,Z,Zmin);
    end
end