# Create folder location
New-Item -Path c:\ -Name Temp -ItemType Directory;
ECHO ' ============ # Create folder location END ============ ';

# Download openssh
(New-Object System.Net.WebClient).DownloadFile('https://github.com/PowerShell/Win32-OpenSSH/releases/download/v7.9.0.0p1-Beta/OpenSSH-Win64.zip','C:\Temp\OpenSSH-Win64.zip');
ECHO ' ============ # Download openssh END ============ ';

# Unzip the files
Expand-Archive -Path "C:\temp\OpenSSH-Win64.Zip" -DestinationPath "C:\Program Files\OpenSSH\";
ECHO ' ============ # Unzip the files END ============ ';

#Move \OpenSSH\OpenSSH-Win64\  \OpenSSH
mv 'C:\Program Files\OpenSSH\OpenSSH-Win64\*' 'C:\Program Files\OpenSSH';rm 'C:\Program Files\OpenSSH\OpenSSH-Win64';
ECHO ' ============ DELETE \OpenSSH\OpenSSH-Win64\ END ============ ';

# Install service
. "C:\Program Files\OpenSSH\install-sshd.ps1";
ECHO ' ============ # Install service END ============ ';

# Set firewall permissions
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22;
ECHO ' ============ # Set firewall permissions END ============ '

# Set service startup END
Set-Service sshd -StartupType Automatic;
Start-Service sshd;
ECHO ' ============ # Set service startup END END ============ ';

# Set Authentication to public key
((Get-Content -path C:\ProgramData\ssh\sshd_config -Raw) ` -replace '#PubkeyAuthentication yes','PubkeyAuthentication yes' ` -replace '#PasswordAuthentication yes','PasswordAuthentication no' ` -replace 'Match Group administrators','#Match Group administrators' ` -replace 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys','#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys') | Set-Content -Path C:\ProgramData\ssh\sshd_config;
ECHO ' ============ # Set Authentication to public key END ============ ';

# Restart after changes
Restart-Service sshd;
ECHO ' ============ # Restart after changes END ============ ';

# force file creation
New-item -Path $env:USERPROFILE -Name .ssh -ItemType Directory -force;
ECHO ' ============ # force file creation END ============ ';

# Copy key
echo "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHb0gLCqFYrN9f6MfTgkPrm5sBzeTqCIwIsMP2N58h/hXp/kTlHvH4+BcEGFu2iUuV1oHeAyNRul4b24x11KkwM= zusyurec@gmail.com" | Out-File $env:USERPROFILE\.ssh\authorized_keys -Encoding ascii;
ECHO ' ====== # Copy key END ======= ';
