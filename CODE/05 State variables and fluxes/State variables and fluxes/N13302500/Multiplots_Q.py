import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
from colormap_generator import generate_colormap

sns.set_style("white")
sns.set_context("paper")

Color = ['#106EA0', '#00969E', '#32C0D2', '#E0B165', '#963C4C']
Black = ['#000000']
order = order = [3, 5, 2, 4, 1]
colormap = generate_colormap(Color, Black, order)

sheetname_seg = ['Whole', 'Cali', 'Calidemo', 'Veri', 'Veridemo']
for k in range(len(sheetname_seg)):
    Sheetname_seg = sheetname_seg[k]
    seg = pd.read_excel('01 Data/04 Segments.xlsx', sheet_name=Sheetname_seg)

    sheetname_flux = ['scheme1', 'scheme2', 'scheme3', 'scheme4', 'scheme5',
                      'scheme6-1', 'scheme6-2', 'scheme6-3', 'scheme6-4', 'scheme6-5', 'scheme6-6']
    origin = pd.read_excel('01 Data/03 fluxes.xlsx', sheet_name='scheme1')

    j = 0
    Sheetname_flux = sheetname_flux[j]
    df = pd.read_excel('01 Data/03 fluxes.xlsx', sheet_name=Sheetname_flux)

    Color = colormap[j]
    parameters = ['AE', 'OV', 'Qq', 'Qs', 'Qsim']

    fig, axes = plt.subplots(1, 1, sharex=True, figsize=(12, 1))
    i = 4

    for j in range(len(seg.seg1)):
        left = seg.seg1[j] - 1
        right = seg.seg2[j] - 1
        COLOR = Color[seg.type[j] - 1]
        # sns.lineplot(x=df.num[left:right], y='Qobs',
        #              data=df[left:right], color=COLOR)
        ax = sns.lineplot(x=df.num[left:right], y='Qobs',
                     data=df[left:right], color=COLOR, linewidth=0.5)
        ax.set(xticks=[], yticks=[])
        
    # Adding X and Y axis labels
    # plt.xlabel('Day')  # Replace with your desired label
    # plt.ylabel('Q')  # Replace with your desired label

    # Remove the top and right spines
    axes = plt.gca()
    axes.spines['top'].set_visible(False)
    axes.spines['right'].set_visible(False)
    axes.spines['left'].set_visible(False)
    axes.spines['bottom'].set_visible(False)
    # axes.xaxis.set_visible(False)
    axes.yaxis.set_visible(False)
    axes.xaxis.set_visible(False)


    # # # 这段是控制坐标轴生成的
    # plt.annotate("", xy=(1, 0), xytext=(0, 0),)
    # plt.annotate("", xy=(0, 1), xytext=(0, 0),)

    # sns.despine()

    # # 取消生成坐标轴
    # sns.set(style="whitegrid", rc={"axes.grid": False})
    
    outputname = ''.join(
    ["01 Data/Q/", Sheetname_flux, '-', Sheetname_seg, '.png'])
    plt.savefig(outputname, dpi=1000)

# plt.show()  # This will display the plot