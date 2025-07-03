#!/bin/bash

# Renkler
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

API_VT=""  # VirusTotal API anahtarını buraya yazabilirsin (opsiyonel)

function banner() {
  clear
  figlet -c GTX-PRO.V1.2
  echo -e "${CYAN}Termux Etik Hacker Aracı${RESET}"
  echo "-----------------------------------------"
}

function pause() {
  read -p "Devam etmek için Enter'a bas..."
}

# IP-Tracer Fonksiyonu
function ip_tracer() {
  clear
  banner
  read -p "IP veya Domain gir: " ip

  echo -e "${YELLOW}Bilgiler getiriliyor...${RESET}"
  data=$(curl -s "https://ipinfo.io/$ip/json")

  # VPN kontrolü için basit kontrol: ISP içinde 'VPN' veya 'Proxy' kelimeleri var mı?
  isp=$(echo $data | jq -r '.org')
  if [[ "$isp" =~ (VPN|Proxy|proxy|vpn) ]]; then
    vpn_status="${RED}VPN veya Proxy kullanıyorsunuz!${RESET}"
  else
    vpn_status="${GREEN}VPN kullanmıyorsunuz.${RESET}"
  fi

  echo "$data" | jq .
  echo -e "ISP Durumu: $vpn_status"
  pause
}

# Usercan (Kullanıcı adı arama)
function usercan() {
  clear
  banner
  read -p "Aranacak kullanıcı adı: " username

  sites=(
    "https://www.facebook.com/"
    "https://www.twitter.com/"
    "https://www.instagram.com/"
    "https://github.com/"
    "https://www.reddit.com/user/"
    "https://www.twitch.tv/"
    "https://www.pinterest.com/"
    "https://www.medium.com/@"
    "https://www.stackoverflow.com/users/"
    "https://www.linkedin.com/in/"
    "https://www.snapchat.com/add/"
    "https://www.tiktok.com/@"
    "https://www.quora.com/profile/"
    "https://www.deviantart.com/"
    "https://www.flickr.com/people/"
    "https://www.vimeo.com/"
    "https://www.tumblr.com/blog/view/"
    "https://www.goodreads.com/user/show/"
    "https://www.last.fm/user/"
    "https://www.behance.net/"
  )

  echo -e "${YELLOW}Kullanıcı adı aranıyor...${RESET}"

  for site in "${sites[@]}"; do
    url="${site}${username}"
    status=$(curl -o /dev/null -s -w "%{http_code}" "$url")
    if [[ "$status" == "200" ]]; then
      echo -e "${GREEN}Bulundu: $url${RESET}"
    else
      echo -e "${RED}Yok: $url${RESET}"
    fi
  done

  pause
}

# Sistem Açığı Bulma (Basit örnek)
function sistem_acigi() {
  clear
  banner
  echo -e "${YELLOW}Basit port taraması yapılıyor...${RESET}"
  read -p "Hedef IP gir: " target

  echo "Nmap yüklü değilse 'pkg install nmap' ile yükleyin."
  nmap $target

  pause
}

# Link Güvenliği Kontrol (VirusTotal API kullanır, opsiyonel)
function link_guvenligi() {
  clear
  banner
  read -p "Kontrol edilecek URL gir: " url

  if [[ -z "$API_VT" ]]; then
    echo -e "${RED}VirusTotal API anahtarı ayarlanmadı!${RESET}"
    echo "API anahtarı almak için https://www.virustotal.com/ adresine kaydol."
    pause
    return
  fi

  # URL base64 encode (VirusTotal API için)
  url_enc=$(echo -n $url | base64 | tr '/+' '_-' | tr -d '=')

  response=$(curl -s --request GET --url "https://www.virustotal.com/api/v3/urls/$url_enc" --header "x-apikey: $API_VT")

  echo $response | jq .

  pause
}

# Menü fonksiyonu
function menu() {
  while true; do
    banner
    echo -e "${GREEN}1) IP-Tracer (VPN kontrol dahil)"
    echo "2) Usercan (Kullanıcı adı arama 20+ site)"
    echo "3) Sistem Açığı Bulma (Port taraması)"
    echo "4) Link Güvenliği Kontrol (VirusTotal API ile)"
    echo "5) Çıkış"
    echo -n -e "${CYAN}Seçiminiz: ${RESET}"
    read secim

    case $secim in
      1) ip_tracer ;;
      2) usercan ;;
      3) sistem_acigi ;;
      4) link_guvenligi ;;
      5) echo "Çıkış yapılıyor..."; exit 0 ;;
      *) echo -e "${RED}Geçersiz seçim! Tekrar deneyin.${RESET}"; sleep 1 ;;
    esac
  done
}

menu