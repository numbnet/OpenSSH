
# ==== installOpenSSHServ ==== #
##=======================================
### Download OpenSSH 
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'

# Затем установите компоненты сервера и / или клиента:
# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Both of these should return the following output:

#Path          :
#Online        : True
#RestartNeeded : False


# Удаление OpenSSH

# Uninstall the OpenSSH Client
# Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Uninstall the OpenSSH Server
# Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

#### После удаления OpenSSH может потребоваться перезагрузка Windows, если служба использовалась во время удаления.

# Первоначальная настройка SSH-сервера
#### Чтобы настроить сервер OpenSSH для первоначального использования в Windows, запустите PowerShell от имени администратора, а затем выполните следующие команды для запуска службы SSHD:
Start-Service sshd

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup.
Get-NetFirewallRule -Name *ssh*

# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled
# If the firewall does not exist, create one
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22


# Первоначальное использование SSH
#### Установив сервер OpenSSH в Windows, вы можете быстро протестировать его с помощью PowerShell с любого устройства Windows с установленным клиентом SSH. В PowerShell введите следующую команду:

#Ssh username@servername