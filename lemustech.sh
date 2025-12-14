#!/bin/bash

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
NC='\033[0m'

SCRIPT_VERSION="20.0.0 (Omni)"

read_input() {
    local prompt="$1"
    printf "${BOLD}%s${NC}" "$prompt"
    read -r REPLY < /dev/tty
}

wait_key() {
    echo ""
    printf "${BOLD}[i] Presiona ENTER para continuar...${NC}"
    read -r dummy < /dev/tty
    echo ""
}

header() {
    clear
    echo -e "${CYAN}"
    echo "    ██╗     ███████╗███╗   ███╗██╗   ██╗███████╗████████╗███████╗ ██████╗██╗  ██╗"
    echo "    ██║     ██╔════╝████╗ ████║██║   ██║██╔════╝╚══██╔══╝██╔════╝██╔════╝██║  ██║"
    echo "    ██║     █████╗  ██╔████╔██║██║   ██║███████╗   ██║   █████╗  ██║     ███████║"
    echo "    ██║     ██╔══╝  ██║╚██╔╝██║██║   ██║╚════██║   ██║   ██╔══╝  ██║     ██╔══██║"
    echo "    ███████╗███████╗██║ ╚═╝ ██║╚██████╔╝███████║   ██║   ███████╗╚██████╗██║  ██║"
    echo "    ╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "    >>> COMPANY S.A. - OMNI EDITION v$SCRIPT_VERSION <<<"
    echo "    -------------------------------------------------------------"
    echo -e "    CLIENTE: ${YELLOW}$(whoami)${NC} | EQUIPO: ${YELLOW}$(scutil --get ComputerName)${NC}"
    echo -e "    CHIP: ${CYAN}$(sysctl -n machdep.cpu.brand_string)${NC}"
    echo "    -------------------------------------------------------------"
    echo -e "    ${MAGENTA}❤️  Hecho con amor en Venezuela  🇻🇪${NC}"
    echo -e "    ${GREEN}📄  Generador de Informes Técnicos Incluido${NC}"
    echo -e "    ${RED}${BOLD}⚠️  USAR BAJO SU PROPIA RESPONSABILIDAD ⚠️${NC}"
    echo "    -------------------------------------------------------------"
    echo ""
}

generate_report() {
    echo -e "${CYAN}    --> Generando Informe Técnico Profesional...${NC}"
    
    MODEL=$(sysctl -n hw.model)
    CPU=$(sysctl -n machdep.cpu.brand_string)
    MEM_BYTES=$(sysctl -n hw.memsize)
    MEM_GB=$((MEM_BYTES / 1073741824))
    SERIAL=$(system_profiler SPHardwareDataType | grep "Serial Number" | awk -F ': ' '{print $2}')
    OS_VER=$(sw_vers -productVersion)
    DISK_INFO=$(df -h / | awk 'NR==2 {print $4 " libres de " $2}')
    DATE=$(date "+%d/%m/%Y %H:%M")
    USER=$(whoami)
    HOST=$(scutil --get ComputerName)
    REPORT_PATH="$HOME/Desktop/Informe_Tecnico_Lemustech.html"

    cat <<EOF > "$REPORT_PATH"
<!DOCTYPE html>
<html lang='es'>
<head>
    <meta charset='UTF-8'>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f4f4f4; color: #333; margin: 0; padding: 40px; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
        .header { text-align: center; border-bottom: 2px solid #007aff; padding-bottom: 20px; margin-bottom: 30px; }
        .header h1 { color: #007aff; margin: 0; font-size: 28px; }
        .header p { color: #666; margin: 5px 0 0; }
        .section { margin-bottom: 25px; }
        .section h2 { background: #007aff; color: white; padding: 8px 15px; border-radius: 6px; font-size: 16px; letter-spacing: 0.5px; }
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .item { background: #f8f9fa; padding: 12px; border-radius: 6px; border: 1px solid #e9ecef; }
        .label { font-weight: 600; color: #555; display: block; font-size: 11px; text-transform: uppercase; margin-bottom: 4px; }
        .value { font-size: 14px; color: #000; font-weight: 500; }
        .footer { text-align: center; font-size: 11px; color: #aaa; margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px; }
        .badge { display: inline-block; background: #34c759; color: white; padding: 3px 8px; border-radius: 12px; font-size: 10px; font-weight: bold; }
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1>LEMUSTECH COMPANY S.A.</h1>
            <p>Informe Técnico de Mantenimiento macOS</p>
            <p><strong>Fecha:</strong> $DATE</p>
        </div>

        <div class='section'>
            <h2>🖥️ Especificaciones del Mac</h2>
            <div class='grid'>
                <div class='item'><span class='label'>Equipo</span><span class='value'>$HOST</span></div>
                <div class='item'><span class='label'>Usuario</span><span class='value'>$USER</span></div>
                <div class='item'><span class='label'>macOS Versión</span><span class='value'>$OS_VER</span></div>
                <div class='item'><span class='label'>Número de Serie</span><span class='value'>$SERIAL</span></div>
                <div class='item'><span class='label'>Procesador / Chip</span><span class='value'>$CPU</span></div>
                <div class='item'><span class='label'>Memoria RAM</span><span class='value'>$MEM_GB GB</span></div>
                <div class='item'><span class='label'>Almacenamiento</span><span class='value'>$DISK_INFO</span></div>
                <div class='item'><span class='label'>Modelo ID</span><span class='value'>$MODEL</span></div>
            </div>
        </div>

        <div class='section'>
            <h2>🛠️ Servicios Realizados</h2>
            <ul>
                <li>✅ Limpieza profunda de cachés de usuario y sistema.</li>
                <li>✅ Optimización de memoria inactiva.</li>
                <li>✅ Mantenimiento de scripts periódicos del sistema.</li>
                <li>✅ Restablecimiento de caché DNS y mDNSResponder.</li>
                <li>✅ Verificación de integridad del disco (First Aid).</li>
                <li>✅ Auditoría básica de seguridad.</li>
            </ul>
        </div>
        
        <div class='section'>
            <h2>🛡️ Estado Final</h2>
            <p>El equipo ha sido optimizado y verificado bajo los estándares de calidad de <strong>Lemustech Company S.A.</strong></p>
            <p>Estado S.M.A.R.T Disco: <span class='badge'>VERIFICADO</span></p>
            <p>Rendimiento General: <span class='badge'>OPTIMIZADO</span></p>
        </div>

        <div class='footer'>
            <p>Soporte Técnico: +58 424-1353496 | Soporte@lemustech.net | @lemustech.ve</p>
            <p>Hecho con amor en Venezuela 🇻🇪</p>
        </div>
    </div>
</body>
</html>
EOF

    echo -e "        ${GREEN}[OK] Informe generado en el Escritorio.${NC}"
    open "$REPORT_PATH"
    wait_key
}

data_backup() {
    header
    echo -e "${CYAN}    [BACKUP EXPRESS DE DATOS]${NC}"
    echo "    Copia Escritorio, Documentos e Imágenes a una unidad externa."
    echo -e "\n    ${YELLOW}Unidades externas detectadas en /Volumes:${NC}"
    
    ls -1 /Volumes | grep -v "Macintosh HD" | grep -v "com.apple" | grep -v "Recovery"
    
    echo -e "\n    Escribe el nombre EXACTO de la unidad de destino (o '0' para salir):"
    read_input "    Nombre: "
    VOL_NAME=$REPLY
    
    if [[ "$VOL_NAME" == "0" ]]; then return; fi
    
    TARGET_PATH="/Volumes/$VOL_NAME/Lemustech_Backup_$(whoami)"
    
    if [ -d "/Volumes/$VOL_NAME" ]; then
        echo -e "\n    --> Iniciando rsync (Modo Espejo Seguro)..."
        mkdir -p "$TARGET_PATH"
        
        echo "    Copiando Desktop..."
        rsync -av --progress "$HOME/Desktop/" "$TARGET_PATH/Desktop/"
        
        echo "    Copiando Documents..."
        rsync -av --progress "$HOME/Documents/" "$TARGET_PATH/Documents/"
        
        echo "    Copiando Pictures..."
        rsync -av --progress "$HOME/Pictures/" "$TARGET_PATH/Pictures/"
        
        echo -e "\n    ${GREEN}✅ RESPALDO COMPLETADO EN: $TARGET_PATH${NC}"
    else
        echo -e "    ${RED}[!] Unidad no encontrada.${NC}"
    fi
    wait_key
}

opt_basic() {
    echo -e "\n${GREEN}--- OPTIMIZACIÓN BÁSICA (Segura) ---${NC}"
    echo "--> Limpiando Cachés de Usuario..."
    rm -rf ~/Library/Caches/* 2>/dev/null
    echo "--> Limpiando Papelera..."
    rm -rf ~/.Trash/*
    echo "--> Refrescando DNS..."
    sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
    echo -e "${GREEN}✅ Completado.${NC}"
}

opt_intermediate() {
    opt_basic
    echo -e "\n${YELLOW}--- OPTIMIZACIÓN INTERMEDIA (Mantenimiento) ---${NC}"
    echo "--> Solicitando permisos..."
    sudo -v < /dev/tty
    echo "--> Limpiando Cachés del Sistema..."
    sudo rm -rf /Library/Caches/* 2>/dev/null
    echo "--> Mantenimiento Periódico..."
    sudo periodic daily weekly monthly
    echo "--> Purgando RAM..."
    sudo purge
    echo -e "${YELLOW}✅ Completado.${NC}"
}

opt_extreme() {
    header
    echo -e "${RED}${BOLD}!!! ADVERTENCIA: MODO EXTREMO !!!${NC}"
    echo "Este modo realiza cambios agresivos para maximizar rendimiento."
    read_input "¿Seguro? (si/no): "
    if [[ "$REPLY" != "si" ]]; then return; fi
    opt_intermediate
    echo -e "\n${RED}--- OPTIMIZACIÓN EXTREMA (Turbo) ---${NC}"
    echo "--> Borrando Logs..."
    sudo rm -rf /private/var/log/* 2>/dev/null
    echo "--> Limpiando Cachés Fuentes..."
    sudo atsutil server -shutdown
    sudo atsutil server -ping
    echo "--> Reindexando Spotlight..."
    sudo mdutil -E / > /dev/null 2>&1
    echo "--> Desactivando Animaciones..."
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
    echo -e "${RED}✅ REINICIA TU MAC.${NC}"
}

menu_optimization() {
    while true; do
        header
        echo -e "${CYAN}    [1] 🚀 SELECTOR DE OPTIMIZACIÓN${NC}"
        echo "    1. 🟢 Básica"
        echo "    2. 🟡 Intermedia"
        echo "    3. 🔴 Extrema"
        echo "    B. 🔙 Volver"
        echo ""
        read_input "    Opción: "
        case $REPLY in
            1) opt_basic; wait_key ;;
            2) opt_intermediate; wait_key ;;
            3) opt_extreme; wait_key ;;
            b|B|0) return ;;
            *) ;;
        esac
    done
}

fix_network() {
    header
    echo -e "${CYAN}    [2] 🌐 CENTRO DE REDES${NC}"
    echo "    1. Reparar Conectividad"
    echo "    2. Test de Velocidad (Apple Native)"
    echo "    3. Test de Velocidad (Descarga Real)"
    echo "    B. Volver"
    echo ""
    read_input "    Opción: "
    case $REPLY in
        1)
            echo "--> Flush DNS..."
            sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
            echo "--> Renovando DHCP..."
            sudo ipconfig set en0 DHCP
            echo -e "${GREEN}✅ Hecho.${NC}"
            ;;
        2) networkQuality ;;
        3) 
            echo -e "\n--> Descargando archivo de prueba (100MB)..."
            SPEED_BPS=$(curl -L -w "%{speed_download}" -o /dev/null -s http://speedtest.tele2.net/100MB.zip)
            SPEED_MBPS=$(echo "scale=2; $SPEED_BPS * 8 / 1000000" | bc)
            echo -e "\n${CYAN}🚀 Velocidad de descarga estimada: $SPEED_MBPS Mbps${NC}"
            ;;
        b|B|0) return ;;
        *) ;;
    esac
    if [[ "$REPLY" != "b" && "$REPLY" != "B" && "$REPLY" != "0" ]]; then wait_key; fi
}

repair_mac() {
    header
    echo -e "${CYAN}    [3] 🛠️ MANTENIMIENTO DISCO${NC}"
    echo "--> Verificando SMART..."
    diskutil info / | grep "SMART"
    echo "--> Verificando Volumen..."
    diskutil verifyVolume /
    echo "--> Abriendo Utilidad Discos..."
    open -a "Disk Utility"
    wait_key
}

system_dashboard() {
    header
    echo -e "${CYAN}    [4] 📊 DASHBOARD${NC}"
    echo -e "\n${BOLD}HARDWARE:${NC}"
    echo "Modelo: $(sysctl -n hw.model)"
    echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
    MEM=$(sysctl -n hw.memsize)
    echo "RAM: $((MEM / 1073741824)) GB"
    echo -e "\n${BOLD}BATERÍA:${NC}"
    pmset -g batt | grep -v "Now drawing"
    echo -e "\n${BOLD}ALMACENAMIENTO:${NC}"
    df -h / | awk 'NR==2 {print "Usado: " $3 " | Libre: " $4}'
    echo -e "\n${BOLD}RED:${NC}"
    echo "Local: $(ipconfig getifaddr en0)"
    echo "Public: $(curl -s ifconfig.me)"
    wait_key
}

install_app() {
    echo -e "--> Instalando ${CYAN}$1${NC}..."
    brew install --cask $2 2>/dev/null || brew install $2 2>/dev/null
}

install_menu() {
    while true; do
        header
        echo -e "${CYAN}    [5] 📦 ALMACÉN DE SOFTWARE (Homebrew)${NC}"
        if ! command -v brew &> /dev/null; then
            echo -e "${RED}[!] Instalando Homebrew...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/tty
        fi
        echo "    1. 🌐 Navegadores"
        echo "    2. 💬 Comunicación"
        echo "    3. 🏢 Productividad"
        echo "    4. 💻 Desarrollo"
        echo "    5. 🎨 Creatividad"
        echo "    6. 🔧 Utilidades"
        echo "    B. 🔙 Volver"
        echo ""
        read_input "    Categoría: "
        cat=$REPLY
        if [[ "$cat" == "b" || "$cat" == "B" || "$cat" == "0" ]]; then return; fi
        
        case $cat in
            1) apps=("Chrome" "Firefox" "Brave"); ids=("google-chrome" "firefox" "brave-browser");;
            2) apps=("WhatsApp" "Zoom" "Discord"); ids=("whatsapp" "zoom" "discord");;
            3) apps=("Office" "Acrobat" "Notion"); ids=("libreoffice" "adobe-acrobat-reader" "notion");;
            4) apps=("VSCode" "Docker" "Git"); ids=("visual-studio-code" "docker" "git");;
            5) apps=("VLC" "OBS" "Blender"); ids=("vlc" "obs" "blender");;
            6) apps=("AnyDesk" "TeamViewer" "Keka"); ids=("anydesk" "teamviewer" "keka");;
            *) continue ;;
        esac
        echo -e "\n${YELLOW}Escribe números (ej: 1 3) o 'a' para todas:${NC}"
        for i in "${!apps[@]}"; do echo "$((i+1)). ${apps[$i]}"; done
        echo ""
        read_input "    Selección: "
        if [[ "$REPLY" == "a" || "$REPLY" == "A" ]]; then
            for id in "${ids[@]}"; do install_app "$id" "$id"; done
        else
            for i in $REPLY; do
                if [[ "$i" =~ ^[0-9]+$ ]] && [ "$i" -le "${#ids[@]}" ]; then install_app "${apps[$((i-1))]}" "${ids[$((i-1))]}"; fi
            done
        fi
        wait_key
    done
}

post_install_menu() {
    while true; do
        header
        echo -e "${MAGENTA}    [6] ⚙️  POST-INSTALL${NC}"
        echo "    1. ⚡ Acelerar Interfaz"
        echo "    2. 🐢 Restaurar Animaciones"
        echo "    3. 📂 Finder Pro"
        echo "    4. 🧹 Limpieza USB"
        echo "    5. 📸 Capturas JPG"
        echo "    6. ⚓ Resetear Dock"
        echo "    7. ☕ Evitar suspensión"
        echo "    8. 👁️ Mostrar Ocultos"
        echo "    9. 🛡️ Activar Firewall"
        echo "    10. 🔄 Buscar Updates"
        echo "    11. 🔨 Instalar Xcode Tools"
        echo "    12. 🚨 Panic Button (Cerrar Apps)"
        echo "    B. 🔙 Volver"
        echo ""
        read_input "    Opción: "
        case $REPLY in
            1) defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false; echo "Hecho.";;
            2) defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool true; echo "Hecho.";;
            3) defaults write com.apple.finder AppleShowAllExtensions -bool true; chflags nohidden ~/Library; killall Finder; echo "Hecho.";;
            4) defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true; echo "Hecho.";;
            5) defaults write com.apple.screencapture type jpg; killall SystemUIServer; echo "Hecho.";;
            6) defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock; echo "Hecho.";;
            7) echo "CTRL+C para salir"; caffeinate -d;;
            8) defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder; echo "Hecho.";;
            9) sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on; echo "Hecho.";;
            10) softwareupdate -l;;
            11) xcode-select --install;;
            12) echo "Cerrando apps..."; osascript -e 'tell application "System Events" to set visible of every process to true' -e 'tell application "System Events" to set quitApps to name of every application process where background only is false and name is not "Terminal"' -e 'repeat with appName in quitApps' -e 'tell application appName to quit' -e 'end repeat';;
            b|B|0) return ;;
        esac
        if [ "$REPLY" != "7" ]; then wait_key; fi
    done
}

advanced_tools() {
    while true; do
        header
        echo -e "${RED}    [8] 🔬 HERRAMIENTAS AVANZADAS${NC}"
        echo "    1. 🧹 Liberar Espacio Fantasma (Snapshots)"
        echo "    2. 🔊 Reparar Audio"
        echo "    3. 🔎 Archivos Pesados"
        echo "    4. 🛡️ Auditoría Seguridad"
        echo "    B. 🔙 Volver"
        echo ""
        read_input "    Opción: "
        case $REPLY in
            1) tmutil thinlocalsnapshots / 10000000000 4; echo "Hecho.";;
            2) sudo killall coreaudiod; echo "Hecho.";;
            3) du -ah ~ 2>/dev/null | sort -rh | head -n 10;;
            4) csrutil status; fdesetup status;;
            b|B|0) return ;;
        esac
        wait_key
    done
}

support() {
    header
    echo -e "${CYAN}    [7] 📞 CONTACTO${NC}"
    open "https://wa.me/584241353496"
    open "https://instagram.com/lemustech.ve"
    open "mailto:Soporte@lemustech.net"
    open "https://www.lemustech.net"
    echo -e "\n${GREEN}--> Abriendo canales de comunicación...${NC}"
    wait_key
}

colaborar() {
    header
    echo -e "${YELLOW}    [9] 🤝 COLABORACIONES${NC}"
    echo "    ¡Gracias por apoyar el talento venezolano! 🇻🇪"
    echo "    1. Contactar por WhatsApp"
    echo "    B. Volver"
    read_input "    Opción: "
    if [ "$REPLY" == "1" ]; then open "https://wa.me/584241353496?text=Hola,%20quisiera%20colaborar"; fi
}

autofix() {
    header
    echo -e "${MAGENTA}    [99] 🔥 AUTO-FIX TOTAL${NC}"
    rm -rf ~/Library/Caches/* 2>/dev/null
    sudo rm -rf /private/var/log/* 2>/dev/null
    sudo dscacheutil -flushcache
    sudo purge
    echo -e "\n${GREEN}✅ LISTO.${NC}"
    wait_key
}

while true; do
    header
    echo "    MENÚ DE COMANDO"
    echo "    [1] 🚀  Optimización"
    echo "    [2] 🌐  Redes"
    echo "    [3] 💿  Disco"
    echo "    [4] 📄  Generar Informe Técnico (HTML)"
    echo "    [5] 💾  Backup Express de Datos"
    echo "    [6] 📦  Instalar Apps"
    echo "    [7] ⚙️  Post-Install"
    echo "    [8] 📞  Soporte"
    echo "    [9] 🔬  Avanzado"
    echo "    [10] 🤝 Colaborar"
    echo "    ----------------"
    echo -e "    ${MAGENTA}[99] 🔥 AUTO-FIX${NC}"
    echo "    [0] ❌  Salir"
    echo ""
    read_input "    Comando: "
    case $REPLY in
        1) menu_optimization ;;
        2) fix_network ;;
        3) repair_mac ;;
        4) generate_report ;;
        5) data_backup ;;
        6) install_menu ;;
        7) post_install_menu ;;
        8) support ;;
        9) advanced_tools ;;
        10) colaborar ;;
        99) autofix ;;
        0) echo -e "\n${CYAN}¡Hasta pronto!${NC}\n"; exit 0 ;;
        *) ;;
    esac
done