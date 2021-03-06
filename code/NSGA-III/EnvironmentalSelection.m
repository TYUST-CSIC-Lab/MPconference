function Population = EnvironmentalSelection(Population,N,Z,Zmin)
% The environmental selection of NSGA-III

%--------------------------------------------------------------------------
% The copyright of the PlatEMO belongs to the BIMK Group. You are free to
% use the PlatEMO for research purposes. All publications which use this
% platform or any code in the platform should acknowledge the use of
% "PlatEMO" and reference "Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu
% Jin, PlatEMO: A MATLAB Platform for Evolutionary Multi-Objective
% Optimization, 2016".
%--------------------------------------------------------------------------

% Copyright (c) 2016-2017 BIMK Group

    CV = sum(max(0,Population.cons),2);
    if sum(CV==0) > N
        %% Selection among feasible solutions
        Population = Population(CV==0);
        % Non-dominated sorting
        [FrontNo,MaxFNo] = NDSort(Population.objs,N);
        Next = false(1,length(FrontNo));
        Next(FrontNo<MaxFNo) = true;
        % Select the solutions in the last front
        Last   = find(FrontNo==MaxFNo);
        Choose = LastSelection(Population(Next).objs,Population(Last).objs,N-sum(Next),Z,Zmin);
        Next(Last(Choose)) = true;
        Population = Population(Next);
    else
        %% Selection including infeasible solutions
        [~,rank]   = sort(CV);
        Population = Population(rank(1:N));
    end
end

function Choose = LastSelection(PopObj1,PopObj2,K,Z,Zmin)
% Select part of the solutions in the last front

    PopObj = [PopObj1;PopObj2];
    [N,M]  = size(PopObj);
    N1     = size(PopObj1,1);
    N2     = size(PopObj2,1);
    NZ     = size(Z,1);%参考点的个数

    %% Normalization
    % Detect the extreme points
    Extreme = zeros(1,M);
    w       = zeros(M)+1e-6+eye(M);
    for i = 1 : M
        [~,Extreme(i)] = min(max(PopObj./repmat(w(i,:),N,1),[],2));
    end
    % Calculate the intercepts of the hyperplane constructed by the extreme
    % points and the axes
    Hyperplane = PopObj(Extreme,:)\ones(M,1);
    a = 1./Hyperplane;%a为超平面在目标轴上的截距
    if any(isnan(a))
        a = max(PopObj,[],1)';
    end
    % Normalization，目标函数转化为fx-zmin,
    PopObj = (PopObj-repmat(Zmin,N,1))./repmat(a'-Zmin,N,1);
    
    %% Associate each solution with one reference point
    % Calculate the distance of each solution to each reference vector
    Cosine   = 1 - pdist2(PopObj,Z,'cosine');%Z为参考点，“cosine"表示1-点间夹角的余弦
    Distance = repmat(sqrt(sum(PopObj.^2,2)),1,NZ).*sqrt(1-Cosine.^2);%个体到原点的距离X夹角的正弦值
    % Associate each solution with its nearest reference point
    [d,pi] = min(Distance',[],1);

    %% Calculate the number of associated solutions except for the last front of each reference point
    rho = zeros(1,NZ);
    if N1 > 0
        temp = tabulate(pi(1:N1));
        rho(temp(:,1)) = temp(:,2);
    end
    
    %% Environmental selection
    Choose  = false(1,N2);
    Zchoose = true(1,NZ);%选择的参考点置1
    % Select K solutions one by one
    while sum(Choose) < K
        % Select the least crowded reference point
        Temp = find(Zchoose);
        Jmin = find(rho(Temp)==min(rho(Temp)));
        j    = Temp(Jmin(randi(length(Jmin))));
        I    = find(Choose==0 & pi(N1+1:end)==j);
        % Then select one solution associated with this reference point
        if ~isempty(I)
            if rho(j) == 0
                [~,s] = min(d(N1+I));
            else
                s = randi(length(I));
            end
            Choose(I(s)) = true;
            rho(j) = rho(j) + 1;
        else
            Zchoose(j) = false;
        end
    end
end