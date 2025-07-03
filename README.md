
# 🚨 PRTG to Matrix Notification Script

Gửi cảnh báo từ **PRTG Network Monitor** tới **Matrix Room** (Element, Synapse...) với thông tin chi tiết và biểu tượng trạng thái đầy đủ (Up, Down, Warning...).

![Badge](https://img.shields.io/badge/PRTG-Supported-blue) ![Badge](https://img.shields.io/badge/Matrix-API-green) ![Badge](https://img.shields.io/badge/PowerShell-%E2%89%A5%205.1-blue)

---

## 📦 Mục tiêu

Tự động gửi thông báo khi thiết bị hoặc sensor trong PRTG gặp sự cố, đi kèm các thông tin:

- Thiết bị, trạng thái, thời gian
- Lần up/down gần nhất
- Uptime, Downtime
- Thông điệp cảnh báo, giá trị đo được
- Biểu tượng trạng thái + màu nền phù hợp (Matrix HTML Message)

---

## 🧰 Yêu cầu

| Thành phần | Phiên bản đề xuất |
|-----------|------------------|
| PRTG      | 22.x trở lên     |
| PowerShell | ≥ 5.1           |
| Matrix API | r0 (Synapse/Element) |
| Hệ điều hành | Windows (PRTG Server) |

---

## 📂 Cấu trúc

```
.
├── Script_Matrix_Prtg.ps1        # Script gửi cảnh báo
└── README.md       # Tài liệu hướng dẫn
```

---

## 🛠️ Hướng dẫn triển khai

### 1. 📥 Tải script

Tải `Script_Matrix_Prtg.ps1` và lưu vào thư mục PRTG:

```
C:\Program Files (x86)\PRTG Network Monitor\Notifications\EXE\
```

---

### 2. 🔑 Tạo access token trên Matrix

- Truy cập máy chủ Matrix (hoặc Element)
- Tạo user bot (ví dụ `@prtg-bot:yourdomain`)
- Lấy `access_token` từ `https://matrix-client.matrix.org/_matrix/client/r0/login`
- Lấy `room_id` bằng cách thêm bot vào phòng

---

### 3. ⚙️ Cấu hình trong `Script_Matrix_Prtg.ps1`

Mở file `Script_Matrix_Prtg.ps1`, tìm đến dòng:

```powershell
$url = "https://your.matrix.server/_matrix/client/r0/rooms/!roomID:yourdomain/send/m.room.message"
$token = "syt_abc123..."
```

Thay `roomID` và `token` tương ứng.

---

### 4. 🔔 Tạo Notification Template trong PRTG

- Vào `Setup` > `Account Settings` > `Notification Templates`
- Click **Add new notification template**
- Đặt tên: `Matrix Notify`
- Chọn **Execute Program**
  - File: `Script_Matrix_Prtg.ps1`
  - Parameters:

```
"%device" "%name" "%status" "%datetime" "%lastresult" "%lastmessage" "%probe" "%group" "%lastcheck" "%lastup" "%lastdown" "%uptime" "%downtime" "%cumulatedsince" "%location" %message
```


---

## ☕ Ủng hộ / Hỗ trợ

Nếu bạn thấy công cụ này hữu ích, hãy ghé thăm và ủng hộ chúng tôi tại:

🌐 [https://fixnhanh.cloud](https://fixnhanh.cloud)

Mọi sự đóng góp sẽ giúp duy trì và phát triển các công cụ mã nguồn mở phục vụ cộng đồng. ❤️
