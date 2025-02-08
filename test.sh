#!/bin/bash
set -e

# Definice barev a emotikonů
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # Reset - žádná barva
CHECK_MARK="✅"
CROSS_MARK="❌"
INFO="ℹ️"

echo -e "\n${YELLOW}${INFO} Spouštím testy...${NC}\n"

# Test 1: Ověříme, že lokální složka "app" existuje.
if [ ! -d "./app" ]; then
  echo -e "${RED}${CROSS_MARK} ERROR: 'app' složka neexistuje v kořenovém adresáři projektu.${NC}"
  exit 1
else
  echo -e "${GREEN}${CHECK_MARK} Lokální složka 'app' existuje.${NC}"
fi

# Test 2: Ověříme, že Dockerfile obsahuje požadovaný ENV pro MESSAGE.
if ! grep -q 'ENV MESSAGE="Hello World from Flask"' Dockerfile; then
  echo -e "${RED}${CROSS_MARK} ERROR: Dockerfile neobsahuje požadovaný ENV pro MESSAGE.${NC}"
  exit 1
else
  echo -e "${GREEN}${CHECK_MARK} Dockerfile obsahuje požadovaný ENV pro MESSAGE.${NC}"
fi

# Test 3: Ověříme, že kontejner s názvem "dencapod" běží.
if ! docker ps --filter "name=^flasktest$" --format "{{.Names}}" | grep -q '^flasktest$'; then
  echo -e "${RED}${CROSS_MARK} ERROR: Kontejner s názvem 'flasktest' neběží.${NC}"
  exit 1
else
  echo -e "${GREEN}${CHECK_MARK} Kontejner 'flasktest' běží.${NC}"
fi

# Test 4: Ověříme, že na portu 8000 něco naslouchá (použijeme nc).
if ! nc -z localhost 8000; then
  echo -e "${RED}${CROSS_MARK} ERROR: Na portu 8000 nic neposlouchá.${NC}"
  exit 1
else
  echo -e "${GREEN}${CHECK_MARK} Connection to localhost port 8000 [tcp/irdmi] succeeded!${NC}"
  echo -e "${GREEN}${CHECK_MARK} Port 8000 je aktivní.${NC}"
fi

# Test 5: Ověříme, že curl požadavek na http://localhost:8000 vrací status 200 a očekávanou odpověď.
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" http://localhost:8000)
if [ "$HTTP_STATUS" -ne 200 ]; then
  echo -e "${RED}${CROSS_MARK} ERROR: curl vrátil status code $HTTP_STATUS místo 200.${NC}"
  exit 1
fi

RESPONSE=$(curl -s http://localhost:8000)
if [ "$RESPONSE" != "Hello World from Flask" ]; then
  echo -e "${RED}${CROSS_MARK} ERROR: Odpověď ze serveru není očekávaná. Dostali jsme: '$RESPONSE'${NC}"
  exit 1
fi
echo -e "${GREEN}${CHECK_MARK} curl vrátil status code 200 a správnou odpověď.${NC}"

echo -e "\n${GREEN}${CHECK_MARK} Všechny testy proběhly úspěšně.${NC}\n"
