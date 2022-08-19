#!/bin/sh
# Install lutris and all the dependencies needed for battle net, assuming nvidia

echo Uncomments these lines:
echo '[multilib]'
echo 'Include = /etc/pacman.d/mirrorlist'
read -r
sudo nvim /etc/pacman.conf
sudo pacman -Syu --needed \
    alsa-lib \
    alsa-plugins \
    giflib \
    gnutls \
    gst-plugins-base-libs \
    gtk3 \
    lib32-alsa-lib \
    lib32-alsa-plugins \
    lib32-giflib \
    lib32-gnutls \
    lib32-gst-plugins-base-libs \
    lib32-gtk3 \
    lib32-libgcrypt \
    lib32-libgpg-error \
    lib32-libjpeg-turbo \
    lib32-libldap \
    lib32-libpng \
    lib32-libpulse \
    lib32-libva \
    lib32-libxcomposite \
    lib32-libxinerama \
    lib32-libxslt \
    lib32-mesa \
    lib32-mpg123 \
    lib32-ncurses \
    lib32-nvidia-utils \
    lib32-openal \
    lib32-opencl-icd-loader \
    lib32-sqlite \
    lib32-v4l-utils \
    lib32-vulkan-icd-loader \
    lib32-vulkan-intel \
    libgcrypt \
    libgpg-error \
    libjpeg-turbo \
    libldap \
    libpng \
    libpulse \
    libva \
    libxcomposite \
    libxinerama \
    libxslt \
    lutris \
    mpg123 \
    ncurses \
    nvidia-dkms \
    nvidia-settings \
    nvidia-utils \
    openal \
    opencl-icd-loader \
    sqlite \
    v4l-utils \
    vulkan-icd-loader \
    vulkan-intel \
    wine \
    wine-gecko \
    wine-mono \
    wine-staging \
    wine_gecko \
