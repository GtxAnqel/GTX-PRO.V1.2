#!/bin/bash

# Renkler
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Banner fonksiyonu
function banner() {
  clear
  figlet -c GTX-PRO.V1.2 | lolcat
  echo -e "${CYAN}Termux Etik Hacker Aracı - GtxAnqel Tarafından${RESET}"
  echo "----------------------------------------------"
}

# Pause fonksiyonu
function pause() {
  read -p "Devam etmek için Enter'a bas..."
}

# IP-Tracer fonksiyonu
function ip_tracer() {
  clear
  figlet "GTX IP-TRACER" | lolcat
  echo ""
  echo -e "${YELLOW}---------------------------------------------${RESET}"
  echo -e "               ${GREEN}KULLANIM KILAVUZU${RESET}"
  echo -e "${YELLOW}---------------------------------------------${RESET}"
  echo -e "${CYAN}GTX-MN${RESET} yazarsanız tekrar kullanım kılavuzuna ulaşırsınız."
  echo -e "${GREEN}GTX-M${RESET} yazarsanız kendi IP adresinize bakarsınız."
  echo -e "Lütfen ${CYAN}78.225.178.98${RESET} veya ${CYAN}4.6.2.6${RESET} gibi IP'ler girin."
  echo ""
  echo -e "Bu araç ${RED}GtxAnqel${RESET} tarafından Türkçe ve yerli yapılmıştır."
  echo -e "Herkese saygılarımla."
  echo ""

  while true; do
    read -p $'\033[33m🔍 IP adresi ya da komut (GTX-M / GTX-MN / q çıkış): \033[0m' girdi

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

# IP bilgisi gösterme fonksiyonu
function bilgi_goster() {
  ip="$1"
  echo -e "${YELLOW}[!] Bilgiler alınıyor... Lütfen bekleyin.${RESET}"

  data=$(curl -s "http://ip-api.com/json/$ip?fields=status,country,regionName,city,district,zip,lat,lon,org,query,message")

  status=$(echo "$data" | jq -r '.status')

  if [[ "$status" != "success" ]]; then
    message=$(echo "$data" | jq -r '.message')
    echo -e "${RED}[!] Hata: $message${RESET}"
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

  [[ "$district" == "null" ]] && district="Bilinmiyor"
  [[ "$zip" == "null" ]] && zip="Bilinmiyor"

  # VPN kontrol (org içinde VPN, Proxy kelimeleri var mı)
  if [[ "$org" =~ (VPN|Proxy|proxy|vpn) ]]; then
    vpn_status="${RED}VPN veya Proxy kullanıyorsunuz!${RESET}"
  else
    vpn_status="${GREEN}VPN kullanmıyorsunuz.${RESET}"
  fi

  echo -e "${GREEN}IP BİLGİSİ:"
  echo -e "  IP        : $query_ip"
  echo -e "  ISP       : $org"
  echo -e "  VPN Durumu: $vpn_status"
  echo -e "  Ülke      : $country"
  echo -e "  Bölge     : $region"
  echo -e "  Şehir     : $city"
  echo -e "  İlçe      : $district"
  echo -e "  Posta Kodu: $zip"
  echo -e "  Koordinat : $lat, $lon"
  echo -e "  Harita    : https://maps.google.com/?q=$lat,$lon"
  echo ""
}

# Usercan fonksiyonu
function usercan() {
  clear
  figlet "GTX USERSCAN" | lolcat

  echo -e "\033[36mBu araç GtxAnqel tarafından geliştirilmiştir."
  echo -e "Tamamen yerli ve Türkçe hazırlanmıştır. Eğitim amaçlıdır.\033[0m"
  echo "────────────────────────────────────────────────────"
  echo ""

  function kullanici_kilavuzu {
    echo "╭──────────────── KULLANIM KILAVUZU ───────────────╮"
    echo "│ Bu araç girilen kullanıcı adının popüler         │"
    echo "│ sosyal medya platformlarında kullanılıp          │"
    echo "│ kullanılmadığını kontrol eder.                    │"
    echo "│                                                  │"
    echo "│ Örnek Kullanım:                                  │"
    echo "│ ➤ Kullanıcı Adı: gtxangel                        │"
    echo "│ ➤ Platformlarda arama yapar                       │"
    echo "│                                                  │"
    echo "│ Komutlar:                                        │"
    echo "│ ➤ GTX-MN : Kullanım kılavuzunu gösterir          │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""
  }

  platformlar=(
    "Instagram:https://www.instagram.com/"
    "Twitter:https://www.twitter.com/"
    "GitHub:https://www.github.com/"
    "Facebook:https://www.facebook.com/"
    "TikTok:https://www.tiktok.com/@"
    "Reddit:https://www.reddit.com/user/"
    "YouTube:https://www.youtube.com/@"
    "Kick:https://kick.com/"
  )

  while true; do
    read -p "🔍 Sorgulamak istediğiniz kullanıcı adı ya da komut (GTX-MN): " kullanici

    if [[ "$kullanici" == "GTX-MN" ]]; then
      kullanici_kilavuzu
      continue
    fi

    echo -e "\033[33mSosyal medya taraması başlatılıyor...\033[0m"
    echo ""

    for site in "${platformlar[@]}"; do
      isim=$(echo "$site" | cut -d":" -f1)
      url=$(echo "$site" | cut -d":" -f2-)
      tam_url="${url}${kullanici}"

      http_status=$(curl -s -L -o /dev/null -w "%{http_code}" "$tam_url")

      if [[ "$http_status" =~ ^2[0-9][0-9]$ || "$http_status" =~ ^3[0-9][0-9]$ ]]; then
        echo -e "\033[32m[✓] $isim bulundu: $tam_url\033[0m"
      else
        echo -e "\033[31m[✗] $isim bulunamadı.\033[0m"
      fi
      sleep 0.2
    done

    echo ""
    echo -e "\033[36mGTX USERSCAN tarama tamamlandı.\033[0m"

    read -p "🔄 Tekrar arama yapmak ister misin? (e/h): " cevap
    case "$cevap" in
      [eE]) continue ;;
      *) echo "Çıkış yapılıyor."; break ;;
    esac
  done
}

# X-OSINT fonksiyonu
function x_osint() {
  clear
  figlet "GTX X-OSINT" | lolcat
  echo -e "${YELLOW}Basit OSINT aracı - domain ve IP bilgisi toplama${RESET}"
  echo ""

  while true; do
    read -p "Domain veya IP adresi gir (q ile çık): " target
    if [[ "$target" == "q" ]]; then
      break
    fi

    echo -e "${CYAN}Whois bilgileri:${RESET}"
    whois $target | head -40

    echo -e "\n${CYAN}Traceroute (ilk 10 hop):${RESET}"
    traceroute -m 10 $target

    echo -e "\n${CYAN}DNS sorgusu:${RESET}"
    nslookup $target

    pause
  done
}

# Menü fonksiyonu
function menu() {
  while true; do
    banner
    echo -e "${GREEN}1) IP-Tracer (VPN kontrol dahil)"
    echo "2) Usercan (Sosyal medya kullanıcı adı arama)"
    echo "3) X-OSINT (Domain/IP bilgileri)"
    echo "4) Çıkış"
    echo -n -e "${CYAN}Seçiminiz: ${RESET}"
    read secim

    case $secim in
      1) ip_tracer ;;
      2) usercan ;;
      3) x_osint ;;
      4) echo "Çıkış yapılıyor..."; exit 0 ;;
      *) echo -e "${RED}Geçersiz seçim! Tekrar deneyin.${RESET}"; sleep 1 ;;
    esac
  done
}

# Program başlat
menu