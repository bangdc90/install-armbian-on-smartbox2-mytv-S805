# Hướng dẫn chạy Armbian 5.x/6.x từ SD card cho S805 box

## Yêu cầu:
- SD card tối thiểu 8GB (khuyến nghị 16GB+)
- Armbian image cho S805 (kernel 5.x hoặc 6.x)
- Package boot files này (đã có)

## Bước 1: Chuẩn bị SD card

### 1.1 Flash Armbian image lên SD card:
```bash
# Sử dụng balenaEtcher, Rufus, hoặc dd command
# Flash file .img Armbian vào SD card
```

### 1.2 Sau khi flash xong, SD card sẽ có 2 partition:
- **BOOT** (FAT32) - chứa kernel và boot files
- **armbi_root** (EXT4) - chứa rootfs

## Bước 2: Copy boot files vào SD card

### 2.1 Copy tất cả files từ package này vào partition BOOT của SD card:
```
BOOT/
├── aml_autoscript          # Boot script binary
├── aml_autoscript.cmd      # Boot script source
├── s805_autoscript         # S805 boot script binary  
├── s805_autoscript.cmd     # S805 boot script source
├── uEnv.txt               # Environment variables
├── u-boot.bin.sd.bin      # U-boot mới hỗ trợ DTB
├── u-boot-p212.bin        # U-boot cho P212 board
├── meson8b-m201.dtb       # Device Tree Blob
└── dtb/                   # Folder chứa DTB files
    └── meson8b-m201.dtb   # DTB file chính
```

### 2.2 Tạo thêm folder dtb và copy DTB file:
```bash
mkdir BOOT/dtb
cp meson8b-m201.dtb BOOT/dtb/
```

## Bước 3: Cấu hình boot cho board cụ thể

### 3.1 Chỉnh sửa uEnv.txt để phù hợp với board:

**Đối với M201 MXQ board (đang sử dụng):**
```bash
FDT=/dtb/meson8b-m201.dtb
```

**Đối với EC100 board:**
```bash
#FDT=/dtb/meson8b-m201.dtb
FDT=/dtb/meson8b-ec100.dtb
```

**Đối với Odroid C1 board:**
```bash
#FDT=/dtb/meson8b-m201.dtb
FDT=/dtb/meson8b-odroidc1.dtb
```

**Đối với MXQ board khác:**
```bash
#FDT=/dtb/meson8b-m201.dtb
FDT=/dtb/meson8b-mxq.dtb
```

### 3.2 Cấu hình video output (tùy chọn):
```bash
# Cho TV 1080p 50Hz
VMODE=1080P50HZ

# Cho TV 1080p 60Hz (mặc định)
VMODE=1080P
```

## Bước 4: Đổi tên u-boot file (nếu cần)

### 4.1 Kiểm tra board cần file u-boot tên gì:
- Nếu cần `u-boot.bin`: đổi tên `u-boot.bin.sd.bin` → `u-boot.bin`
- Nếu cần `u-boot-p212.bin`: giữ nguyên
- Nếu cần tên khác: đổi tên phù hợp

### 4.2 Lệnh đổi tên (trong Windows):
```powershell
# Nếu cần u-boot.bin
ren "u-boot.bin.sd.bin" "u-boot.bin"

# Hoặc nếu cần u-boot-s805.bin
ren "u-boot.bin.sd.bin" "u-boot-s805.bin"
```

## Bước 5: Boot từ SD card

### 5.1 Cắm SD card vào box
### 5.2 Cắm dây AV/HDMI vào TV
### 5.3 Nhấn giữ nút Reset (trong lỗ) và cắm nguồn
### 5.4 Giữ Reset 10-15 giây rồi thả ra

## Cơ chế hoạt động:

### Boot sequence sẽ diễn ra như sau:
1. **U-boot gốc** (kernel 3.x) khởi động
2. Tìm và chạy **aml_autoscript** từ SD card
3. **aml_autoscript** redirect để chạy **s805_autoscript**
4. **s805_autoscript** load **u-boot mới** từ SD card
5. **U-boot mới** load kernel 5.x/6.x + DTB file
6. Boot vào **Armbian với kernel 5.x/6.x**

### Điểm quan trọng:
- U-boot mới hỗ trợ load .dtb files (không cần dtb.img)
- Kernel 5.x/6.x sử dụng DTB format mới
- Package này bridge compatibility gap giữa ROM gốc và Armbian mới

## Troubleshooting:

### Nếu không boot được:
1. Kiểm tra tên file u-boot có đúng không
2. Thử các DTB file khác trong uEnv.txt  
3. Kiểm tra SD card có bị lỗi không
4. Thử boot mode khác (USB thay vì SD)

### Nếu có lỗi video:
1. Đổi VMODE trong uEnv.txt
2. Thử kết nối AV thay vì HDMI (hoặc ngược lại)

## Lưu ý quan trọng:
- Không xóa ROM gốc trong eMMC
- SD card chỉ để boot, ROM gốc vẫn an toàn
- Có thể boot bình thường bằng cách rút SD card
