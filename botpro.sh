#!/bin/bash
clear
#----☢️-☠️-✌️--@SIDOKA_SSH-✌️--☠️-☢️-------#
source ShellBot2.sh
ShellBot.init --token "5174120928:AAEZvKXBy8iHqU9i6y47l11sRhV1EFTU5cU" --monitor --flush
ShellBot.username

# - Funcao menu
menu() {
    local msg
        msg="=×=×=×=×=×=×=×=×=×=×=×=×=×=×=×=×=\n"
        msg+="<b>--♾️☁️-SEJAM BEM VINDOS--@SIDOKASSH_VENDAS_BOT-♾️-</b>\n"
        msg+="=×=×=×=×=×=×=×=×=×=×=×=×=×=×=×=×=\n\n"
        msg+="<b>VENDEDOR OFICIAL DO SIDOKA SSH</b>\n"
 msg+="<b>VALOR:</b> 15 MENSAL\n"
 msg+="<b>PIX ALEATÓRIA: </b>c59ad9b6-66ad-4fcf-9599-3d6a1d8f9dc5\n"
 msg+="<b>APERTE EM ✘“COMPRAR ACESSO”✘ E ENVIE SEU COMPROVANTE @SIDOKA_SSH</b>\n\n"
        msg+="⚠️<b>APENAS CHAME SE REALMENTE FOR COMPRAR @SIDOKA_SSH </b>🚀\n"
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
        --text "$(echo -e $msg)" \
        --reply_markup "$keyboard1" \
        --parse_mode html
        return 0
}

# - funcao criar ssh
criarteste() {
    [[ $(grep -wc ${callback_query_from_id} lista) != '0' ]] && {
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id} \
        --text "VC JA CRIOU @SIDOKASSH_VENDAS_BOT SSH HOJE !"
      return 0
    }
    usuario=$(echo lite$(( RANDOM% + 99999 )))
    senha=$((RANDOM% + 99999))
    limite='1'
    tempo='1'
    tuserdate=$(date '+%C%y/%m/%d' -d " +1 days")
    useradd -M -N -s /bin/false $usuario -e $tuserdate > /dev/null 2>&1
    (echo "$senha";echo "$senha") | passwd $usuario > /dev/null 2>&1
    echo "$senha" > /etc/SSHPlus/senha/$usuario
    echo "$usuario $limite" >> /root/usuarios.db
    echo "#!/bin/bash
pkill -f "$usuario"
userdel --force $usuario
grep -v ^$usuario[[:space:]] /root/usuarios.db > /tmp/ph ; cat /tmp/ph > /root/usuarios.db
rm /etc/SSHPlus/senha/$usuario > /dev/null 2>&1
rm -rf /etc/SSHPlus/userteste/$usuario.sh" > /etc/SSHPlus/userteste/$usuario.sh
    chmod +x /etc/SSHPlus/userteste/$usuario.sh
    at -f /etc/SSHPlus/userteste/$usuario.sh now + $tempo hour > /dev/null 2>&1
    echo ${callback_query_from_id} >> lista
    # - ENVIA O SSH
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id} \
    --text "$(echo -e "✅ ✘<b>Criado com sucesso</b>✘ ✅\n\nIP: $(cat /etc/IP)\nUSUARIO: <code>$usuario</code>\nSENHA: <code>$senha</code>\n\n⏳ Expira em: $tempo Hora")" \
    --parse_mode html
    return 0
}



#enviar app
enviarapp() {
    ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
        --text "♻️✉️ ENVIANDO APLICATIVO, AGUARDE.✘⚡️.."
    ShellBot.sendDocument --chat_id ${callback_query_message_chat_id} \
        --document "@/root/base.apk" \
    return 0
}

#informacoes usuario
infouser () {
 ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
 --text "$(echo -e "Nome:  ${message_from_first_name[$(ShellBot.ListUpdates)]}\nUser: @${message_from_username[$(ShellBot.ListUpdates)]:-null}")\nID: ${message_from_id[$(ShellBot.ListUpdates)]} " \
 --parse_mode html
 return 0
}

unset botao1
botao1=''
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text '♻️⌛️GERA TESTE @miuisshplusbr⌛️♻️' --callback_data 'gerarssh'
ShellBot.InlineKeyboardButton --button 'botao1' --line 2 --text '🔰BAIXAR APLICATIVO⚡️https://t.me/apksidokassh/2🔰' --callback_data 'appenviar'
ShellBot.InlineKeyboardButton --button 'botao1' --line 3 --text '💲✉️💲COMPRAR ACESSO💲✉️ @SIDOKA_SSH💲' --callback_data '3' --url 'https://t.me/SIDOKA_SSH'
ShellBot.regHandleFunction --function criarteste --callback_data gerarssh
ShellBot.regHandleFunction --function enviarapp --callback_data appenviar

unset keyboard1
keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao1')"
while :; do
   [[ "$(date +%d)" != "$(cat RESET)" ]] && {
    echo $(date +%d) > RESET
    echo ' ' > lista
   }
  ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
  for id in $(ShellBot.ListUpdates); do
    (
      ShellBot.watchHandle --callback_data ${callback_query_data[$id]}
      comando=(${message_text[$id]})
      [[ "${comando[0]}" = "/menu"  || "${comando[0]}" = "/start" ]] && menu
      [[ "${comando[0]}" = "/id"  ]] && infouser
    ) &
  done
done