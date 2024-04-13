import seaborn as sns
import pandas as pd 
import matplotlib.pyplot as plt
from colormap_generator import generate_colormap

sns.set_style("white")
sns.set_context("paper")

Color = ['#106EA0', '#00969E', '#32C0D2', '#E0B165', '#963C4C']
Black = ['#848484']
order = [3, 1, 5, 2, 4]
colormap = generate_colormap(Color, Black, order)

sheetname_seg = ['Whole','Cali','Calidemo','Veri','Veridemo']
for k in range(len(sheetname_seg)):
    Sheetname_seg = sheetname_seg[k]
    seg = pd.read_excel('01 Data/04 Segments.xlsx', sheet_name=Sheetname_seg)
    
    sheetname_flux = ['scheme1','scheme2','scheme3','scheme4','scheme5','scheme6-1','scheme6-2','scheme6-3','scheme6-4','scheme6-5','scheme6-6']
    origin = pd.read_excel('01 Data/02 State variables.xlsx', sheet_name='scheme1')
    
    for j in range(len(sheetname_flux)):
        Sheetname_flux = sheetname_flux[j]
        df = pd.read_excel('01 Data/02 State variables.xlsx', sheet_name=Sheetname_flux)
    
        Color = colormap[j]
        parameters=['XHuz','XCuz','Xq1','Xq2','Xq3','Xs']
        
        fig, axes = plt.subplots(6, 1, sharex=True)     
        for i in range(len(parameters)):
            axes[i] = plt.subplot(6, 1, i+1)            

            # 初始化该参数的全局最大值和最小值
            global_param_min = float('inf')
            global_param_max = float('-inf')

            for seg_index in range(len(seg.seg1)):
                left = seg.seg1[seg_index]-1
                right = seg.seg2[seg_index]-1

                # 提取当前seg段的数据
                segment_data_df = df[left:right]
                segment_data_origin = origin[left:right]

                # 计算当前段的最大值和最小值
                segment_min_df = segment_data_df[parameters[i]].min()
                segment_max_df = segment_data_df[parameters[i]].max()
                segment_min_origin = segment_data_origin[parameters[i]].min()
                segment_max_origin = segment_data_origin[parameters[i]].max()

                # 更新全局最大值和最小值
                global_param_min = min(global_param_min, segment_min_df, segment_min_origin)
                global_param_max = max(global_param_max, segment_max_df, segment_max_origin)

                # 绘图逻辑...
                COLOR = Color[seg.type[seg_index]-1]
                sns.lineplot(x=segment_data_df.num, y=parameters[i], data=segment_data_df, color=COLOR, linewidth=2)
                sns.lineplot(x=segment_data_origin.num, y=parameters[i], data=segment_data_origin, color="#A5A5A5", linewidth=0.4)

            # 格式化全局最大值和最小值
            formatted_min = "{:.0f}".format(global_param_min) if global_param_max >= 1 else "{:.1f}".format(global_param_min)
            formatted_max = "{:.0f}".format(global_param_max) if global_param_max >= 1 else "{:.1f}".format(global_param_max)

            # 设置子图纵坐标轴仅显示最小值和最大值
            axes[i].set_yticks([global_param_min, global_param_max])
            axes[i].set_yticklabels([formatted_min, formatted_max], fontsize=10)

            if i == len(parameters) - 1:
                first_value = seg['seg1'].iloc[0]
                last_value = seg['seg2'].iloc[-1]
                axes[i].set_xticks([first_value, last_value])
                axes[i].set_xticklabels([str(first_value), str(last_value)], fontsize=15)
                axes[i].tick_params(axis='x', labelsize=10)
            else: 
                axes[i].get_xaxis().set_visible(False)  

            axes[i].set_ylabel(parameters[i], fontsize=16)
            plt.xlabel('')
            plt.ylabel('')
            sns.despine(bottom=True)
            axes[i].set_ylabel(parameters[i])
            axes[i].get_yaxis().set_label_coords(-0.08,0.5)
        
        plt.subplots_adjust(hspace=0.15)
        
        outputname = ''.join(["01 Data/state/", Sheetname_flux, '-', Sheetname_seg, '.png'])
        plt.savefig(outputname, dpi=600)