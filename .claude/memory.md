# Hafıza

## Proje
- **Ad:** Talky
- **Açıklama:** Premiere Pro için OpenAI Whisper tabanlı otomatik altyazı oluşturucu CEP plugin'i
- **Dil/Framework:** CEP (Common Extensibility Platform), HTML/CSS/JS + ExtendScript (JSX)
- **Hedef Kitle:** Türkçe içerik üreten sosyal medya içerik üreticileri ve video editörler (bireysel Premiere Pro kullanıcıları)

## Şimdi
- v1.0 MVP tamamlandı ve kurulum için hazır

## Mimari
- `CSXS/manifest.xml` — CEP 10+, PPRO 13.0+ (CC 2019+)
- `host/index.jsx` — ExtendScript: playhead/seçili klip bilgisi, SRT import
- `client/app.js` — Node.js (mixed-context): ffmpeg ses çıkarma, Whisper API, GPT çeviri, SRT üretimi
- `lib/CSInterface.js` — Kurulum scripti tarafından indiriliyor (Adobe GitHub)
- Extension ID: `com.talky.captioner`
- Kurulum: `scripts/install.sh` (mac) / `scripts/install.bat` (win)

## Açık Konular
- CSInterface.js kurulum scriptinde indiriliyor; internet yoksa manuel indirilmeli
- Whisper 25MB limit: çok uzun kliplerde sorun olabilir (gelecek sürümde chunking eklenebilir)
- UXP'ye geçiş: Adobe CEP'i deprecate edecek, uzun vadede UXP'ye taşınmalı

## Son Kararlar
- CEP (HTML+JSX) seçildi, UXP yerine — daha geniş sürüm uyumluluğu için
- ffmpeg ses çıkarma zorunlu (25MB limit aşmamak için)
- GPT-4o-mini çeviri için (ucuz ve hızlı)
- SRT aynı klasöre kaydediliyor (save dialog yok — CEP kısıtlaması)

## Engeller
- (yok)
