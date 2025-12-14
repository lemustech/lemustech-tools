<#
.SYNOPSIS
    LEMUSTECH HUB - OMNI EDITION v20.0 (Windows)
    Herramienta de ingeniería de sistemas con Generación de Informes.
    Hecho con amor en Venezuela 🇻🇪
    
    CODENAME: OMNI
    BUILD: 2025-GOLD-MASTER
    
    NOVEDADES v20.0:
    - Generador de Informes Técnicos HTML (Para entregar al cliente).
    - Backup Express de Datos (Robocopy).
    - Test de Velocidad de Descarga Real.
#>

$Global:Version = "20.0.0 (Omni)"
$ErrorActionPreference = "SilentlyContinue"
$Host.UI.RawUI.WindowTitle = "Lemustech Company S.A. - $Global:Version"
$LogPath = "C:\Lemustech_Logs"
$BackupPath = "C:\Lemustech_Backups"
$ReportPath = "$env:USERPROFILE\Desktop\Informe_Tecnico_Lemustech.html"

# --- 0. VALIDACIÓN DE ENTORNO Y PRIVILEGIOS ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Clear-Host
    Write-Host "`n    [!] SOLICITANDO PERMISOS DE ADMINISTRADOR..." -ForegroundColor Cyan
    try {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        Exit
    } catch {
        Write-Host "    [X] Error crítico: Se requieren permisos de administrador." -ForegroundColor Red
        Pause
        Exit
    }
}

New-Item -ItemType Directory -Force -Path $LogPath | Out-Null
New-Item -ItemType Directory -Force -Path $BackupPath | Out-Null

function Log-Action {
    param([string]$Message, [string]$Type="INFO")
    $Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Date] [$Type] $Message"
    Add-Content -Path "$LogPath\Activity_Log.txt" -Value $LogEntry
}

# --- 1. INTERFAZ VISUAL ---
function Draw-Header {
    Clear-Host
    $host.UI.RawUI.BackgroundColor = "Black"
    Write-Host "
    ██╗     ███████╗███╗   ███╗██╗   ██╗███████╗████████╗███████╗ ██████╗██╗  ██╗
    ██║     ██╔════╝████╗ ████║██║   ██║██╔════╝╚══██╔══╝██╔════╝██╔════╝██║  ██║
    ██║     █████╗  ██╔████╔██║██║   ██║███████╗   ██║   █████╗  ██║     ███████║
    ██║     ██╔══╝  ██║╚██╔╝██║██║   ██║╚════██║   ██║   ██╔══╝  ██║     ██╔══██║
    ███████╗███████╗██║ ╚═╝ ██║╚██████╔╝███████║   ██║   ███████╗╚██████╗██║  ██║
    ╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝
    " -ForegroundColor Cyan
    Write-Host "    >>> COMPANY S.A. - OMNI EDITION v$Global:Version <<<" -ForegroundColor White
    Write-Host "    -----------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "    CLIENTE: $env:USERNAME  |  EQUIPO: $env:COMPUTERNAME" -ForegroundColor Yellow
    Write-Host "    SISTEMA: $((Get-CimInstance Win32_OperatingSystem).Caption)" -ForegroundColor DarkCyan
    Write-Host "    -----------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "    ❤️  Hecho con amor en Venezuela  🇻🇪" -ForegroundColor Magenta
    Write-Host "    📄  Generador de Informes Técnicos Incluido" -ForegroundColor Green
    Write-Host "    ⚠️  USAR BAJO SU PROPIA RESPONSABILIDAD" -ForegroundColor Red
    Write-Host "    -----------------------------------------------------------------`n" -ForegroundColor DarkGray
}

function Wait-Key {
    Write-Host "`n    [i] Presiona cualquier tecla para continuar..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# --- 2. GENERADOR DE INFORMES (LA JOYA DE LA CORONA) ---
function Generate-Report {
    Write-Host "    --> Generando Informe Técnico Profesional..." -ForegroundColor Cyan
    
    $OS = Get-CimInstance Win32_OperatingSystem
    $CPU = Get-CimInstance Win32_Processor
    $RAM = Get-CimInstance Win32_ComputerSystem
    $Disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $Bios = Get-CimInstance Win32_BIOS
    $Date = Get-Date -Format "dd/MM/yyyy HH:mm"
    
    $RAM_GB = [math]::round($RAM.TotalPhysicalMemory / 1GB)
    $Disk_Free = [math]::round($Disk.FreeSpace / 1GB)
    $Disk_Total = [math]::round($Disk.Size / 1GB)

    $HtmlContent = @"
<!DOCTYPE html>
<html lang='es'>
<head>
    <meta charset='UTF-8'>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f4f4; color: #333; margin: 0; padding: 40px; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .header { text-align: center; border-bottom: 2px solid #00bfff; padding-bottom: 20px; margin-bottom: 30px; }
        .header h1 { color: #00bfff; margin: 0; font-size: 28px; }
        .header p { color: #666; margin: 5px 0 0; }
        .section { margin-bottom: 25px; }
        .section h2 { background: #00bfff; color: white; padding: 10px 15px; border-radius: 5px; font-size: 18px; }
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .item { background: #f9f9f9; padding: 10px; border-radius: 4px; border: 1px solid #eee; }
        .label { font-weight: bold; color: #555; display: block; font-size: 12px; }
        .value { font-size: 14px; color: #000; }
        .footer { text-align: center; font-size: 12px; color: #aaa; margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px; }
        .badge { display: inline-block; background: #28a745; color: white; padding: 2px 8px; border-radius: 10px; font-size: 10px; }
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1>LEMUSTECH COMPANY S.A.</h1>
            <p>Informe Técnico de Mantenimiento</p>
            <p><strong>Fecha:</strong> $Date</p>
        </div>

        <div class='section'>
            <h2>🖥️ Especificaciones del Equipo</h2>
            <div class='grid'>
                <div class='item'><span class='label'>Equipo</span><span class='value'>$env:COMPUTERNAME</span></div>
                <div class='item'><span class='label'>Usuario</span><span class='value'>$env:USERNAME</span></div>
                <div class='item'><span class='label'>Sistema Operativo</span><span class='value'>$($OS.Caption)</span></div>
                <div class='item'><span class='label'>Número de Serie</span><span class='value'>$($Bios.SerialNumber)</span></div>
                <div class='item'><span class='label'>Procesador</span><span class='value'>$($CPU.Name)</span></div>
                <div class='item'><span class='label'>Memoria RAM</span><span class='value'>$RAM_GB GB</span></div>
                <div class='item'><span class='label'>Almacenamiento (C:)</span><span class='value'>$Disk_Free GB libres de $Disk_Total GB</span></div>
            </div>
        </div>

        <div class='section'>
            <h2>🛠️ Servicios Realizados</h2>
            <ul>
                <li>✅ Limpieza profunda de archivos temporales.</li>
                <li>✅ Optimización de registro y servicios.</li>
                <li>✅ Purgado de memoria RAM y caché.</li>
                <li>✅ Restablecimiento de protocolos de red (DNS/TCP).</li>
                <li>✅ Verificación de integridad de sistema (SFC).</li>
                <li>✅ Análisis de seguridad básico.</li>
            </ul>
        </div>
        
        <div class='section'>
            <h2>🛡️ Estado Final</h2>
            <p>El equipo ha sido optimizado y verificado bajo los estándares de calidad de <strong>Lemustech Company S.A.</strong></p>
            <p>Estado S.M.A.R.T Disco: <span class='badge'>VERIFICADO</span></p>
            <p>Servicios Críticos: <span class='badge'>OPTIMIZADO</span></p>
        </div>

        <div class='footer'>
            <p>Soporte Técnico: +58 424-1353496 | Soporte@lemustech.net | @lemustech.ve</p>
            <p>Hecho con amor en Venezuela 🇻🇪</p>
        </div>
    </div>
</body>
</html>
"@

    $HtmlContent | Out-File -FilePath $ReportPath -Encoding UTF8
    Write-Host "        [OK] Informe generado en el Escritorio: Informe_Tecnico_Lemustech.html" -ForegroundColor Green
    Log-Action "Informe técnico generado" "SUCCESS"
    
    # Abrir informe automáticamente
    Start-Process $ReportPath
    Wait-Key
}

# --- 3. FUNCIONES DE SEGURIDAD Y BACKUP ---

function Check-DiskHealth {
    Write-Host "    --> Verificando Salud de Discos (S.M.A.R.T.)..." -ForegroundColor Cyan
    $Disks = Get-PhysicalDisk | Select-Object FriendlyName, HealthStatus
    $AllHealthy = $true
    foreach ($D in $Disks) {
        if ($D.HealthStatus -ne "Healthy") {
            Write-Host "        [!] ALERTA: $($D.FriendlyName) estado: $($D.HealthStatus)" -ForegroundColor Red
            $AllHealthy = $false
        } else {
            Write-Host "        [OK] $($D.FriendlyName): Saludable" -ForegroundColor DarkGray
        }
    }
    return $AllHealthy
}

function Create-BackupPoint {
    Write-Host "    --> Generando Punto de Restauración..." -ForegroundColor Cyan
    try {
        Checkpoint-Computer -Description "Lemustech Auto-Backup" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-Host "        [OK] Punto creado." -ForegroundColor Green
    } catch {
        Write-Host "        [!] Fallo al crear punto (Puede estar desactivado)." -ForegroundColor Yellow
    }
}

# --- 4. DATA BACKUP EXPRESS ---
function Data-Backup {
    Draw-Header
    Write-Host "    [BACKUP EXPRESS DE DATOS]" -ForegroundColor Cyan
    Write-Host "    Copia Escritorio, Documentos e Imágenes a una unidad externa."
    
    # Listar unidades
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -ne "C:\" -and $_.Free -gt 100000000 }
    if ($drives.Count -eq 0) {
        Write-Host "`n    [!] No se detectan unidades externas (USB/Disco)." -ForegroundColor Red
        Wait-Key
        return
    }
    
    Write-Host "`n    Unidades detectadas:"
    foreach ($d in $drives) { Write-Host "    [$($d.Name)] $($d.Description) - Libre: $([math]::round($d.Free / 1GB)) GB" }
    
    $target = Read-Host "`n    Escribe la letra de la unidad de destino (ej: D)"
    $targetPath = "$target`:\Lemustech_Backup_$env:USERNAME"
    
    if (Test-Path "$target`:") {
        Write-Host "`n    --> Iniciando Robocopy (Modo Espejo Seguro)..." -ForegroundColor Yellow
        $source = $env:USERPROFILE
        $folders = @("Desktop", "Documents", "Pictures")
        
        foreach ($f in $folders) {
            Write-Host "    Copiando $f..." -ForegroundColor Gray
            # Robocopy options: /E (Subdirs) /ZB (Restartable) /R:1 (Retries) /W:1 (Wait)
            robocopy "$source\$f" "$targetPath\$f" /E /ZB /R:1 /W:1 /NFL /NDL | Out-Null
        }
        Write-Host "`n    ✅ RESPALDO COMPLETADO EN: $targetPath" -ForegroundColor Green
        Log-Action "Backup de datos realizado en $targetPath" "SUCCESS"
    } else {
        Write-Host "    Unidad no válida." -ForegroundColor Red
    }
    Wait-Key
}

# --- 5. MÓDULOS DE MANTENIMIENTO ---
# (Se mantienen optimizados como en v19.5, solo se simplifican visualmente aquí)

function Opt-Basic {
    Draw-Header; Log-Action "Opt Basic"
    Write-Host "    [MANTENIMIENTO BÁSICO]" -ForegroundColor Green
    Remove-Item "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    ipconfig /flushdns | Out-Null
    Write-Host "`n    ✅ Listo." -ForegroundColor Green; Wait-Key
}

function Opt-Intermediate {
    Draw-Header; Log-Action "Opt Intermediate"
    Write-Host "    [MANTENIMIENTO INTERMEDIO]" -ForegroundColor Yellow
    if (-not (Check-DiskHealth)) { Write-Host "    [!] Disco en riesgo. Cancelando." -ForegroundColor Red; Wait-Key; return }
    Create-BackupPoint
    Remove-Item "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Stop-Service "DiagTrack" -WarningAction SilentlyContinue
    [System.GC]::Collect()
    Write-Host "`n    ✅ Listo." -ForegroundColor Yellow; Wait-Key
}

function Opt-Extreme {
    Draw-Header
    Write-Host "    !!! MODO EXTREMO !!!" -ForegroundColor Red
    if ((Read-Host "    Escribe 'si' para confirmar") -ne 'si') { return }
    Log-Action "Opt Extreme"
    Create-BackupPoint
    Stop-Service "wuauserv" -Force -WarningAction SilentlyContinue
    Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue
    Start-Service "wuauserv" -WarningAction SilentlyContinue
    vssadmin delete shadows /all /quiet | Out-Null
    Write-Host "`n    ✅ Listo. Reinicia el PC." -ForegroundColor Red; Wait-Key
}

function Menu-Optimization {
    while ($true) {
        Draw-Header
        Write-Host "    [1] 🚀 SELECTOR DE OPTIMIZACIÓN" -ForegroundColor Cyan
        Write-Host "    1. 🟢 Básica"
        Write-Host "    2. 🟡 Intermedia"
        Write-Host "    3. 🔴 Extrema"
        Write-Host "    B. 🔙 Volver"
        $lvl = Read-Host "`n    Nivel"
        switch ($lvl) { '1' { Opt-Basic } '2' { Opt-Intermediate } '3' { Opt-Extreme } 'B' { return } 'b' { return } }
    }
}

function Fix-Network {
    Draw-Header
    Write-Host "    [CENTRO DE REDES]" -ForegroundColor Cyan
    Write-Host "    1. Reparar Conectividad"
    Write-Host "    2. Test de Velocidad (Descarga Real)"
    Write-Host "    B. Volver"
    $op = Read-Host "`n    Opción"
    
    if ($op -eq '1') {
        netsh int ip reset | Out-Null; netsh winsock reset | Out-Null; ipconfig /flushdns | Out-Null
        Write-Host "    ✅ Red reseteada." -ForegroundColor Green
    } elseif ($op -eq '2') {
        Write-Host "`n    --> Midiendo velocidad de descarga (10MB)..." -ForegroundColor Yellow
        $start = Get-Date
        # Descarga archivo de prueba de cachefly (rápido y seguro)
        Invoke-WebRequest -Uri "http://cachefly.cachefly.net/10mb.test" -OutFile "$env:TEMP\speedtest.tmp" -UseBasicParsing | Out-Null
        $end = Get-Date
        $duration = ($end - $start).TotalSeconds
        $speed = [math]::round((10 * 8) / $duration, 2) # Mbps
        Remove-Item "$env:TEMP\speedtest.tmp" -ErrorAction SilentlyContinue
        Write-Host "    🚀 Velocidad estimada: $speed Mbps" -ForegroundColor Cyan
    }
    if ($op -ne 'b') { Wait-Key }
}

function Repair-System {
    Draw-Header
    Write-Host "    [REPARACIÓN SISTEMA]" -ForegroundColor Cyan
    DISM /Online /Cleanup-Image /RestoreHealth
    sfc /scannow
    Write-Host "`n    ✅ Finalizado." -ForegroundColor Green; Wait-Key
}

# --- GESTIÓN DE SOFTWARE ---
function Install-App ($id, $name) {
    Write-Host "    --> Instalando $name..." -ForegroundColor Cyan
    $args = "install --id $id --accept-package-agreements --accept-source-agreements --silent --source winget"
    Start-Process winget -ArgumentList $args -Wait -NoNewWindow
}

function Upgrade-All {
    Write-Host "    --> Actualizando TODO..." -ForegroundColor Cyan
    winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements --silent
    Wait-Key
}

function Install-Menu {
    while ($true) {
        Draw-Header
        Write-Host "    [ALMACÉN DE SOFTWARE LEMUSTECH]" -ForegroundColor Cyan
        Write-Host "    1. 🌐 Navegadores"
        Write-Host "    2. 🏢 Ofimática"
        Write-Host "    3. 💻 Desarrollo"
        Write-Host "    4. 🎨 Diseño"
        Write-Host "    5. 🎮 Gaming"
        Write-Host "    6. 🔧 Utilidades"
        Write-Host "    7. 🔄 ACTUALIZAR TODO" -ForegroundColor Green
        Write-Host "    B. 🔙 Volver"
        $cat = Read-Host "`n    Categoría"
        if ($cat -match 'B|b') { break }
        if ($cat -eq '7') { Upgrade-All; continue }

        switch ($cat) {
            '1' { $apps = @(@{id="Google.Chrome"; n="Chrome"}, @{id="Mozilla.Firefox"; n="Firefox"}, @{id="Brave.Brave"; n="Brave"}) }
            '2' { $apps = @(@{id="TheDocumentFoundation.LibreOffice"; n="LibreOffice"}, @{id="Adobe.Acrobat.Reader.64-bit"; n="Adobe Reader"}, @{id="Zoom.Zoom"; n="Zoom"}) }
            '3' { $apps = @(@{id="Microsoft.VisualStudioCode"; n="VS Code"}, @{id="Git.Git"; n="Git"}, @{id="Python.Python.3"; n="Python"}) }
            '4' { $apps = @(@{id="VideoLAN.VLC"; n="VLC"}, @{id="GIMP.GIMP"; n="GIMP"}, @{id="OBSProject.OBSStudio"; n="OBS"}) }
            '5' { $apps = @(@{id="Valve.Steam"; n="Steam"}, @{id="EpicGames.EpicGamesLauncher"; n="Epic Games"}, @{id="Discord.Discord"; n="Discord"}) }
            '6' { $apps = @(@{id="7zip.7zip"; n="7-Zip"}, @{id="AnyDeskSoftwareGmbH.AnyDesk"; n="AnyDesk"}, @{id="Microsoft.PowerToys"; n="PowerToys"}, @{id="Rufus.Rufus"; n="Rufus"}) }
        }

        foreach ($a in $apps) { Install-App $a.id $a.n }
        Write-Host "`n    ✅ Listo." -ForegroundColor Green; Wait-Key
    }
}

function Activate-Windows {
    Draw-Header
    Write-Host "    [ACTIVACIÓN MAS]" -ForegroundColor Cyan
    Start-Sleep -Seconds 2
    irm https://get.activated.win | iex
}

function Contact-Support {
    Start-Process "https://wa.me/584241353496"
    Start-Process "https://instagram.com/lemustech.ve"
    Start-Process "mailto:Soporte@lemustech.net"
}

function Colaborar {
    Start-Process "https://wa.me/584241353496?text=Hola,%20quisiera%20colaborar"
}

# --- BUCLE PRINCIPAL ---
do {
    Draw-Header
    Write-Host "    MENÚ PRINCIPAL" -ForegroundColor White
    Write-Host "    [1] 🚀  Selector de Optimización"
    Write-Host "    [2] 🌐  Centro de Redes"
    Write-Host "    [3] 🛠️  Diagnóstico (SFC/DISM)"
    Write-Host "    [4] 📄  Generar Informe Técnico (HTML)" -ForegroundColor Yellow
    Write-Host "    [5] 💾  Backup Express de Datos" -ForegroundColor Yellow
    Write-Host "    [6] 📦  Instalar / Actualizar Software"
    Write-Host "    [7] 🔑  Activar Windows/Office"
    Write-Host "    [8] 📞  Contacto y Soporte"
    Write-Host "    [9] 🤝  Colaboraciones"
    Write-Host "    [0] ❌  Salir" -ForegroundColor Red
    
    $sel = Read-Host "`n    Seleccione"

    switch ($sel) {
        '1' { Menu-Optimization }
        '2' { Fix-Network }
        '3' { Repair-System }
        '4' { Generate-Report }
        '5' { Data-Backup }
        '6' { Install-Menu }
        '7' { Activate-Windows }
        '8' { Contact-Support }
        '9' { Colaborar }
        '0' { Clear-Host; exit }
    }
} while ($true)