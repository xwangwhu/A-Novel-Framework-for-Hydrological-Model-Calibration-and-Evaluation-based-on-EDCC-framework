import os
import matplotlib.pyplot as plt
import ternary
import random

# 指定工作路径
work_path = 'D:\\OneDrive - whu.edu.cn\\CHD\\上传code\\CODE\\05 State variables and fluxes\\Flux composition\\Data'
os.chdir(work_path)

# 直接指定要处理的文件名
file_path = 'N13302500_5.txt'

maxOF = 2

# 读取并处理指定的txt文件
data = []
with open(file_path, 'r') as file:
    for line in file:
        values = [float(val) for val in line.strip().split()]
        data.append(values)

# 保留第一列小于1的行
data = [row for row in data if row[0] < maxOF]
if len(data) > 500:
    data = random.sample(data, 500)

# 处理数据，创建散点图
points = [(val[1] * 100, val[2] * 100, val[3] * 100) for val in data]
values = [val[0] for val in data]

# 定义每个值所对应的颜色
def get_color(value):
    if value < 0.3:
        return 'green'
    elif value < 0.75:
        return 'blue'
    elif value < 1:
        return 'red'
    else:
        return 'grey'

# 散点图的颜色数组
colors = [get_color(val) for val in values]

## Boundary and Gridlines
scale = 40
figure, tax = ternary.figure(scale=scale)

tax.ax.axis("off")
figure.set_facecolor('none')  # 移除背景颜色设置

tax.boundary(linewidth=0.5)
tax.gridlines(color="grey", multiple=5, linewidth=0.3, ls=':')  # 设置刻度线间隔为5

tax.set_axis_limits({'b': [0, 40], 'l': [60, 100], 'r': [0, 40]})
tick_formats = {'b': "%d", 'r': "%d", 'l': "%d"}

tax.get_ticks_from_axis_limits(multiple=5)
tax.set_custom_ticks(fontsize=10, linewidth=1, offset=0.018, tick_formats=tick_formats)

# 设置坐标轴标签，使用下标和Arial字体
tax.left_axis_label("$Q_{q2}\ (\%)$", fontsize=15, offset=0.16, fontname='Arial')
tax.right_axis_label("$Q_{q1}\ (\%)$", fontsize=15, offset=0.14, fontname='Arial')
tax.bottom_axis_label("$Q_{s}\ (\%)$", fontsize=15, offset=0.06, fontname='Arial')

if values:
    scatter = tax.scatter(points, c=colors, s=20, alpha=0.6)
else:
    print(f"No data to plot for {file_name}")

# 修改输出路径为Output文件夹，并保存图片
output_path = os.path.join(work_path, "Output")
if not os.path.exists(output_path):
    os.makedirs(output_path)
output_file = os.path.join(output_path, f'{file_name}.png')
plt.savefig(output_file, dpi=600, bbox_inches='tight')
plt.show()
plt.close()
