# Fashion Shop App

## Cấu trúc dự án

```
├── backend/         → Spring Boot 3.2.x + JDK 21 + PostgreSQL
└── frontend/        → Flutter App
```

---

## Backend Setup

### 1. Tạo database PostgreSQL
```sql
CREATE DATABASE fashion_db;
```

### 2. Chỉnh sửa `application.properties`
```
spring.datasource.username=postgres
spring.datasource.password=YOUR_PASSWORD
app.jwt.secret=YOUR_LONG_SECRET_KEY_MIN_32_CHARS
```

### 3. Chạy backend
```bash
cd backend
./mvnw spring-boot:run
```
API chạy tại: `http://localhost:8080`

### API Endpoints
| Method | URL | Mô tả |
|--------|-----|-------|
| POST | /api/auth/login | Đăng nhập |
| POST | /api/auth/signup | Đăng ký |
| POST | /api/auth/social-login | Google/Facebook login |
| POST | /api/auth/forgot-password | Quên mật khẩu |
| GET | /api/products/public/new | Sản phẩm mới |
| GET | /api/products/public/sale | Sản phẩm giảm giá |
| GET | /api/products/public/featured | Sản phẩm nổi bật |

---

## Frontend (Flutter) Setup

### 1. Tạo Firebase Project
1. Vào https://console.firebase.google.com
2. Tạo project mới tên **test**
3. Bật **Authentication** → Sign-in methods:
   - ✅ Email/Password
   - ✅ Google
   - ✅ Facebook

### 2. Thêm Firebase vào Flutter
```bash
# Cài FlutterFire CLI
dart pub global activate flutterfire_cli

# Trong thư mục frontend/
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```
Lệnh này tự tạo `lib/firebase_options.dart`

### 3. Cấu hình Facebook Login
1. Vào https://developers.facebook.com → tạo App
2. Lấy App ID và App Secret
3. Thêm vào Firebase Console → Authentication → Facebook
4. Thêm vào `android/app/src/main/res/values/strings.xml`:
```xml
<string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
<string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
<string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>
```

### 4. Cập nhật API URL
Trong `lib/config/api_config.dart`:
```dart
// Android emulator
static const String baseUrl = 'http://10.0.2.2:8080/api';
// Thiết bị thật (thay YOUR_IP bằng IP máy tính)
static const String baseUrl = 'http://192.168.x.x:8080/api';
```

### 5. Chạy Flutter
```bash
cd frontend
flutter pub get
flutter run
```

---

## Lưu ý về Spring Boot Version

> **Spring Boot 4.x chưa được phát hành chính thức.**
> Project đang dùng Spring Boot **3.2.5** (tương thích JDK 21, ổn định).
> Khi Spring Boot 4.0.6 ra mắt, chỉ cần cập nhật version trong `pom.xml`.
