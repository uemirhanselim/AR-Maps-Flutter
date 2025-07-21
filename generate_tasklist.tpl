# Task List for AR Navigation Flutter Project

You are an expert Flutter developer working with ARCore, Google Maps, and MVVM architecture. Your task is to generate a complete and logically ordered list of development tasks for an AR navigation app, similar to Google Maps Live View. Each task must be structured with a title, clear description, and a status set to "Pending".

Use the following context for the task list:

- The app will be built using Flutter with null safety enabled.
- The app must show a fullscreen Google Map centered on the user.
- It should use dummy or mock POI data to allow navigation to a point of interest.
- Once a POI is selected, the user should be able to start navigation.
- A button must be shown to open a camera-based AR navigation view.
- In the AR view, a 3D arrow built from Flutter code (not .glb asset) should point toward the selected POI using `arcore_flutter_plugin`.
- If `arcore_flutter_plugin` does not work, the faulty parts of the plugin should be identified, fixed, and documented.
- The project must follow MVVM architecture and use Provider for state management.
- All UI elements must match those described in `ui.md`.
- The project structure must match `structure.md`.
- All outputs must be written inside the `outputs/results/` directory.
- The final task list must be saved to `outputs/task_list.md` using this template.

Use the following tasks as base requirements and convert them into complete tasks in the list:

1. Flutter projesini null safety ile oluştur.
2. pubspec.yaml dosyasına gerekli paketleri ekle: google_maps_flutter, arcore_flutter_plugin, provider, location.
3. Proje yapısını structure.md’ye göre oluştur.
4. Kullanıcıdan konum izinlerini alma ve konum bilgisini alma servislerini yaz.
5. Google Maps tam ekran gösteren bir sayfa oluştur ve kullanıcı konumuna odaklan.
6. Kullanıcının yakınındaki POI’leri basit sabit liste veya sahte veri ile gösteren widget geliştir.
7. POI seçildiğinde navigasyon başlatılacak şekilde viewmodel ve servisler yaz.
8. Navigasyon başladığında ekranda "Live AR View" butonu göster.
9. Bu butona tıklandığında kamera açılacak ve ARCore ile hedefe yönlendiren 3D ok gösterilecek.
10. Eğer arcore_flutter_plugin çalışmazsa, plugin içindeki hatalı kodları bul, düzelt ve yapılan değişiklikleri raporla.
11. MVVM pattern ve Provider kullanarak state management sağla.
12. Tüm UI elementlerini ui.md’de tarif edildiği gibi yap.
13. Proje çıktılarını outputs/results/ içine yaz.
14. outputs/task_list.md dosyasını generate_tasklist.tpl şablonuna göre oluştur.

# Final Format

Each task must be output in the following format:

Task {{index}}: {{title}}

Description:
{{description}}

Status: Pending


Generate all tasks accordingly and in correct logical order.
