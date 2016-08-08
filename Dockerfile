FROM cviebig/arch-build-ocl

RUN pacman -S --noprogressbar --noconfirm wget && \
    mkdir -v -p /var/abs/local && \
    cd /var/abs/local && \
    git clone -b fix/3.0.130-136-GA-2 https://github.com/cviebig/arch-aur-amdapp-sdk.git amdapp-sdk && \
    useradd -ms /bin/bash build || true && \
    chown -R build:build /var/abs/local && \
    chmod -R 744 /var/abs/local && \
    pacman -S --noconfirm apache-ant && \
    su -c "cd /var/abs/local/amdapp-sdk && makepkg" - build && \
    pacman -U --noconfirm /var/abs/local/amdapp-sdk/amdapp-sdk-*-x86_64.pkg.tar.xz && \
    pacman -U --noconfirm /var/abs/local/amdapp-sdk/amdapp-sdk-nocatalyst-*-x86_64.pkg.tar.xz && \
    rm -rf /var/abs/local/* && \
    pacman -Rcs --noconfirm apache-ant && \
    pacman -Scc --noconfirm
