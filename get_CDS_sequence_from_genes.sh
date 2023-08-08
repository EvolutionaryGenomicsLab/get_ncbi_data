#!/bin/bash

FILE_GENES="$1"
FILE_SPECIES="$2"

while read -r gene; do
    while read -r species; do
        echo "Buscando ${gene} para ${species}..."
        esearch -db gene -query "${gene} [GENE]  AND ${species} [ORGN]" < /dev/null |
        efetch -format docsum |
        #xtract -pattern GenomicInfoType -element ChrAccVer ChrStart ChrStop |
	xtract -pattern LocationHistType -element ChrAccVer ChrStart ChrStop |
        xargs -n 3 sh -c 'efetch -db nuccore -format fasta_cds_na -id "${0}" -chr_start "${1}" -chr_stop "${2}"' > ${gene}_${species// /_}.fasta
        echo "Resultado da requisicao salvo em: ${gene}_${species// /_}.fasta"
        echo ""
        sleep 1
    done < ${FILE_SPECIES}
done < ${FILE_GENES}

