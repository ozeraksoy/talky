#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# Talky - Premiere Pro Altyazı Oluşturucu
# macOS Kurulum Scripti
# ─────────────────────────────────────────────────────────────────────────────

set -e

EXTENSION_ID="com.talky.captioner"
CEP_DIR="$HOME/Library/Application Support/Adobe/CEP/extensions"
INSTALL_DIR="$CEP_DIR/$EXTENSION_ID"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   Talky - Altyazı Oluşturucu Kurulum     ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── 1. CEP klasörünü oluştur ───────────────────────────────────────────────────
echo "→ CEP extensions klasörü hazırlanıyor..."
mkdir -p "$CEP_DIR"

# ── 2. Eski kurulumu temizle ──────────────────────────────────────────────────
if [ -d "$INSTALL_DIR" ]; then
    echo "→ Eski kurulum kaldırılıyor..."
    rm -rf "$INSTALL_DIR"
fi

# ── 3. Plugin dosyalarını kopyala ─────────────────────────────────────────────
echo "→ Plugin dosyaları kopyalanıyor..."
mkdir -p "$INSTALL_DIR/lib"

cp -r "$SOURCE_DIR/CSXS"   "$INSTALL_DIR/"
cp -r "$SOURCE_DIR/client" "$INSTALL_DIR/"
cp -r "$SOURCE_DIR/host"   "$INSTALL_DIR/"

# CSInterface.js — lokal kopyayı kullan (lib/ veya client/ içindeki)
if [ -f "$SOURCE_DIR/client/CSInterface.js" ]; then
    cp "$SOURCE_DIR/client/CSInterface.js" "$INSTALL_DIR/client/CSInterface.js"
    echo "  ✓ CSInterface.js kopyalandı."
else
    echo "  ⚠ CSInterface.js bulunamadı. Kurulum devam ediyor..."
fi

if [ -f "$SOURCE_DIR/.debug" ]; then
    cp "$SOURCE_DIR/.debug" "$INSTALL_DIR/"
fi

echo "  ✓ Dosyalar: $INSTALL_DIR"

# ── 4. CEP Debug Modu ─────────────────────────────────────────────────────────
echo "→ CEP debug modu etkinleştiriliyor..."
for ver in 9 10 11 12; do
    defaults write "com.adobe.CSXS.$ver" PlayerDebugMode 1 2>/dev/null || true
done
echo "  ✓ Tamamlandı."

# ── 5. ffmpeg Kontrolü ve Kurulum ─────────────────────────────────────────────
echo ""
echo "→ ffmpeg kontrol ediliyor..."

FFMPEG_FOUND=false
for candidate in "ffmpeg" "/opt/homebrew/bin/ffmpeg" "/usr/local/bin/ffmpeg" "/usr/bin/ffmpeg"; do
    if command -v "$candidate" &>/dev/null || [ -f "$candidate" ]; then
        FFMPEG_FOUND=true
        echo "  ✓ ffmpeg mevcut."
        break
    fi
done

if [ "$FFMPEG_FOUND" = false ]; then
    echo ""
    echo "  ⚠ ffmpeg bulunamadı. ffmpeg ses çıkarma için gereklidir."
    echo ""
    read -p "  Homebrew ile ffmpeg kurulsun mu? (y/n): " INSTALL_FFMPEG
    if [ "$INSTALL_FFMPEG" = "y" ] || [ "$INSTALL_FFMPEG" = "Y" ]; then
        # Homebrew kontrolü
        if ! command -v brew &>/dev/null && ! [ -f "/opt/homebrew/bin/brew" ]; then
            echo ""
            echo "  Homebrew kuruluyor (birkaç dakika sürebilir)..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Apple Silicon PATH
            if [ -f "/opt/homebrew/bin/brew" ]; then
                eval "$(/opt/homebrew/bin/brew shellenv zsh)"
                echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> "$HOME/.zprofile"
            fi
        fi
        echo "  ffmpeg kuruluyor..."
        brew install ffmpeg
        echo "  ✓ ffmpeg kuruldu."
    else
        echo ""
        echo "  ffmpeg olmadan plugin çalışmaz."
        echo "  Sonra kurmak için:"
        echo "    brew install ffmpeg"
        echo ""
    fi
fi

# ── 6. Özet ──────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║           KURULUM TAMAMLANDI!            ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Sonraki adımlar:"
echo "  1. Premiere Pro'yu TAMAMEN kapat ve yeniden aç"
echo "  2. Window → Extensions → Talky - Altyazı Oluşturucu"
echo "  3. ⚙ simgesinden OpenAI API anahtarını gir"
echo "     → platform.openai.com/api-keys adresinden alabilirsin"
echo ""
echo "Sorun olursa: Chrome'da http://localhost:7777 aç"
echo ""
