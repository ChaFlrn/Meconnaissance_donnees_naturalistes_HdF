##%######################################################%##
#                                                          #
####   Assembler les fichiers des 6 bases de données    ####
#                    Juillet 2023                          #
##%######################################################%##

# Toutes espèces ---------------------------------------------------------------
cli::cli_h2("Toutes espèces")

## Chargement des fichiers ####
base::load(file = "output/output_rdata/sinp.RData")
base::load(file = "output/output_rdata/aspe.RData")
base::load(file = "output/output_rdata/gon.RData")
base::load(file = "output/output_rdata/oison.RData")
base::load(file = "output/output_rdata/clicnat.RData")
base::load(file = "output/output_rdata/pmcc.RData")

## Rassembler les fichiers ####
str(clicnat)
str(aspe)
str(gon)
str(pmcc)
str(oison)
str(sinp)

data_tout_esp <- bind_rows(aspe,
                           clicnat,
                           gon,
                           pmcc,
                           oison,
                           sinp)

save(data_tout_esp, file = "output/output_rdata/data_tout_esp.RData")


# Espèces protégées ------------------------------------------------------------
cli::cli_h2("Espèces protégées")

## Chargement des fichiers ####
base::load(file = "output/output_rdata/sinp_esp_pro.RData")
base::load(file = "output/output_rdata/aspe_esp_pro.RData")
base::load(file = "output/output_rdata/gon_esp_pro.RData")
base::load(file = "output/output_rdata/pmcc_esp_pro.RData")
base::load(file = "output/output_rdata/clicnat_esp_pro.RData")
base::load(file = "output/output_rdata/oison_esp_pro.RData")

## Rassembler les fichiers ####
str(clicnat_esp_pro)
str(aspe_esp_pro)
str(gon_esp_pro)
str(pmcc_esp_pro)
str(oison_esp_pro)
str(sinp_esp_pro)

data_esp_pro <- bind_rows(
  aspe_esp_pro,
  clicnat_esp_pro,
  gon_esp_pro,
  pmcc_esp_pro,
  sinp_esp_pro,
  oison_esp_pro
)

save(data_esp_pro, file = "output/output_rdata/data_esp_pro.RData")

