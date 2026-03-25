# Talky — Premiere Pro Altyazı Oluşturucu

Premiere Pro için OpenAI Whisper tabanlı otomatik altyazı oluşturucu. Türkçe dahil 15+ dil desteği, çeviri ve SRT dışa aktarımı.

---

## Özellikler

- **Otomatik transkripsiyon** — OpenAI Whisper API ile yüksek doğruluk
- **Türkçe öncelikli** — Türkçe ses için özel dil parametresi
- **15+ dil desteği** — Türkçe, İngilizce, Almanca, Fransızca, Arapça ve daha fazlası
- **Çeviri** — GPT-4o-mini ile herhangi bir dile çevir
- **Segment düzenleme** — Sonuçları panel içinde düzenleyebilirsin
- **SRT dışa aktarma** — Video dosyasıyla aynı klasöre kaydeder
- **Premiere Pro içe aktarma** — Tek tıkla projeye ekle

---

## Gereksinimler

### 1. Premiere Pro
- Adobe Premiere Pro CC 2019 (sürüm 13.0) veya üzeri

### 2. OpenAI API Anahtarı
1. [platform.openai.com](https://platform.openai.com/api-keys) adresine git
2. API Keys bölümünden yeni anahtar oluştur
3. Plugin'in Ayarlar bölümüne yapıştır

**Maliyet tahmini:**
- Whisper API: $0.006 / dakika (çok ucuz)
- Çeviri (GPT-4o-mini): ortalama $0.001–0.01 / segment seti

### 3. ffmpeg
ffmpeg ses çıkarma için zorunludur.

**macOS:**
```bash
# Homebrew ile (önerilen)
brew install ffmpeg

# Homebrew yüklü değilse:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install ffmpeg
```

**Windows:**
```powershell
# Winget ile
winget install ffmpeg

# Chocolatey ile
choco install ffmpeg

# Manuel: https://www.gyan.dev/ffmpeg/builds/
# ffmpeg-release-full.7z indir, C:\ffmpeg\bin\ klasörüne çıkar, PATH'e ekle
```

---

## Kurulum

### macOS

```bash
# Terminal'i aç, proje klasörüne git
cd ~/Desktop/talky

# Kurulum scriptini çalıştır
bash scripts/install.sh
```

### Windows

1. `scripts\install.bat` dosyasına çift tıkla
2. Veya Komut İstemi'nde çalıştır:
```cmd
cd %USERPROFILE%\Desktop\talky
scripts\install.bat
```

### Manuel Kurulum

1. Bu klasörü kopyala:
   - **macOS:** `~/Library/Application Support/Adobe/CEP/extensions/com.talky.captioner/`
   - **Windows:** `%APPDATA%\Adobe\CEP\extensions\com.talky.captioner\`

2. CSInterface.js dosyasını `lib/` klasörüne indir:
   ```
   https://raw.githubusercontent.com/Adobe-CEP/CEP-Resources/master/CEP_11.x/CEP_11.0/CSInterface.js
   ```

3. CEP debug modunu etkinleştir (imzasız extension için zorunlu):

   **macOS:**
   ```bash
   defaults write com.adobe.CSXS.10 PlayerDebugMode 1
   defaults write com.adobe.CSXS.11 PlayerDebugMode 1
   defaults write com.adobe.CSXS.12 PlayerDebugMode 1
   ```

   **Windows (Registry):**
   ```
   HKEY_CURRENT_USER\Software\Adobe\CSXS.10 → PlayerDebugMode = 1
   HKEY_CURRENT_USER\Software\Adobe\CSXS.11 → PlayerDebugMode = 1
   ```

4. Premiere Pro'yu yeniden başlat

---

## Kullanım

### 1. Paneli Aç
Premiere Pro'da: **Window → Extensions → Talky - Altyazı Oluşturucu**

### 2. API Anahtarını Gir
- Sağ üstteki ⚙ simgesine tıkla
- OpenAI API anahtarını yapıştır
- Otomatik kaydedilir

### 3. Klip Seç

**Yöntem A — Oynatma Kafası:**
1. Sekansda transkript etmek istediğin klibin üzerine oynatma kafasını götür
2. **"⏺ Kafadaki"** butonuna tıkla

**Yöntem B — Seçim:**
1. Timeline'da klibi tıklayarak seç
2. **"☑ Seçili"** butonuna tıkla

### 4. Dil Ayarları
- **Kaynak Dil:** Videodaki konuşma dili (Türkçe için "Türkçe" seç)
- **Çeviri:** İstersen başka bir dile çevir

### 5. Transkripsiyon Başlat
**"🎙 Transkripsiyon Başlat"** butonuna tıkla.

İşlem adımları:
1. ffmpeg ile ses çıkarılır (~5 saniye)
2. Whisper API'ye gönderilir (~10-60 saniye, klip uzunluğuna göre)
3. Gerekirse çeviri yapılır (~5 saniye)

### 6. Düzenle ve Dışa Aktar

Sonuçlar panel içinde düzenlenebilir (üzerine tıkla, yaz).

**SRT Kaydet:** Video dosyasıyla aynı klasöre, aynı isimde `.srt` uzantılıyla kaydeder.

**Premiere'e İçe Aktar:** SRT dosyasını doğrudan Premiere Pro projesine ekler. Proje panelinde bulun, timeline'a sürükleyin.

---

## Premiere Pro'da Altyazı Ekleme

SRT dosyasını içe aktardıktan sonra:

1. Proje panelinde SRT dosyasını bul
2. Timeline'daki video klibin başına denk gelecek şekilde Caption track'e sürükle
3. Veya: **Sequence → Add Captions** ile yeni bir Caption track oluştur, ardından SRT'yi o track'e bırak

---

## Sorun Giderme

### "Premiere Pro bağlantısı kurulamadı"
- CEP debug modu etkin mi? (Kurulum adım 3'ü kontrol et)
- Premiere Pro'yu tamamen kapatıp tekrar aç
- Extension'ın doğru klasörde kurulu olduğunu kontrol et

### "Oynatma kafası konumunda klip bulunamadı"
- Oynatma kafasını video klibin üzerine getir
- Audio-only kliplerde çalışmaz, video klip olmalı
- Adjustment Layer ve Title'lar desteklenmez

### "ffmpeg bulunamadı"
- `ffmpeg -version` komutunu terminalde çalıştır
- Homebrew ile `brew install ffmpeg`
- Apple Silicon Mac'te: `/opt/homebrew/bin/ffmpeg` PATH'de olduğundan emin ol

### "Whisper API Hatası 401"
- API anahtarı yanlış ya da geçersiz
- [platform.openai.com](https://platform.openai.com) adresinden kontrol et
- Hesapta kredi olduğundan emin ol

### "Whisper API Hatası 413 (dosya çok büyük)"
- Whisper API maksimum 25MB kabul eder
- ffmpeg ses çıkarırken bu limit aşılmış (çok uzun klip)
- Klibi daha kısa parçalara böl

### Hata Ayıklama (Developer)
1. Premiere Pro açıkken Chrome'u aç
2. `http://localhost:7777` adresine git
3. DevTools ile JavaScript hatalarını incele

---

## Dizin Yapısı

```
talky/
├── CSXS/
│   └── manifest.xml          — CEP Extension tanımı
├── client/
│   ├── index.html            — Panel UI
│   ├── style.css             — Stiller
│   └── app.js                — Uygulama mantığı
├── host/
│   └── index.jsx             — ExtendScript (Premiere Pro API)
├── lib/
│   └── CSInterface.js        — Adobe CEP kütüphanesi (kurulumda indirilir)
├── scripts/
│   ├── install.sh            — macOS kurulum
│   └── install.bat           — Windows kurulum
├── .debug                    — CEP debug yapılandırması
└── README.md                 — Bu dosya
```

---

## Lisans

MIT License — serbestçe kullanabilir, düzenleyebilir ve dağıtabilirsiniz.

---

## Katkı

Hata bulursan veya özellik istersen GitHub üzerinden issue aç.
