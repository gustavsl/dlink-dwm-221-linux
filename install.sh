#!/bin/sh
echo "** Instalando configuração para D-Link DWM-221 da Claro **"

echo "Copiando options para /etc/ppp/"
cp options /etc/ppp/
echo "Copiando pap-secrets para /etc/ppp/"
cp pap-secrets /etc/ppp/
if [ -d "/etc/ppp/peers" ]; then
  echo "Copiando claro-provider.3g para /etc/ppp/peers/"
  cp claro-provider.3g /etc/ppp/peers/
else
  echo "Criando pasta /etc/ppp/peers/"
  mkdir /etc/ppp/peers
  echo "Copiando claro-provider.3g para /etc/ppp/peers/"
  cp claro-provider.3g /etc/ppp/peers/
fi
if [ -d "/etc/ppp/chat" ]; then
  echo "Copiando claro-3g.chat para /etc/ppp/chat/"
  cp claro-3g.chat /etc/ppp/chat/
else
  echo "Criando pasta /etc/ppp/chat/"
  mkdir /etc/ppp/chat
  echo "Copiando claro-3g.chat para /etc/ppp/chat/"
  cp claro-3g.chat /etc/ppp/chat/
fi
