# AR Navigation Flutter

## 📱 Proje Açıklaması
Bu proje, Flutter ile geliştirilmiş bir Artırılmış Gerçeklik (AR) Navigasyon uygulamasıdır. Kullanıcı, harita üzerinde bir POI (ilgi noktası) seçer ve Google Maps Directions API ile gerçek rota çizilir. AR modunda, kamerada yönlendiren küreler ve adım adım yol tarifi gösterilir.

## 🚀 Temel Özellikler
- Google Maps entegrasyonu ve canlı harita
- Yakındaki POI’leri gösterme ve seçme
- Google Directions API ile gerçek rota ve yol tarifi
- ARCore ile kamerada yönlendirme küreleri
- Navigasyon adımlarını Türkçe ve adım adım gösterme
- API anahtarı güvenli şekilde .env dosyasında saklanır

## 🛠️ Kurulum
1. **Projeyi klonla:**
   ```sh
   git clone https://github.com/kullaniciadi/ar_navigation_flutter.git
   cd ar_navigation_flutter
   ```
2. **Bağımlılıkları yükle:**
   ```sh
   flutter pub get
   ```
3. **.env dosyasını oluştur:**
   Proje kök dizinine `.env` dosyası ekle ve içine şunu yaz:
   ```
   GOOGLE_MAPS_API_KEY=senin_google_maps_api_keyin
   ```
   > `.env` dosyası `.gitignore`’dadır, GitHub’a gönderilmez.

4. **Android için:**
   - Gerçek cihazda test et (emülatör AR desteklemez).
   - Gerekli izinler ve ARCore desteği AndroidManifest.xml’de hazır.

## ▶️ Çalıştırma
```sh
flutter run
```

## 📸 Ekran Görüntüleri
> Buraya uygulama ekran görüntülerinizi ekleyin.

## 💡 Katkı
Katkıda bulunmak isterseniz, lütfen bir fork oluşturun ve pull request gönderin.

## 📝 Lisans
MIT Lisansı


