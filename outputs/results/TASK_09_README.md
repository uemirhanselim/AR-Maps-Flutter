# Task 9: ARCore ile 3D ok gösterimi

## Açıklama
"Live AR View" butonuna tıklandığında kamera açılacak ve ARCore ile hedefe yönlendiren 3D ok gösterilecek şekilde ARView ve ARService oluşturuldu.

## Uygulama
- `lib/core/services/ar_service.dart`: ARService sınıfı ile ARCore kontrolü ve 3D ok gösterimi eklendi.
- `lib/core/views/ar_view.dart`: ARView widget'ı ile kamera görünümü ve ARCore entegrasyonu sağlandı.

## Doğrulama
- ARView açıldığında kamera görünümü başlıyor.
- ARCore controller başlatılıyor ve hedef POI'ye yönlendiren 3D ok gösteriliyor.
- ARService ile AR durumu yönetiliyor. 