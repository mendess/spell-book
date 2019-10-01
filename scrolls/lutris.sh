echo Uncomments these lines:
echo '[multilib]'
echo Include = /etc/pacman.d/mirrorlist
read -r
sudo nvim /etc/pacman.conf
sudo pacman -Sy
yes | sudo pacman -S wine wine_gecko wine-mono gnutls lutris lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
