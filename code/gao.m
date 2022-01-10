function varargout =gao(Operation,Global,input)
% <problem> <DTLZ>
% Scalable Test Problems for Evolutionary Multi-Objective Optimization
% operator --- EAreal

%--------------------------------------------------------------------------
% Copyright (c) 2016-2017 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB Platform
% for Evolutionary Multi-Objective Optimization [Educational Forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    switch Operation
        case 'init'
            Global.M        = 4;
            Global.D        = 150;
            Global.lower   = zeros(1,Global.D);
            Global.upper    = ones(1,Global.D);
            Global.operator = @EAreal;        
            %PopDec = importdata('PopDec.txt');
            
            PopDec = 2*rand(input,150)-1;
            varargout = {PopDec};
       case 'value'
            PopDec = input;
            [N,D]  = size(PopDec);
            M      = Global.M;
            %% 目标函数计算                    
            
            if count(py.sys.path,'') == 0
                insert(py.sys.path,int32(0),'C:\Users\27641\Desktop\优化算法平台\多目标第一版\Problems\DTLZ')
            end
           [N,D] = size(input);
           dlmwrite('C:\Users\27641\Desktop\优化算法平台\多目标第一版\Problems\DTLZ\Pop.txt',  PopDec, 'delimiter', ' ', 'newline', 'pc');
           data=importdata('C:\Users\27641\Desktop\优化算法平台\多目标第一版\Problems\DTLZ\Pop.txt')
           [m,l] = size(data);
           %data(21,1) = Global.gen;
           [b,a] = size(data);
           dlmwrite('C:\Users\27641\Desktop\优化算法平台\多目标第一版\Problems\DTLZ\Pop.txt',  data, 'delimiter', ' ', 'newline', 'pc');
           result1 = python1('C:\Users\27641\Desktop\优化算法平台\多目标第一版\Problems\DTLZ\Pop.txt');
           result1
           result=importdata('C:\Users\27641\Desktop\优化算法平台\多目标第一版\result.txt');
           result
           for i = 1:N
                Fitness1(i,:) =result(i,1);
                Fitness_1(i,:) = result(i,1);
                Fitness2(i,:) = 1/result(i,2);
                Fitness_2(i,:) = result(i,2);
                Fitness3(i,:) = 1/result(i,3);
                Fitness_3(i,:) = result(i,3); 
                Fitness4(i,:) = result(i,4);
                Fitness_4(i,:) = result(i,4);
            
           end
           

           
             %% 总结 
           F1 = [Fitness_1,Fitness_2,Fitness_3,Fitness_4]
           %PopObj = [Fitness1,Fitness2,Fitness3,Fitness4]
           %F2 = [Fitness1,Fitness2,Fitness3,Fitness4];  %原始数据
           %归一化
           [m1,m_index1] = max(Fitness1);
           [n1,n_index1] = min(Fitness1);
           [m2,m_index2] = max(Fitness2);
           [n2,n_index2] = min(Fitness2);
           [m3,m_index3] = max(Fitness3);
           [n3,n_index3] = min(Fitness3);
           [m4,m_index4] = max(Fitness4);
           [n4,n_index4] = min(Fitness4);
           
           for i = 1:N
               Fitness1(i,:) = (Fitness1(i,:)-n1)/(m1-n1);
               Fitness2(i,:) = (Fitness2(i,:)-n2)/(m2-n2);
               Fitness3(i,:) = (Fitness3(i,:)-n3)/(m3-n3);
               Fitness4(i,:) = (Fitness4(i,:)-n4)/(m4-n4);
             
           end          
           PopObj=[Fitness1,Fitness2,Fitness3,Fitness4]  %归一化
           if Global.gen ==Global.maxgen-1
               PopObj
               PopDec
%            if mod(Global.gen,10) ==0
%                 PopDec
           end
           PopCon = [];
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f = UniformPoint(input,Global.M)/2;
            varargout = {f};
    end
end