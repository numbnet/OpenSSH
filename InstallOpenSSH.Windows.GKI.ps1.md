# Install OpenSSH Windows 10

# ==== Create folder location ====
New-Item -Path c:\ -Name Temp -ItemType Directory;
echo ' ==== END STEP ==== ';

# Download openssh
(New-Object System.Net.WebClient).DownloadFile('https://github.com/PowerShell/Win32-OpenSSH/releases/download/v7.9.0.0p1-Beta/OpenSSH-Win64.zip','C:\Temp\OpenSSH-Win64.zip');
echo ' ==== END STEP ==== ';

# Unzip the files
Expand-Archive -Path "C:\temp\OpenSSH-Win64.Zip" -DestinationPath "C:\Program Files\OpenSSH\";
echo ' ==== END STEP ==== ';

# Move \OpenSSH\OpenSSH-Win64\  \OpenSSH
mv 'C:\Program Files\OpenSSH\OpenSSH-Win64\*' 'C:\Program Files\OpenSSH';
echo ' ==== END STEP ==== ';

# Install service
. "C:\Program Files\OpenSSH\install-sshd.ps1";
echo ' ==== END STEP ==== ';

# Set firewall permissions
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22;
echo ' ==== END STEP ==== ';

# Set service startup END
Set-Service sshd -StartupType Automatic;
Start-Service sshd;
echo ' ==== END STEP ==== ';

# Set Authentication to public key
((Get-Content -path C:\ProgramData\ssh\sshd_config -Raw) ` -replace '#PubkeyAuthentication yes','PubkeyAuthentication yes' ` -replace '#PasswordAuthentication yes','PasswordAuthentication no' ` -replace 'Match Group administrators','#Match Group administrators' ` -replace 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys','#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys') | Set-Content -Path C:\ProgramData\ssh\sshd_config;
echo ' ==== END STEP ==== ';

# Restart after changes
Restart-Service sshd;
echo ' ==== END STEP ==== ';

# force file creation
New-item -Path $env:USERPROFILE -Name .ssh -ItemType Directory -force;
echo ' ==== END STEP ==== ';

# Copy key
echo "MYPUBLICKEY" | Out-File $env:USERPROFILE\.ssh\authorized_keys -Encoding ascii;
echo ' ==== END STEP ==== ';

# Clean
rm 'C:\Program Files\OpenSSH\OpenSSH-Win64';
echo ' ==== END STEP ==== ';
