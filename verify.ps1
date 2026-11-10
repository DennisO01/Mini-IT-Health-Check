# =====================================================
# MINI-IT HEALTH CHECK
# PowerShell - Kontrollerar vår testmiljö
# =====================================================

# SYFTE:
# Terraform har skapat config.json och server.txt.
# Detta skript kontrollerar att filerna finns och
# att serverinformationen är korrekt.


# -----------------------------------------------------
# 1. FILSÖKVÄGAR
# -----------------------------------------------------

# $PSScriptRoot pekar på mappen där skriptet ligger.
# Därför fungerar skriptet även om jag startar det
# från en annan katalog.

$configFil = Join-Path $PSScriptRoot "config.json"
$serverFil = Join-Path $PSScriptRoot "server.txt"


# -----------------------------------------------------
# 2. FUNKTION FÖR ATT KONTROLLERA FILER
# -----------------------------------------------------

# Funktionen tar emot en filsökväg som parameter.
# Den returnerar True om filen finns, annars False.

function Testa-Fil {
    param(
        [string]$Sokvag
    )

    if (Test-Path -LiteralPath $Sokvag -PathType Leaf) {
        Write-Host "[OK] Filen finns: $Sokvag" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "[FEL] Filen saknas: $Sokvag" -ForegroundColor Red
        return $false
    }
}


# -----------------------------------------------------
# 3. HUVUDPROGRAM
# -----------------------------------------------------

Write-Host ""
Write-Host "===== MINI-IT HEALTH CHECK ====="
Write-Host ""

# Jag använder en array för att samla filerna.
$filer = @($configFil, $serverFil)

# Loopen går igenom filerna en i taget.
$allaFilerFinns = $true

foreach ($fil in $filer) {
    if (-not (Testa-Fil -Sokvag $fil)) {
        $allaFilerFinns = $false
    }
}


# -----------------------------------------------------
# 4. KONTROLLERA SERVERINFORMATION
# -----------------------------------------------------

# try/catch fångar fel när vi läser filerna.
# Jag försöker bara läsa innehållet om båda finns.

if ($allaFilerFinns) {
    try {
        # Läs JSON och omvandla till ett PowerShell-objekt.
        $config = Get-Content -LiteralPath $configFil -Raw -ErrorAction Stop |
            ConvertFrom-Json -ErrorAction Stop

        # Läs textfilens innehåll.
        $serverText = Get-Content -LiteralPath $serverFil -Raw -ErrorAction Stop

        # Bygg det förväntade innehållet utifrån JSON.
        $forvantadText = "Server: $($config.server_name)"

        # Trim tar bort extra radbrytningar i slutet.
        if ($serverText.Trim() -eq $forvantadText) {
            Write-Host "[OK] Servernamnet stämmer!" -ForegroundColor Green
        }
        else {
            Write-Host "[FEL] Servernamnet stämmer inte!" -ForegroundColor Red
            $allaFilerFinns = $false
        }
    }
    catch {
        Write-Host "[FEL] Kunde inte läsa konfigurationen: $($_.Exception.Message)" -ForegroundColor Red
        $allaFilerFinns = $false
    }
}


# -----------------------------------------------------
# 5. VISA SLUTRESULTAT
# -----------------------------------------------------

Write-Host ""

if ($allaFilerFinns) {
    Write-Host "RESULTAT: Alla kontroller godkända!" -ForegroundColor Green
}
else {
    Write-Host "RESULTAT: En eller flera kontroller misslyckades." -ForegroundColor Red
}

Write-Host "================================"

# -----------------------------------------------------
# 6. RETURKOD TILL PYTHON
# -----------------------------------------------------

# Python använder exitkoden för att avgöra
# om hälsokontrollen lyckades eller misslyckades.

if ($allaFilerFinns) {
    exit 0
}
else {
    exit 1
}