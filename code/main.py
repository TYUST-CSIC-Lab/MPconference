#coding:utf-8
import sys
import random

outfile = open("result.txt",'w')
alpah=0.001
#M=[5,2,1,9,5,2]
def Q_B(x):
    return -8.068*10**(-14)*x**4+7.65*10**(-10)*x**3-2.586*10**(-6)*x**2+0.004013*x+1.559
#目标1:计算客户端的带宽消耗比
def band_client(N,X,Y):
    Band_C=0
    for i in range(N):
        Band_c=0
        index=[3*i,3*i+1,3*i+2]
        Band_c+=X[index[0]]+X[index[1]]+X[index[2]]
        for j in range(N):
            if j!=i:
                Band_c+=(X[3*j]+X[3*j+1]+X[3*j+2])/3
        Band_c/=Y[i]*1024#计算每个客户端的带宽消耗比
        Band_C+=Band_c
    Band_C/=N
    return Band_C
#目标2：计算视频质量
def quality(N,X):
    Quality=0
    for i in range(N):
        Quality+=(Q_B(X[3*i]/3)+Q_B(X[3*i+1]+Q_B(4*X[3*i+2]))/3)
    return Quality/N

# #目标3:计算码率差
def dis(N,X):
    Dis=0
    for i in range(N):
        Dis+=X[3*i]/(X[3*i+1])+X[3*i+1]/(X[3*i+2])-2
    Dis/=N
    return Dis

# #目标4：计算服务端的上行带宽消耗
def band_server(N,X):
    Band_s=0
    for i in range(N):
        Band_s+=X[3*i]
    return Band_s
#
def Objectives(f):
    Pop=open(f,"r").readlines()
    #将归一化的码率复原成原码率
    #将归一化的决策变量还原成实际值
    F=[]
    N=int(len(Pop[0].split(" "))/3)#参加会议客户端数量
    Band_all=[]
    for k in range(N):
        band=random.randint(10,20)
        Band_all.append(band)
    #对于种群中的每一个个体计算目标函数值
    for i in range(len(Pop)):
        pop=Pop[i].split(" ")
        pop=list(map(float,pop))#将字符串转化成数字
        for i in range(len(pop)):
            if i%3==0:#1280*720码率
                pop[i]=7692*pop[i]+500
            if i%3==1:#640*480码率
                pop[i]=3798*pop[i]+250
            if i%3==2:#320*240码率
                pop[i]=964*pop[i]+60
        B_c=band_client(N,pop,Band_all)
        Quality=quality(N,pop)
        Dis=dis(N,pop)
        B_s=band_server(N,pop)
        f=[B_c,Quality,Dis,B_s]
        for num in f:
            outfile.write(str(num) + '\t')
        outfile.write('\n')
        F.append(f)

    return F






# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # a="C:/Users/27641/Desktop/优化算法平台/多目标第一版/Problems/DTLZ/Pop.txt"
    #
    # result=Objectives(a)
    # print(result)
    if len(sys.argv) < 2:
       print('No file specified.')
       sys.exit()
    else:
        f2 = Objectives(sys.argv[1])
        print(f2)


# See PyCharm help at https://www.jetbrains.com/help/pycharm/
