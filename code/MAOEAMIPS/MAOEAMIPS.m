function MAOEAMIPS(Global)
% <algorithm> <H-N>

    %% Parameter setting
    [K,L,alpha,delta] = Global.ParameterSet(5,3,0.4,0.1);
    %% Generate random population
    Population = Global.Initialization();
     Zmin       = min(Population.objs,[],1);%添加
%     Fitness    = CalFitness(Population.objs);
    Archive    = UpdateArchive(Population(NDSort(Population.objs,1)==1),[],Global.N);%初始化外部解集

    %% Optimization
    while Global.NotTermination(Archive)%可以设置迭代
%%使用动态概率进行
%         MatingPool1 = MatingSelection1(Population.objs,Zmin1);
%         Offspring1  = Global.Variation(Population(MatingPool1));
%         Zmin1       = min([Zmin1;Offspring1.objs],[],1);
%         Population1 = MatingSelection11([Population,Offspring1],Zmin1,0,Global.N); 
% 
%         MatingPool2 = TournamentSelection(2,Global.N,min(TchebychevDistance(Population.objs,R),[],2));
%         Offspring2  = Global.Variation(Population(MatingPool2));
%      	R          = GenerateRefPoints([Population,Offspring2],delta*(max(Population.objs,[],1)-min(Population.objs,[],1)),alpha,Global.N);
%         Population2 = MatingSelection2([Population,Offspring2],R,Global.N);  
%         
%    
%         MatingPool4 = TournamentSelection(2,Global.N,Fitness);
%         Offspring4  = Global.Variation(Population(MatingPool4));
%         [Population3,Fitness] = MatingSelection4([Population,Offspring4],Global.N);
% 
% 
%  
%               Population_max    = mean(CalBFE(Population));
%               [n1_BFE,~] = size(find(CalBFE(Population1)>Population_max));
%               [n2_BFE,~] = size(find(CalBFE(Population2)>Population_max));
%               [n3_BFE,~] = size(find(CalBFE(Population3)>Population_max));
%               if (n1_BFE>n2_BFE) && (n1_BFE>n3_BFE)
%                   if p1>0.9
%                       p1 = 0.9;
%                       p2 = 0.05;
%                       p3 = 0.05;
%                   elseif  p2<0.1 
%                       p2 = 0.05;
%                   elseif p3<0.1 
%                       p3 = 0.05; 
%                   else
%                       p1 = p1+0.1;
%                       p2 = p2-0.05;
%                       p3 = p3-0.05;
%                  end
%               end
%               if (n2_BFE>n1_BFE) && (n2_BFE>n3_BFE)
%                   if p2>0.9
%                       p2 = 0.9;
%                       p1 = 0.05;
%                       p3 = 0.05;
%                   elseif p1<0.1 
%                       p1 = 0.05;
%                   elseif p3<0.1 
%                       p3 = 0.05; 
%                   else
%                       p1 = p1-0.05;
%                       p2 = p2+0.1;
%                       p3 = p3-0.05;
%                   end
%               end
%               if (n3_BFE>n1_BFE) && (n3_BFE>n2_BFE)
%                   if p3>0.9
%                       p1 = 0.05;
%                       p2 = 0.05;
%                       p3 = 0.9;
%                   elseif p1<0.1 
%                       p1 = 0.05;
%                     
%                   elseif p2<0.1 
%                       p2 = 0.05; 
%                   else
%                   p1 = p1-0.05;
%                   p2 = p2-0.05;
%                   p3 = p3+0.1;
%                   end
%               end
%          end
                     
        
        %选择集成,每个算子被选择的概率为1/3
        a=rand;       
        %选择算子1：成绩标量函数ASF和角度信息指标  MAOEA-csss
        if a<1/3
            if Global.gen==1
             Zmin       = min(Population.objs,[],1); 
            else
             Zmin       = min(Population.objs,[],1); 
             Offspring1 = Archive(randi(ceil(length(Archive)/10),1,Global.N));
             Zmin       = min([Zmin;Offspring1.objs],[],1);
            end  
        MatingPool1 = MatingSelection1(Population.objs,Zmin);
        Offspring1  = Global.Variation(Population(MatingPool1));
        Zmin       = min([Zmin;Offspring1.objs],[],1);
        Population = MatingSelection11([Population,Offspring1],Zmin,0,Global.N);      %css environment    
        end
      
        %选择算子2：BFE适应值
        if (a>=1/3)&&(a<2/3)
          bfe=CalBFE(Population);%计算种群的BFE值
          MatingPool = TournamentSelection(2,Global.N,bfe);
          Offspring2  = Global.Variation(Population(MatingPool));
          Zmin       = min([Zmin;Offspring2(all(Offspring2.cons<=0,2)).objs],[],1);
          Population = MatingSelection11([Population,Offspring2],Zmin,0,Global.N);
        end
%          if (a>=1/3)&&(a<2/3)
%           MatingPool = TournamentSelection(2,Global.N,sum(max(0,Population.cons),2));
%           Offspring2  = Global.Variation(Population(MatingPool));
%           Zmin       = min([Zmin;Offspring2(all(Offspring2.cons<=0,2)).objs],[],1);
%           Population = MatingSelection11([Population,Offspring2],Zmin,0,Global.N);
%          
%          end
%         if (a>=1/3)&&(a<2/3)
%             if Global.gen==1
%                 R  = GenerateRefPoints(Population,delta*(max(Population.objs,[],1)-min(Population.objs,[],1)),alpha,Global.N);
%             else
%                 Offspring2 = Archive(randi(ceil(length(Archive)/10),1,Global.N));
%       	        R  = GenerateRefPoints([Population,Offspring2],delta*(max(Population.objs,[],1)-min(Population.objs,[],1)),alpha,Global.N);
%             end              
%         MatingPool2 = TournamentSelection(2,Global.N,min(TchebychevDistance(Population.objs,R),[],2));
%         Offspring2  = Global.Variation(Population(MatingPool2));
%      	R          = GenerateRefPoints([Population,Offspring2],delta*(max(Population.objs,[],1)-min(Population.objs,[],1)),alpha,Global.N);
%         Population = MatingSelection2([Population,Offspring2],R,Global.N);        
%         end
        
%         %选择算子3：directional density function包含（切比雪夫函数and favorable weight）,参考MaOEA-DDFC
%         if (a>=0.5)&&(a<0.75)
%         MatingPool = MatingSelection3(Population.objs,Zmin);
%         Offspring3 = Global.Variation(Population(MatingPool));
%         Zmin       = min([Zmin;Offspring3.objs],[],1);        
%         Population = MatingSelection33([Population,Offspring3],Zmin,Global.N,K,L);        
%         end
        
        %选择算子4：SDE距离 
%         if a>=2/3
%         Fitness    = CalFitness(Population.objs);
%         MatingPool4 = TournamentSelection(2,Global.N,Fitness);
%         Offspring4  = Global.Variation(Population(MatingPool4));
% %         [Population,Fitness] = MatingSelection4([Population,Offspring4],Global.N);
%         Population = MatingSelection4([Population,Offspring4],Global.N);
%         end
%         
        
%         %欧氏距离
%         MatingPool3 = MatingSelection3(Population.objs,20);
%         Offspring  = Global.Variation(Population([1:Global.N,MatingPool3]),Global.N);

        if a>=2/3% MAOEA-DDFC
          MatingPool3 = MatingSelection3(Population.objs,Zmin);
          Offspring3  = Global.Variation(Population(MatingPool3));
          Zmin       = min([Zmin;Offspring3.objs],[],1);
          Population = MatingSelection11([Population,Offspring3],Zmin,0,Global.N);
        end
%              if a>=2/3% MAOEA-DDFC
%           MatingPool3 = MatingSelection3(Population.objs,Zmin);
%           Offspring3  = Global.Variation(Population(MatingPool3));
%           Zmin       = min([Zmin;Offspring3.objs],[],1);
%           Population = EnvironmentalSelection([Population,Offspring3],Zmin,Global.N,K,L);
%         end
        %NSGA3基于
%         MatingPool = TournamentSelection(2,Global.N,sum(max(0,Population.cons),2));
%         Offspring  = Global.Variation(Population(MatingPool));
%         Zmin       = min([Zmin;Offspring(all(Offspring.cons<=0,2)).objs],[],1);
%         Population = EnvironmentalSelection([Population,Offspring],Global.N,Z,Zmin);
        
        
        Archive    = UpdateArchive(Archive,Population,Global.N);
        S          = Global.Variation(Archive([1:length(Archive),randi(ceil(length(Archive)/2),1,length(Archive))]),length(Archive),@EAreal);
        Archive    = UpdateArchive(Archive,S,Global.N);
    end
end