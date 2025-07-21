# Task 12: UI elementlerini ui.md'ye göre yap

## Açıklama
Tüm UI elementlerini ui.md'de tarif edildiği gibi yapıldı.

## Uygulama
- `lib/core/views/home_view.dart`: Ana ekran, tam ekran Google Maps, POI listesi ve navigasyon butonu ile birleştirildi.
- `lib/main.dart`: Uygulama ana dosyası HomeView'i kullanacak şekilde güncellendi.
- Minimalist, temiz ve kullanıcı dostu tasarım uygulandı.
- Responsive tasarım için Stack ve Positioned widget'ları kullanıldı.

## Doğrulama
- Uygulama açıldığında tam ekran Google Maps gösteriliyor.
- Harita kullanıcının mevcut konumuna odaklanıyor.
- POI'ler haritanın üzerinde overlay olarak listeleniyor.
- Navigasyon başladığında "Live AR View" butonu görünüyor.
- Tüm ekran elemanları minimalist ve temiz tasarıma sahip. 