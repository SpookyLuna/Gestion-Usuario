#!/bin/bash

#Menu de opciones con Zenity

#Bucle de selección
while true ; do

menu=$(zenity --list \
        --title="Menú de gestión de usuario" \
        --column="Selecciona una opción" \
            "Alta de usuario" \
            "Baja de usuario"  \
            "Bloquear usuario" \
            "Desbloquear usuario" \
            "Modificar contraseña de usuario" \
            ) ||exit

#Opciones
if [[ "$menu" == "Alta de usuario" ]] ; then
    usuario=$( zenity --entry \
            --title="Alta de usuario" \
            --text="Introduce el nombre del nuevo usuario:")
    contrasena=$(zenity --title="Contraseña de administrador" --password) 
     echo $contrasena | sudo -S adduser $usuario && zenity --info --title="Alta de usuario" --text="Se ha creado el usuario con éxito" || zenity --error --title="Alta de usuario" --text="Ha habido un error"
fi

if [[ "$menu" == "Baja de usuario" ]] ; then
    usuario=$(getent passwd {1000..1500} | cut -d: -f1 | grep -v $(whoami) | zenity --list \
            --title="Baja de usuario" \
            --column="Lista de usuarios" 2>&1) #Elimina el warning de GLIB pasando el input por stdout
    contrasena=$(zenity --title="Contraseña de administrador" --password)             
     echo $contrasena | sudo -S deluser $usuario && zenity --info --title="Baja de usuario" --text="Se ha eliminado el usuario con éxito" || zenity --error --title="Baja de usuario" --text="Ha habido un error"
fi

if [[ "$menu" == "Bloqueo de usuario" ]] ; then
    usuario=$(getent passwd {1000..1500} | cut -d: -f1 | grep -v $(whoami) | zenity --list \
            --title="Bloqueo de usuario" \
            --column="Lista de usuarios" 2>&1)
    contrasena=$(zenity --title="Contraseña de administrador" --password)             
     echo $contrasena | sudo -S passwd -l $usuario && zenity --info --title="Bloqueo de usuario" --text="Se ha bloqueado el usuario con éxito" || zenity --error --title="Bloqueo de usuario" --text="Ha habido un error"
fi

if [[ "$menu" == "Desbloqueo de usuario" ]] ; then
    usuario=$(getent passwd {1000..1500} | cut -d: -f1 | grep -v $(whoami) | zenity --list \
            --title="Desbloqueo de usuario" \
            --column="Lista de usuarios" 2>&1)
    contrasena=$(zenity --title="Contraseña de administrador" --password) 
    echo $contrasena | sudo -S passwd -l $usuario && zenity --info --title="Desbloqueo de usuario" --text="Se ha desbloqueo el usuario con éxito" || zenity --error --title="Desbloqueo de usuario" --text="Ha habido un error"
fi

if [[ "$menu" == "Modificar contraseña de usuario" ]] ; then
    usuario=$(getent passwd {1000..1500} | cut -d: -f1 | grep -v $(whoami) | zenity --list \
            --title="Cambio de contraseña de usuario" \
            --column="Lista de usuarios" 2>&1)
    contrasena=$(zenity --title="Contraseña de administrador" --password)         
    nueva_contrasena=$(zenity --password --title="Cambio de contraseña")
    echo $contrasena | echo -e "$nueva_contrasena\n$nueva_contrasena" |sudo -S passwd $usuario && zenity --info --title="Cambio de contraseña de usuario" --text="Se ha cambiado la contraseña con éxito" || zenity --error --title="Cambio de contraseña de usuario" --text="Ha habido un error"
fi

done