from PIL import Image

def concatenate_images_6x2(images, output_path):
    # 获取每张图片的宽度和高度
    widths, heights = zip(*(i.size for i in images))

    # 计算拼接后图片的总宽度和高度
    total_width = max(widths) * 6
    total_height = max(heights) * 2

    # 创建新的空白图片
    new_image = Image.new('RGB', (total_width, total_height))

    # 循环将每张图片粘贴到新图片上
    for i in range(12):
        x_offset = i % 6 * max(widths)
        y_offset = i // 6 * max(heights)
        new_image.paste(images[i], (x_offset, y_offset))

    # 保存结果图片
    new_image.save(output_path)

# 假设您有六张名为 image1.jpg, image2.jpg, ..., image6.jpg 的图片
# 请替换成您真正的图片文件名
image_files = [ "1_N03331500.png", "1_N05582000.png", "1_N06192500.png", "1_N11532500.png", "1_N12027500.png", "1_N13302500.png", "2_N03331500.png", "2_N05582000.png", "2_N06192500.png", "2_N11532500.png", "2_N12027500.png", "2_N13302500.png"]
images = [Image.open(img) for img in image_files]

# 调用拼接函数并保存结果
output_concatenated = 'concatenated_6x2.jpg'
concatenate_images_6x2(images, output_concatenated)
