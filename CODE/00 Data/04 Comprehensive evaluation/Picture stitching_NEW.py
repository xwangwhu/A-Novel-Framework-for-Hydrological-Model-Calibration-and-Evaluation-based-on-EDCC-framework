from PIL import Image

def concatenate_images_custom(images, rows, cols, output_path):
    # 获取每张图片的宽度和高度
    widths, heights = zip(*(i.size for i in images))

    # 计算拼接后图片的总宽度和高度
    total_width = max(widths) * cols
    total_height = max(heights) * rows

    # 创建新的空白图片
    new_image = Image.new('RGB', (total_width, total_height))

    # 循环将每张图片粘贴到新图片上
    for i in range(rows * cols):
        x_offset = i % cols * max(widths)
        y_offset = i // cols * max(heights)
        new_image.paste(images[i], (x_offset, y_offset))

    # 保存结果图片
    new_image.save(output_path)

# 假设您有六张名为 image1.jpg, image2.jpg, ..., image6.jpg 的图片
# 请替换成您真正的图片文件名
image_files = ["1_N13302500.png", "1_N04073500.png", "1_N06192500.png", "1_N08085500.png", "2_N13302500.png", "2_N04073500.png", "2_N06192500.png", "2_N08085500.png"]
images = [Image.open(img) for img in image_files]

# 自定义行数和列数
custom_rows = 2
custom_cols = 4

# 调用自定义拼接函数并保存结果
output_concatenated = 'custom_concatenated.jpg'
concatenate_images_custom(images, custom_rows, custom_cols, output_concatenated)
