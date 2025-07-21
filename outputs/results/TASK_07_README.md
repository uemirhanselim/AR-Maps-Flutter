# Task 7: Navigasyon başlatma viewmodel ve servisleri

## Açıklama
POI seçildiğinde navigasyon başlatılacak şekilde viewmodel ve servisler yazıldı.

## Uygulama
- `lib/core/services/navigation_service.dart`: NavigationService sınıfı ile navigasyon durumu yönetimi ve POI seçimi işlemleri eklendi.
- `lib/core/viewmodels/map_viewmodel.dart`: MapViewModel sınıfı ile Provider pattern kullanarak state management sağlandı.

## Doğrulama
- POI seçildiğinde navigasyon başlatılıyor.
- Navigasyon durumu takip ediliyor.
- Provider pattern ile state management çalışıyor. 