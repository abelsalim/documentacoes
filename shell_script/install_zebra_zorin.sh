#!/usr/bin/env bash


function install_impressora() {
    verde='\033[1;32m'
    azul_ciano='\033[1;36m'
    reset='\033[0m'

    # Nome da impressora
    impressora=$1

    echo -e "${azul_ciano}Instalando impressora '${impressora}'...${reset}"

    # Se é instalação usb
    if [ $instalacao_usb = 's' ]; then
        usb=$(lpinfo -v|grep Zebra|awk '{print $2}')

        # Instalação da impressora usb
        lpadmin -p $impressora -E -v $usb -m drv:///sample.drv/zebra.ppd \
        -u allow:all -o printer-is-shared=true > /dev/null 2>&1
    # Se é instalação de rede
    else
        # Instalação da impressora de rede
        lpadmin -p $impressora -E -v socket://$ip:9100 -m \
        drv:///sample.drv/zebra.ppd -u allow:all -o printer-is-shared=true \
        > /dev/null 2>&1
    fi

    echo -e "${verde}Impressora '${impressora}' instalada!${reset}"

    # Importar configurações
    echo -e "${azul_ciano}importanto arquivo de configuração...${reset}"
    cat /usr/local/bin/arquivo_ppd/$impressora.ppd > \
    /etc/cups/ppd/$impressora.ppd
    echo -e "${verde}Arquivo importado!${reset}"

}


function main () {

    verde='\033[1;32m'
    vermelho='\033[1;31m'
    azul_ciano='\033[1;36m'
    reset='\033[0m'

    linha="----------------------------------------------------------------"

    # nomenclatura padrão das impressoras
    impressoras_zebra=('zebra_cameba' 'zebra_cameba_promocao')

    for impressora in "${impressoras_zebra[@]}"
    do
        # retorna nome da impressora se já estiver instalada
        zebra_instalada=$(lpstat -p | awk '{print $2}'| grep -w $impressora)

        echo $linha

        # Se não existe impressora instala
        if [ -z $zebra_instalada ]; then
            install_impressora $impressora

        else
            # Se impressora está instalada, apaga a mesma e reinstala
            if [ $impressora = $zebra_instalada ]; then
                # Remove impressora
                echo -e "${azul_ciano}Removendo a impressora'${impressora}'...\
                ${reset}"
                lpadmin -x $impressora
                echo -e "${vermelho}Impressora'${impressora}' removida!\
                ${reset}"

                # Instala impressora
                install_impressora $impressora
            fi
        fi
    done

    echo $linha

    # restart no cups
    echo -e "${azul_ciano}Reiniciando CUPS...${reset}"
    systemctl restart cups
    echo -e "${verde}CUPS reiniciado!${reset}"

}


read -p "Instalação UBS? (s/N) " instalacao_usb

if [ $instalacao_usb != 's' ]; then
    read -p "Informe o ip da impressora: " ip
fi

main

echo $linha

exit 0