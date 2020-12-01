



# Распаковываем в C:\Program Files\OpenSSH
# Обязательный момент для корректной работы: права на запись в этой директории должны быть только у SYSTEM и у админской группы.
# 
# Устанавливаем сервисы скриптом install-sshd.ps1 находящимся в этой директории
# 
# powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1
# 
# Разрешаем входящие подключения на 22 порт:
# 
# New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
# 
# Уточнение: апплет New-NetFirewallRule используется на Windows Server 2012 и новее. В наиболее старых системах (либо десктопных) можно воспользоваться командой:
# 
# netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22
# 
# Запускаем сервис:
# 
# net start sshd
# 
# При запуске будут автоматически сгенерированы хост-ключи (если отсутствуют) в %programdata%\ssh
# 
# Автозапуск сервиса при запуске системы мы можем включить командой:
# 
# Set-Service sshd -StartupType Automatic
# 
# Так же, можно сменить командную оболочку по умолчанию (после установки, по умолчанию — cmd):
# 
# New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
# 
# Уточнение: Необходимо указывать абсолютный путь.
# 
# Что дальше?
# 
# А дальше настраиваем sshd_config, который расположем в C:\ProgramData\ssh. Например:
# 
# PasswordAuthentication no
# PubkeyAuthentication yes
# 
# И создаем в пользовательской папке директорию .ssh, а в ней файл authorized_keys. Туда записываем публичные ключи.
# 
# Важное уточнение: права на запись в этот файл, должен иметь только пользователь, в чьей директории лежит файл.
# 
# Но если у вас проблемы с этим, всегда можно выключить проверку прав в конфиге:
# 
# StrictModes no
# 
# К слову, в C:\Program Files\OpenSSH лежат 2 скрипта (FixHostFilePermissions.ps1, FixUserFilePermissions.ps1), которые должны но не обязаны фиксить права, в том числе и с authorized_keys, но почему-то не фиксят.
# 
# Не забывайте перезапускать сервис sshd после для применения изменений.
# 
# ru-mbp-666:infrastructure$ ssh Administrator@192.168.1.10 -i ~/.ssh/id_rsa
# Windows PowerShell
# Copyright (C) 2016 Microsoft Corporation. All rights reserved.
# 
# PS C:\Users\Administrator> Get-Host
# 
# 
# Name             : ConsoleHost
# Version          : 5.1.14393.2791
# InstanceId       : 653210bd-6f58-445e-80a0-66f66666f6f6
# UI               : System.Management.Automation.Internal.Host.InternalHostUserInterface
# CurrentCulture   : en-US
# CurrentUICulture : en-US
# PrivateData      : Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy
# DebuggerEnabled  : True
# IsRunspacePushed : False
# Runspace         : System.Management.Automation.Runspaces.LocalRunspace
# 
# PS C:\Users\Administrator>
# 
# Субъективные плюсы/минусы.
# 
# Плюсы:
# 
# Стандартный подход к подключению к серверам.
# Когда есть немного Windows машин, очень неудобно когда:
# Так, сюда мы ходим по ssh, а тут рдп,
# и вообще best-practice с бастионами, сначала ssh-туннель, а через него RDP.
# Простота настройки
# Считаю что это очевидно.
# Скорость подключения и работы с удаленной машиной
# Нет графической оболочки, экономятся как ресурсы сервера, так и количество передаваемых данных.
# 
# Минусы:
# 
# Не заменяет RDP полностью.
# Не все можно сделать из консоли, увы. Я имею ввиду ситуации, когда требуется GUI.