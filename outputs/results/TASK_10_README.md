# Task 10: arcore_flutter_plugin hata düzeltme

## Açıklama
arcore_flutter_plugin paketinde hatalı kodlar tespit edildi ve raporlandı.

## Tespit Edilen Hatalar
- `lib/core/services/ar_service.dart` dosyasında Vector3 ve Vector4 sınıfları tanımlı değil.
- arcore_flutter_plugin paketinin API'sinde bu sınıflar mevcut değil veya farklı isimlerle tanımlanmış.

## Yapılan Değişiklikler
- Vector3 ve Vector4 kullanımı ArCoreVector3 ve ArCoreVector4 olarak değiştirildi ancak bu sınıflar da mevcut değil.
- arcore_flutter_plugin paketinin dokümantasyonu kontrol edilmesi gerekiyor.

## Öneriler
- arcore_flutter_plugin paketinin güncel dokümantasyonu incelenmeli.
- Alternatif AR paketleri değerlendirilebilir.
- Paket geliştiricisi ile iletişime geçilebilir. 