#!/bin/bash

function notificar_usuario {
	#Tocar som de notificação:
	aplay /usr/share/sounds/sound-icons/xylofon.wav

	#modifica o brilho da tela:
	echo 937 > /sys/class/backlight/intel_backlight/brightness
        sleep 2
        echo 237 > /sys/class/backlight/intel_backlight/brightness
        sleep 2
        echo 937 > /sys/class/backlight/intel_backlight/brightness
}

function status {
	#verifica o status da bateria (carregando ou descarregando)
	status=`cat /sys/class/power_supply/BAT0/status`
}

function nivel_atual {
	#verifica o nível atual da bateria
	nivel_atual=`cat /sys/class/power_supply/BAT0/charge_now`
}

#constantes:
declare -r carga_total=`cat /sys/class/power_supply/BAT0/charge_full`
declare -r nivel_minimo=160000 #em torno de 24%
declare -r vetor=(/bateria/bateria_completa.sh /bateria/sleep_valor.sh)

echo -e "\n"

while true
do
	nivel_atual
	status


	if [ $status = "Discharging" ]
	then
		if [ $(($nivel_atual - $nivel_minimo)) -le 0 ]
		then
			notificar_usuario
			sleep 21
			status
			if [ $status = "Discharging" ]
			then
				notificar_usuario
				sleep 120
			fi
		else
			echo "-------------------------------------"
			echo "Estado atual: Descarregando"
			echo "Hora atual: `date +%T`"
			echo "Próxima verificação em $[3 * ($nivel_atual - $nivel_minimo) / 1000]s"
			echo -e "-------------------------------------\n"
			
			sleep $[3 * ($nivel_atual - $nivel_minimo) / 1000]
		fi
	else
		echo "-------------------------------------"
		echo "Estado atual: Carregando"
		echo "Hora atual: `date +%T`"
		echo "Próxima verificação em $[6 * ($carga_total - $nivel_atual) / 1000]s"
		echo -e "-------------------------------------\n"
		
		valor=$[6 * ($carga_total - $nivel_atual) / 1000]
		indice=$((1 && $valor))
		
		echo "$valor" > /bateria/valor
		
		#Se $valor for igual a zero, então executa o bash script: "/bateria/bateria_completa.sh". Caso contrário, executa "/bateria/sleep_valor.sh"
		"${vetor[$indice]}"
	fi
	#break
done
