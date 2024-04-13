import seaborn as sns
import pandas as pd 
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

sns.set_style("white")
sns.set_context("paper")

colormap = [["#A5A5A5","#B3DAE1","#286D82","#44A9BE"],
            ["#A5A5A5","#B3DAE1","#286D82","#44A9BE"],
            ["#A5A5A5","#B3DAE1","#286D82","#44A9BE"],  
            ["#A5A5A5","#FFFFFF","#FFFFFF","#FFFFFF"],           
            ["#FFFFFF","#B3DAE1","#FFFFFF","#FFFFFF"],
            ["#FFFFFF","#FFFFFF","#286D82","#FFFFFF"],  
            ["#FFFFFF","#FFFFFF","#FFFFFF","#44A9BE"],
            ["#A5A5A5","#B3DAE1","#286D82","#44A9BE"]]

sheetname_seg = ['Whole','Cali','Calidemo','Veri','Veridemo']
#for k in range(len(sheetname_seg)):
Sheetname_seg = sheetname_seg[0]
seg = pd.read_excel('C:/Users/Lan Tian/Desktop/03 Article/01 Codes/05 Results analysis of different calibration schemes/01 Data/04 Segments.xlsx',sheetname=Sheetname_seg)

sheetname_flux = ['scheme0','scheme1','scheme2','scheme3-1','scheme3-2','scheme3-3','scheme3-4','scheme3-5']
origin = pd.read_excel('C:/Users/Lan Tian/Desktop/03 Article/01 Codes/05 Results analysis of different calibration schemes/01 Data/03 fluxes.xlsx',sheetname='scheme0')

#for j in range(len(sheetname_flux)):
Sheetname_flux = sheetname_flux[0]
df = pd.read_excel('C:/Users/Lan Tian/Desktop/03 Article/01 Codes/05 Results analysis of different calibration schemes/01 Data/03 fluxes.xlsx',sheetname=Sheetname_flux)
 
Color = colormap[0]          
#    parameters=['XHuz','XCuz','Xq1','Xq2','Xq3','Xs']
parameters=['AE','OV','Qq','Qs','Qsim']

fig,axes = plt.subplots(5,1,sharex=True)     
for i in range(len(parameters)):
    axes[i]=plt.subplot(5,1,i+1)            

    for j in range(len(seg.seg1)):
        left = seg.seg1[j]-1;
        right = seg.seg2[j]-1;    
        COLOR = Color[seg.type[j]-1]
        axes[i].plot(x=df.num[left:right],y=eval(''.join(['df.', parameters[i],'[left:right]'])), color = COLOR)  
        axes[i].plot(x=origin.num[left:right],y=eval(''.join(['origin.', parameters[i],'[left:right]'])),color = "#A5A5A5",linewidth=0.3)
                              
         
    if i==4:

        for j in range(len(seg.seg1)):
            left = seg.seg1[j]-1;
            right = seg.seg2[j]-1;    
            COLOR = Color[seg.type[j]-1]                                                       
            axes[i].plot(x=df.num[left:right],y=eval(''.join(['df.', parameters[i],'[left:right]'])), color = COLOR)                      
            axes[i].plot(x=origin.num[left:right],y=eval(''.join(['origin.', parameters[i],'[left:right]'])), color = "#A5A5A5",linewidth=0.3)
            axes[i].plot(x=origin.num[left:right],y=origin.Qobs[left:right], color = "#C25539",linewidth=0.3) 
#            axes[i].xaxis.set_major_locator(plt.NullLocator())
            
            
                           
             
    else: 
        plt.xticks([])

        
        
#    axes[i].yaxis.set_major_locator(plt.NullLocator())
#    axes[i].xaxis.set_major_formatter(plt.NullFormatter())   
#    axes[i].yaxis.set_major_locator(ticker.MaxNLocator(3))
    axes[i].tick_params(axis='both', which='both', length=0)
           
    plt.xlabel('')
    plt.ylabel('')
    sns.despine(bottom=True)
    axes[i].set_ylabel(parameters[i])
    axes[i].get_yaxis().set_label_coords(-0.08,0.5) # -0.07(6,1) -0.12(3,2)    

outputname = ''.join(['C:/Users/Lan Tian/Desktop/flux/',Sheetname_flux,'-',Sheetname_seg,'.png'])
plt.savefig(outputname, dpi=600)    