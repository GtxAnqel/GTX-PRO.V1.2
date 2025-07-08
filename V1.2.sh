#!/bin/bash

Renkler

RED='\033[1;31m' GREEN='\033[1;32m' CYAN='\033[1;36m' YELLOW='\033[1;33m' MAGENTA='\033[1;35m' RESET='\033[0m' BOLD='\033[1m'

Banner fonksiyonu

function banner() { clear figlet -c GTX-PRO.V2 | lolcat echo -e "${CYAN}${BOLD}GtxAnqel tarafından geliştirilen Etik Hacker Aracı${RESET}" echo -e "${YELLOW}───────────────────────────────────────────────${RESET}" echo "" }

function pause() { read -rp "Devam etmek için Enter'a bas..." }

IP BİLGİSİ MODÜLÜ

function ip_tracer() { clear figlet "GTX IP-TRACER" | lolcat echo "" echo -e "${YELLOW}---------------------------------------------${RESET}" echo -e "               ${GREEN}KULLANIM KILAVUZU${RESET}" echo -e "${YELLOW}---------------------------------------------${RESET}" echo -e "${CYAN}GTX-MN${RESET} yazarsanız tekrar kullanım kılavuzuna ulaşırsınız." echo -e "${GREEN}GTX-M${RESET} yazarsanız kendi IP adresinize bakarsınız." echo "" echo -e "Bu araç ${RED}GtxAnqel${RESET} tarafından Türkçe ve yerli yapılmıştır." echo ""

while true; do read -rp $'\033[33m🔍 IP adresi ya da komut (GTX-M / GTX-MN / q çıkış): \033[0m' girdi

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

done }

function bilgi_goster() { ip="$1" echo -e "${YELLOW}[!] Bilgiler alınıyor...${RESET}" data=$(curl -s "http://ip-api.com/json/$ip?fields=status,country,regionName,city,org,query,as") status=$(echo "$data" | jq -r '.status')

if [[ "$status" != "success" ]]; then echo -e "${RED}Hata: IP bilgisi alınamadı.${RESET}" return fi

echo -e "${GREEN}${BOLD}IP BİLGİSİ:${RESET}" echo -e "  IP     : $(echo "$data" | jq -r '.query')" echo -e "  Ülke   : $(echo "$data" | jq -r '.country')" echo -e "  Bölge  : $(echo "$data" | jq -r '.regionName')" echo -e "  Şehir  : $(echo "$data" | jq -r '.city')" echo -e "  ISP    : $(echo "$data" | jq -r '.org')" echo -e "  ASN    : $(echo "$data" | jq -r '.as')" echo "" }

USERSCAN MODÜLÜ

function usercan() { clear figlet "GTX USERSCAN" | lolcat echo -e "\033[36mKullanıcı adı tarayıcı. Eğitim amaçlı.\033[0m" platformlar=( "Instagram:https://www.instagram.com/" "GitHub:https://www.github.com/" "Facebook:https://www.facebook.com/" "Twitter:https://www.twitter.com/" "TikTok:https://www.tiktok.com/@" "Reddit:https://www.reddit.com/user/" ) echo "" read -rp "Kullanıcı adı: " kullanici echo "" for site in "${platformlar[@]}"; do isim=$(echo "$site" | cut -d":" -f1) url=$(echo "$site" | cut -d":" -f2-) full_url="${url}${kullanici}" http_code=$(curl -s -o /dev/null -w "%{http_code}" "$full_url") if [[ "$http_code" =~ ^2|3 ]]; then echo -e "\033[32m[✓] $isim bulundu: $full_url\033[0m" else echo -e "\033[31m[✗] $isim bulunamadı.\033[0m" fi done echo "" pause }

X-OSINT MODÜLÜ

function x_osint() { clear figlet "GTX X-OSINT" | lolcat read -rp "Domain/IP: " hedef echo -e "${YELLOW}Whois Bilgisi:${RESET}" whois "$hedef" | head -20 echo -e "\n${YELLOW}DNS Kayıtları:${RESET}" dig "$hedef" ANY +short echo "" pause }

ADMIN PANEL FINDER

function admin_finder() { read -rp "Hedef site (http://...): " site paneller=("admin" "admin/login" "admin.php" "admin/index.php" "panel" "cpanel") for yol in "${paneller[@]}"; do tam_url="${site}/${yol}" kod=$(curl -s -o /dev/null -w "%{http_code}" "$tam_url") if [[ "$kod" == "200" ]]; then echo -e "\033[32m[✓] Panel bulundu: $tam_url\033[0m" fi done echo "" pause }

EXPLOIT SCANNER

function exploit_scanner() { read -rp "Exploit anahtar kelimesi (örn: apache): " kelime echo -e "${CYAN}Exploit araması yapılıyor...${RESET}" curl -s "https://www.exploit-db.com/search?description=$kelime" | grep -Eo '/exploits/[0-9]+' | head -5 | while read -r path; do echo "https://www.exploit-db.com$path" done echo "" pause }

function menu() { while true; do banner echo -e "${GREEN}1) IP-Tracer" echo "2) Usercan" echo "3) X-OSINT" echo "4) Admin Panel Finder" echo "5) Exploit Scanner" echo "6) Çıkış" echo -ne "\n${CYAN}Seçiminiz: ${RESET}" read -r secim case $secim in 1) ip_tracer;; 2) usercan;; 3) x_osint;; 4) admin_finder;; 5) exploit_scanner;; 6) echo -e "${YELLOW}Çıkış yapılıyor...${RESET}"; exit 0;; *) echo -e "${RED}Geçersiz seçim!${RESET}"; sleep 1;; esac done }

menu

