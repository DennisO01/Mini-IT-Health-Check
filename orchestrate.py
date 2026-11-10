# =====================================================
# MINI-IT HEALTH CHECK
# Python - Startar och kontrollerar PowerShell
# =====================================================

# SYFTE:
# Python ska automatiskt starta mitt PowerShell skript.
# Efter körningen kontrollerar vi om skriptet lyckades.
#
# Detta kallas orkestrering eftersom Python styr
# ett annat program.


# -----------------------------------------------------
# 1. IMPORTERA MODULER
# -----------------------------------------------------

# subprocess används för att starta andra program.
import subprocess

# Path används för att hantera filsökvägar.
from pathlib import Path


# -----------------------------------------------------
# 2. HITTA POWERSHELL-SKRIPTET
# -----------------------------------------------------

# __file__ är sökvägen till detta Python-skript.
# parent är mappen där skriptet ligger.
projektmapp = Path(__file__).resolve().parent

# PowerShell-skriptet ligger i samma projektmapp.
powershell_fil = projektmapp / "verify.ps1"


# -----------------------------------------------------
# 3. STARTA HÄLSOKONTROLLEN
# -----------------------------------------------------

def kor_halsokontroll():
    """
    Startar PowerShell och kontrollerar resultatet.
    """

    print("===== PYTHON ORCHESTRATOR =====")
    print("Startar PowerShell Health Check...\n")

    try:
        # subprocess.run startar PowerShell 7.
        # capture_output fångar resultatet från PowerShell.
        # text=True gör att jag får vanlig text.
        # timeout förhindrar att programmet väntar för länge.
        resultat = subprocess.run(
            ["pwsh", "-NoProfile", "-File", str(powershell_fil)],
            capture_output=True,
            text=True,
            timeout=30
        )

        # Visa meddelandena från PowerShell.
        print(resultat.stdout)

        # Om PowerShell skrev ett felmeddelande
        # visar jag även det.
        if resultat.stderr:
            print("Felmeddelande:")
            print(resultat.stderr)

        # Returkod 0 betyder att kontrollen lyckades.
        if resultat.returncode == 0:
            print("[OK] Python: Hälsokontrollen lyckades!")
            return True
        else:
            print("[FEL] Python: Hälsokontrollen misslyckades!")
            return False

    # Hanterar om PowerShell inte finns.
    except FileNotFoundError:
        print("[FEL] PowerShell 7 kunde inte hittas.")
        return False

    # Hanterar om kontrollen tar för lång tid.
    except subprocess.TimeoutExpired:
        print("[FEL] Hälsokontrollen tog för lång tid.")
        return False


# -----------------------------------------------------
# 4. HUVUDPROGRAM
# -----------------------------------------------------

# Den här delen körs när jag startar Python-filen.
# Funktionen kan även importeras utan att starta
# hälsokontrollen automatiskt.

if __name__ == "__main__":
    lyckades = kor_halsokontroll()

    # Skicka ett tydligt resultat till terminalen.
    if lyckades:
        raise SystemExit(0)
    else:
        raise SystemExit(1)