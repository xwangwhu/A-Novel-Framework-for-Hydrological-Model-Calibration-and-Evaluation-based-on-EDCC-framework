import seaborn as sns
import pandas as pd 
import matplotlib.pyplot as plt

sns.set_style("white")
sns.set_context("paper")

sheetname_seg = ['Whole','Cali','Calidemo','Veri','Veridemo']
for k in range(len(sheetname_seg)):
    Sheetname_seg = sheetname_seg[k]
    seg = pd.read_excel('01 Data/04 Segments.xlsx',sheet_name=Sheetname_seg)

    Sheetname_flux = 'segment'
    df = pd.read_excel('01 Data/04 Segments.xlsx',sheet_name=Sheetname_flux)
     
    Color = ["#3A6D81","#DDDCDB","#234951","#5EA9BD","#BADAE1"]        
    #    parameters=['XHuz','XCuz','Xq1','Xq2','Xq3','Xs']
    #    parameters=['AE','OV','Qq','Qs','Q']
    parameters=['type0','type1','type2','type3','type4']
    
    fig,axes = plt.subplots(5,1,sharex=True)     
    for i in range(len(parameters)):
        axes[i]=plt.subplot(5,1,i+1)            
    
        for j in range(len(seg.seg1)):
            left = seg.seg1[j]-1;
            right = seg.seg2[j]-1;    
            COLOR = Color[seg.type[j]-1]
            sns.lineplot(x=df.num[left:right],y=parameters[i],data=df[left:right], color = COLOR)                          
        
        if i==4:
    
            for j in range(len(seg.seg1)):
                left = seg.seg1[j]-1;
                right = seg.seg2[j]-1;    
                COLOR = Color[seg.type[j]-1]
                sns.lineplot(x=df.num[left:right],y=parameters[i],data=df[left:right], color = COLOR)                  
            
        else: 
            plt.xticks([])    
            
        plt.xlabel('')
        plt.ylabel('')    
        plt.ylim(0, 5)
        sns.despine(bottom=True)
        axes[i].set_ylabel(parameters[i])
        axes[i].get_yaxis().set_label_coords(-0.08,0.5) # -0.07(6,1) -0.12(3,2)    
    
    outputname = ''.join(["01 Data/segment/",Sheetname_flux,'-',Sheetname_seg,'.png'])
    plt.savefig(outputname, dpi=600)

