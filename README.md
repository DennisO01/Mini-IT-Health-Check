# Mini-IT Health Check

## 1. Syfte

Syftet med projektet är att automatisera skapandet och kontrollen av en enkel, simulerad miljö.

I stället för att manuellt skapa och kontrollera konfigurationsfiler används Terraform för att skapa filerna och PowerShell för att kontrollera att de finns och innehåller rätt information.

Python används för att starta PowerShell-skriptet och kontrollera om hälsokontrollen lyckades.

## 2. Tekniker

Projektet använder tre tekniker:

- **Terraform:** Skapar konfigurationsfiler med Infrastructure as Code IaC.
- **PowerShell:** Kontrollerar filernas existens och att servernamnet stämmer.
- **Python:** Startar PowerShell och kontrollerar resultatet med hjälp av en exitkod.

Projektet är utvecklat och testat med Ubuntu via WSL2, Terraform, PowerShell 7 och Python 3.

## 3. Projektstruktur

- `main.tf` – Terraform konfiguration med två resurser, variabler och outputs.
- `verify.ps1` – PowerShell skript som utför hälsokontrollen.
- `orchestrate.py` – Python skript som startar PowerShell och läser resultatet.
- `.gitignore` – Anger vilka tillfälliga och genererade filer Git ska ignorera.
- `README.md` – Dokumentation av projektet.

Terraform skapar även `config.json` och `server.txt` vid körning.

## 4. Hur projektet fungerar

1. Terraform läser konfigurationen i `main.tf`.
2. Terraform skapar `config.json` och `server.txt`.
3. PowerShell kontrollerar att filerna finns.
4. PowerShell läser JSON-filen och jämför servernamnet med textfilen.
5. Python startar PowerShell och kontrollerar dess exitkod.
6. Resultatet visas som OK eller FEL.

Terraform och Python körs som separata steg. Python startar PowerShell-kontrollen, inte Terraform.

## 5. Installation och körning

Förutsättningar:

- Ubuntu/WSL2 eller annan kompatibel miljö
- Terraform
- PowerShell 7 (`pwsh`)
- Python 3
- Git

Öppna terminalen i projektmappen.

Initiera Terraform:

```bash
terraform init
```

Kontrollera konfigurationen:

```bash
terraform validate
terraform plan
```

Skapa filerna:

```bash
terraform apply
```

Bekräfta med `yes` efter att planen granskats.

Starta därefter hälsokontrollen:

```bash
python3 orchestrate.py
```

Python kör PowerShell och visar om kontrollerna lyckades.

## 6. Testning och resultat

Projektet testas genom att kontrollera att Terraform skapar båda filerna och att PowerShell kan läsa deras innehåll.

Ett fel kan simuleras genom att tillfälligt byta namn på `server.txt`.

PowerShell ska då visa att filen saknas och returnera exitkod 1. Python visar därefter att hälsokontrollen misslyckades.

Genom att köra `terraform apply` igen kan den saknade resursen återskapas. Därefter kan kontrollen köras på nytt.

## 7. Begränsningar

Projektet använder en simulerad serverkonfiguration. Det installerar eller övervakar inte en riktig server.

Kontrollerna är begränsade till projektets filer och servernamn. Lösningen är avsedd att demonstrera grundläggande automatisering, verifiering och felhantering.

## 8. Reflektion

Projektet visar hur olika automatiseringsverktyg kan samarbeta utan att man behöver bygga en stor miljö.

Jag har fått en bättre förståelse för skillnaden mellan att skapa en konfiguration och att verifiera att den fungerar.

En viktig del har varit att använda funktioner, variabler och felhantering för att göra koden mer strukturerad.

Projektet skulle senare kunna utvecklas med fler kontroller, exempelvis diskutrymme eller tjänstestatus.

## 9. AI och externa hjälpmedel

Jag har använt ChatGPT som stöd för att planera projektet, ta fram kodexempel, och felsöka.

Jag har även använt kursmaterialet från Nackademin som grund för de tekniska lösningarna.

Koden har körts och kontrollerats i min egen utvecklingsmiljö. Jag ansvarar själv för projektet och för att kunna förklara hur det fungerar.

## 10. GitHub

Projektets GitHub-repository:

https://github.com/DennisO01/Mini-IT-Health-Check

## 11. Sluttest

Följande tester har genomförts:

Normal körning: Terraform visade att inga ändringar behövdes och Python rapporterade att alla kontroller lyckades.

Feltest: Jag bytte tillfälligt namn på server.txt. PowerShell upptäckte att filen saknades och Python returnerade exitkod 1.

Återställning: Terraform återskapade den saknade filen. Efteråt fungerade hälsokontrollen igen med exitkod 0.

Testerna visar att projektet både kan upptäcka ett fel i testmiljön och verifiera att felet har åtgärdats.