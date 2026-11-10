
# =====================================================
# MINI-IT HEALTH CHECK
# Terraform - Skapar min enkla testmiljö
# =====================================================

# SYFTE:
# Terraform skapar två filer som representerar en
# enkel serverkonfiguration.
#
# PowerShell ska senare läsa och kontrollera filerna.
# Python ska hjälpa till att automatisera körningen.


# -----------------------------------------------------
# 1. TERRAFORM OCH PROVIDER
# -----------------------------------------------------

# Här anger jag vilken provider Terraform behöver.
# Providern "local" gör att jag kan skapa filer
# direkt på datorn utan någon molntjänst.

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.6"
    }
  }
}


# -----------------------------------------------------
# 2. VARIABLER
# -----------------------------------------------------

# Variabler används för att enkelt kunna ändra
# inställningar utan att skriva om resurskoden.

# Namnet på min fiktiva testserver.
# "default" används om jag inte anger något annat.

variable "server_name" {
  description = "Namn på testservern"
  type        = string
  default     = "LAB-SRV01"
}

# Portnumret som sparas i konfigurationen.
# Jag startar ingen riktig server på denna port.
# Porten är endast ett exempel på en inställning.

variable "port" {
  description = "Testserverns portnummer"
  type        = number
  default     = 8080
}


# -----------------------------------------------------
# 3. RESOURCE 1 - KONFIGURATIONSFIL
# -----------------------------------------------------

# En resource beskriver något Terraform ska hantera.
#
# local_file skapar en fil på min dator.
# "config" är resursens interna namn i Terraform.

resource "local_file" "config" {

  # path.module pekar på mappen där main.tf ligger.
  # Det gör att jag slipper skriva en fast sökväg.
  filename = "${path.module}/config.json"

  # jsonencode omvandlar mina värden till JSON.
  # PowerShell kan senare läsa denna konfiguration.
  content = jsonencode({
    server_name = var.server_name
    port        = var.port
    environment = "test"
  })
}


# -----------------------------------------------------
# 4. RESOURCE 2 - SERVERINFORMATION
# -----------------------------------------------------

# Jag skapar även en vanlig textfil.
# Den ska användas av PowerShell för att kontrollera
# att rätt servernamn finns i filen.

resource "local_file" "server" {

  # Filen skapas i samma mapp som main.tf.
  filename = "${path.module}/server.txt"

  # ${var.server_name} hämtar värdet från variabeln.
  # Om jag ändrar server_name ändras även filens text.
  content = "Server: ${var.server_name}"
}


# -----------------------------------------------------
# 5. OUTPUTS
# -----------------------------------------------------

# Outputs visar information efter terraform apply.
#
# Här visar jag sökvägarna till filerna Terraform
# har skapat, så att jag enkelt kan hitta dem.

output "config_path" {
  value = local_file.config.filename
}

output "server_path" {
  value = local_file.server.filename
}
