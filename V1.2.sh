#!/bin/bash

# Renkler
RED='\033[1;31m' GREEN='\033[1;32m' CYAN='\033[1;36m' YELLOW='\033[1;33m' MAGENTA='\033[1;35m' RESET='\033[0m' BOLD='\033[1m'

function banner() {
  clear
  figlet -c GTX-PRO.V3 | lolcat
  echo -e "${CYAN}${BOLD}GtxAnqel tarafından geliştirilen Etik Hacker Aracı${RESET}"
  echo -e "${YELLOW}───────────────────────────────────────────────────────────────${RESET}\n"
}

function pause() {
  read -rp "Devam etmek için Enter'a bas..."
}

### --- IP-Tracer MODÜLÜ ---
function bilgi_goster() {
  ip="$1"
  echo -e "${YELLOW}[!] Bilgiler alınıyor...${RESET}"
  data=$(curl -s "http://ip-api.com/json/$ip?fields=status,country,regionName,city,district,zip,lat,lon,org,query,message,as,reverse")
  status=$(echo "$data" | jq -r '.status')

  if [[ "$status" != "success" ]]; then
    message=$(echo "$data" | jq -r '.message')
    echo -e "${RED}Hata: $message${RESET}"
    return
  fi

  country=$(echo "$data" | jq -r '.country')
  region=$(echo "$data" | jq -r '.regionName')
  city=$(echo "$data" | jq -r '.city')
  district=$(echo "$data" | jq -r '.district')
  zip=$(echo "$data" | jq -r '.zip')
  lat=$(echo "$data" | jq -r '.lat')
  lon=$(echo "$data" | jq -r '.lon')
  org=$(echo "$data" | jq -r '.org')
  query_ip=$(echo "$data" | jq -r '.query')
  asn=$(echo "$data" | jq -r '.as')
  reverse_dns=$(echo "$data" | jq -r '.reverse')

  [[ "$district" == "null" ]] && district="Bilinmiyor"
  [[ "$zip" == "null" ]] && zip="Bilinmiyor"
  [[ "$reverse_dns" == "null" ]] && reverse_dns="Bilinmiyor"

  vpn_words=("VPN" "Proxy" "proxy" "vpn" "TOR" "tor" "Tor")
  vpn_status="${GREEN}VPN kullanmıyorsunuz.${RESET}"
  for w in "${vpn_words[@]}"; do
    if [[ "$org" == *"$w"* ]] || [[ "$asn" == *"$w"* ]]; then
      vpn_status="${RED}VPN veya Proxy kullanıyorsunuz!${RESET}"
      break
    fi
  done

  echo -e "${GREEN}${BOLD}IP BİLGİSİ:${RESET}"
  echo -e "  IP             : $query_ip"
  echo -e "  ISP / Organizasyon: $org"
  echo -e "  ASN            : $asn"
  echo -e "  Reverse DNS    : $reverse_dns"
  echo -e "  VPN Durumu     : $vpn_status"
  echo -e "  Ülke           : $country"
  echo -e "  Bölge          : $region"
  echo -e "  Şehir          : $city"
  echo -e "  İlçe           : $district"
  echo -e "  Posta Kodu     : $zip"
  echo -e "  Koordinat      : $lat, $lon"
  echo -e "  Harita         : https://maps.google.com/?q=$lat,$lon"
  echo ""
}

function ip_tracer() {
  clear
  figlet "GTX IP-TRACER" | lolcat
  echo -e "${YELLOW}---------------------------------------------${RESET}"
  echo -e "               ${GREEN}KULLANIM KILAVUZU${RESET}"
  echo -e "${YELLOW}---------------------------------------------${RESET}"
  echo -e "${CYAN}GTX-MN${RESET} yazarsanız tekrar kullanım kılavuzuna ulaşırsınız."
  echo -e "${GREEN}GTX-M${RESET} yazarsanız kendi IP adresinize bakarsınız."
  echo -e "${GREEN}q${RESET} ile çıkabilirsiniz."
  echo ""

  while true; do
    read -rp $'\033[33m🔍 IP adresi ya da komut (GTX-M / GTX-MN / q çıkış): \033[0m' girdi

    if [[ "$girdi" == "q" ]]; then
      break
    elif [[ "$girdi" == "GTX-MN" ]]; then
      echo -e "${CYAN}KULLANIM KILAVUZU:${RESET}"
      echo " - GTX-MN: Bu kılavuzu gösterir"
      echo " - GTX-M : Kendi IP'nizin bilgilerini gösterir"
      echo " - IP    : Herhangi bir IP'nin detaylarını gösterir"
      echo " - q     : Çıkış yapar"
      pause
    elif [[ "$girdi" == "GTX-M" ]]; then
      ip=$(curl -s ifconfig.me)
      bilgi_goster "$ip"
      pause
    elif [[ "$girdi" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      bilgi_goster "$girdi"
      pause
    else
      echo -e "${RED}[!] Geçersiz giriş. Lütfen geçerli bir IP ya da komut girin.${RESET}"
    fi
  done
}

### --- USERCAN MODÜLÜ ---

function usercan() {
  clear
  figlet "GTX USERSCAN" | lolcat
  echo -e "${MAGENTA}${BOLD}Kullanıcı adı tarama aracı${RESET}"
  echo -e "${YELLOW}Eğitim amaçlıdır. Çıkmak için 'q' basınız.\n${RESET}"

  platformlar=(
    "Instagram:https://www.instagram.com/"
    "GitHub:https://github.com/"
    "Twitter:https://twitter.com/"
    "Facebook:https://www.facebook.com/"
    "TikTok:https://www.tiktok.com/@"
    "Reddit:https://www.reddit.com/user/"
    "YouTube:https://www.youtube.com/@"
    "Kick:https://kick.com/"
    "Pinterest:https://www.pinterest.com/"
    "Twitch:https://www.twitch.tv/"
    "Snapchat:https://www.snapchat.com/add/"
    "Telegram:https://t.me/"
    "Discord:https://discordapp.com/users/"
    "Steam:https://steamcommunity.com/id/"
    "Medium:https://medium.com/@"
    "LinkedIn:https://www.linkedin.com/in/"
    "Vimeo:https://vimeo.com/"
    "Dailymotion:https://www.dailymotion.com/"
    "Flickr:https://www.flickr.com/people/"
    "DeviantArt:https://www.deviantart.com/"
    "Goodreads:https://www.goodreads.com/user/show/"
    "SoundCloud:https://soundcloud.com/"
    "Badoo:https://badoo.com/profile/"
    "Flipboard:https://flipboard.com/@"
    "Gab:https://gab.com/"
    "Mixcloud:https://www.mixcloud.com/"
    "Mastodon:https://mastodon.social/@"
    "Caffeine:https://www.caffeine.tv/"
    "Ello:https://ello.co/"
    "Letterboxd:https://letterboxd.com/"
  )

  while true; do
    read -rp "Kullanıcı adı (q çıkış): " kullanici
    [[ "$kullanici" == "q" ]] && break

    echo -e "${CYAN}Sosyal medya platformlarında arama başlıyor...${RESET}\n"

    for site in "${platformlar[@]}"; do
      isim=$(echo "$site" | cut -d":" -f1)
      url=$(echo "$site" | cut -d":" -f2-)
      tam_url="${url}${kullanici}"

      http_code=$(curl -s -L -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (compatible; GTX-PRO/3.0)" "$tam_url")

      if [[ "$http_code" =~ ^2|3 ]]; then
        echo -e "${GREEN}[✓] $isim bulundu: $tam_url${RESET}"
      else
        echo -e "${RED}[✗] $isim bulunamadı.${RESET}"
      fi
      sleep 0.1
    done

    echo ""
  done
}

### --- X-OSINT MODÜLÜ ---

function x_osint() {
  clear
  figlet "GTX X-OSINT" | lolcat
  echo -e "${YELLOW}Gelişmiş OSINT Aracı - Domain/IP Bilgisi Toplama${RESET}\n"

  while true; do
    read -rp "Domain veya IP adresi gir (q çıkış): " hedef
    [[ "$hedef" == "q" ]] && break

    echo -e "${MAGENTA}Whois bilgileri (ilk 40 satır):${RESET}"
    whois "$hedef" 2>/dev/null | head -40

    echo -e "\n${CYAN}Traceroute (ilk 10 hop):${RESET}"
    traceroute -m 10 "$hedef" 2>/dev/null | head -15

    echo -e "\n${YELLOW}DNS Kayıtları:${RESET}"
    echo -e "${GREEN}A Kayıtları:${RESET}"
    dig +short A "$hedef"
    echo -e "${GREEN}MX Kayıtları:${RESET}"
    dig +short MX "$hedef"
    echo -e "${GREEN}NS Kayıtları:${RESET}"
    dig +short NS "$hedef"
    echo -e "${GREEN}TXT Kayıtları:${RESET}"
    dig +short TXT "$hedef"

    echo -e "\n${CYAN}Nslookup sonucu:${RESET}"
    nslookup "$hedef"

    pause
  done
}

### --- ADMIN PANEL FINDER ---

function admin_finder() {
  read -rp "Hedef site (http:// veya https://): " site
  [[ -z "$site" ]] && { echo -e "${RED}Site boş olamaz.${RESET}"; pause; return; }

  site="${site%/}"
  domain=$(echo "$site" | awk -F/ '{print $1"//"$3}')

  paneller=(
    "admin"
    "admin/login"
    "admin.php"
    "admin/index.php"
    "panel"
    "cpanel"
    "wp-admin"
    "login"
    "user"
    "dashboard"
  )

  echo ""
  echo -e "${YELLOW}Admin paneller $domain altında aranıyor...${RESET}\n"

  for yol in "${paneller[@]}"; do
    tam_url="${domain}/${yol}"
    kod=$(curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (compatible; GTX-PRO/3.0)" "$tam_url")
    if [[ "$kod" == "200" ]]; then
      echo -e "${GREEN}[✓] Panel bulundu: $tam_url${RESET}"
    else
      echo -e "${RED}[✗] Bulunamadı: $tam_url${RESET}"
    fi
  done
  echo ""
  pause
}

### --- EXPLOIT SCANNER ---

function exploit_scanner() {
  read -rp "Exploit anahtar kelimesi (örn: apache): " kelime
  [[ -z "$kelime" ]] && { echo -e "${RED}Anahtar kelime boş olamaz.${RESET}"; pause; return; }

  echo -e "${CYAN}Exploit araması yapılıyor...${RESET}"

  # Basit Exploit-DB araması, site yapısı değişirse kırılabilir
  curl -s "https://www.exploit-db.com/search?description=$kelime" \
    | grep -Eo '/exploits/[0-9]+' | sort -u | head -10 | while read -r path; do
    echo "https://www.exploit-db.com$path"
  done

  echo ""
  pause
}

### --- MENÜ ---

function menu() {
  while true; do
    banner
    echo -e "${GREEN}1) IP-Tracer (IP konumu, VPN kontrol, port tarama vs.)"
    echo "2) Usercan (30+ sosyal medya kullanıcı adı araması)"
    echo "3) X-OSINT (Domain/IP detaylı bilgileri)"
    echo "4) Admin Panel Finder (Popüler admin sayfalarını tarar)"
    echo "5) Exploit Scanner (Exploit-DB basit araması)"
    echo "6) Çıkış"
    echo -ne "\n${CYAN}Seçiminiz: ${RESET}"
    read -r secim
    case $secim in
      1) ip_tracer ;;
      2) usercan ;;
      3) x_osint ;;
      4) admin_finder ;;
      5) exploit_scanner ;;
      6) echo -e "${YELLOW}Çıkış yapılıyor...${RESET}"; exit 0 ;;
      *) echo -e "${RED}Geçersiz seçim! Tekrar deneyin.${RESET}"; sleep 1 ;;
    esac
  done
}

menu