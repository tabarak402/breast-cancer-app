# 🩺 Meme Kanseri Risk Tahmin Uygulaması

> Flutter ile geliştirilmiş, yapay zeka destekli meme kanseri risk tahmin mobil uygulaması.

---

## 📌 Proje Hakkında

Bu uygulama, hücre çekirdeği ölçümlerini analiz ederek meme kanseri tümörünün **Benign (İyi Huylu)** veya **Malignant (Kötü Huylu)** olduğunu tahmin eder.

Kullanıcı 30 adet hücre özelliğini girer, uygulama FastAPI üzerinden ANN modeline istek atar ve sonucu anlık olarak gösterir.

> ⚕️ Bu uygulama yalnızca bilgi amaçlıdır. Klinik teşhis için doktora başvurunuz.

---

## 🚀 Özellikler

- 30 hücre özelliği için giriş alanları
- Örnek hasta verisi ile hızlı test
- Anlık risk tahmini (YÜKSEK / DÜŞÜK)
- Olasılık göstergesi
- Temiz ve kullanıcı dostu arayüz

---

## 🛠️ Teknolojiler

| Teknoloji | Kullanım |
|---|---|
| Flutter | Mobil uygulama |
| Dart | Programlama dili |
| HTTP | API iletişimi |
| FastAPI | Backend API |
| TensorFlow/Keras | ANN modeli |

---

## ⚙️ Kurulum

### 1. Backend API'yi Başlat

Önce [breast-cancer-ann](https://github.com/tabarak402/breast-cancer-ann) reposunu kur ve API'yi başlat:

```bash
uvicorn api:app --reload
```

### 2. Flutter Uygulamasını Çalıştır

```bash
git clone https://github.com/tabarak402/breast-cancer-app.git
cd breast-cancer-app
flutter pub get
flutter run
```

---

## 📱 Kullanım

1. Uygulamayı aç
2. **"Örnek Hasta Verisi Doldur"** butonuna bas (test için)
3. **"TAHMİN ET"** butonuna bas
4. Sonucu gör — ✅ DÜŞÜK RİSK veya ⚠️ YÜKSEK RİSK

---

## 🔗 İlgili Repo

- [breast-cancer-ann](https://github.com/tabarak402/breast-cancer-ann) — Python modeli + FastAPI backend