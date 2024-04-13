def generate_colormap(Color, Black, order):
    # 生成对应的颜色顺序
    colors = [Color[i - 1] for i in order]

    # 重复生成第一段colormap1
    # 重复次数等于order列表的长度
    repeat_count = len(order)

    # 生成colormap1变量
    colormap1 = [colors] * len(order)

    # 生成colormap2变量
    colormap2 = [[colors[i] if j == i else Black[0] for j in range(len(colors))] for i in range(len(colors))]

    # 生成colormap变量
    colormap = colormap1 + colormap2 + [colors]

    return colormap