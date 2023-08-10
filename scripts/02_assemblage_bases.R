##%######################################################%##
#                                                          #
####   Assembler les fichiers des 6 bases de données    ####
#                                                          #
##%######################################################%##

# Toutes espèces -----------------------------
## Chargement des fichiers ####
load(file = "output/output_rdata/sinp.RData")
load(file = "output/output_rdata/aspe.RData")
load(file = "output/output_rdata/gon.RData")
load(file = "output/output_rdata/oison.RData")
load(file = "output/output_rdata/clicnat.RData")
load(file = "output/output_rdata/pmcc.RData")

## Rassembler les fichiers ####
aspe <- as.data.frame(aspe)
clicnat <- as.data.frame(clicnat)
oison <- as.data.frame(oison)
gon <- as.data.frame(gon)
pmcc <- as.data.frame(pmcc)
sinp <- as.data.frame(sinp)

data_tout_esp <- rbind.data.frame(aspe, clicnat)
data_tout_esp <- rbind.data.frame(data_tout_esp, gon)
data_tout_esp <- rbind.data.frame(data_tout_esp, pmcc)
data_tout_esp <- rbind.data.frame(data_tout_esp, sinp)
data_tout_esp <- rbind.data.frame(data_tout_esp, oison)

save(data_tout_esp, file = "output/output_rdata/data_tout_esp.RData")

st_write(data_tout_esp,
         "output/output_qgis/data_tout_esp_spat.gpkg")


# Espèces protégées -----------------------------
## Chargement des fichiers ####
load(file = "output/output_rdata/sinp_esp_pro.RData")
load(file = "output/output_rdata/aspe_esp_pro.RData")
load(file = "output/output_rdata/gon_esp_pro.RData")
load(file = "output/output_rdata/pmcc_esp_pro.RData")
load(file = "output/output_rdata/clicnat_esp_pro.RData")
load(file = "output/output_rdata/oison_esp_pro.RData")

## Rassembler les fichiers ####
sinp_esp_pro <- as.data.frame(sinp_esp_pro)
gon_esp_pro <- as.data.frame(gon_esp_pro)
clicnat_esp_pro <- as.data.frame(clicnat_esp_pro)
oison_esp_pro <- as.data.frame(oison_esp_pro)
aspe_esp_pro <- as.data.frame(aspe_esp_pro)
pmcc_esp_pro <- as.data.frame(pmcc_esp_pro)

data_pro <- rbind.data.frame(aspe_esp_pro, clicnat_esp_pro)
data_pro <- rbind.data.frame(data_pro, gon_esp_pro)
data_pro <- rbind.data.frame(data_pro, pmcc_esp_pro)
data_pro <- rbind.data.frame(data_pro, sinp_esp_pro)
data_pro <- rbind.data.frame(data_pro, oison_esp_pro)

save(data_pro, file = "output/output_rdata/data_pro.RData")

st_write(data_pro,
         "output/output_qgis/data_pro_spat.gpkg")


