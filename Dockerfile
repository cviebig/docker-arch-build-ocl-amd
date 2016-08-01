FROM cviebig/arch-build-ocl

RUN pacman -S --noprogressbar --noconfirm opencl-headers java-environment unzip wget git

RUN mkdir -v -p /var/abs/local
RUN cd /var/abs/local && \
    git clone -b fix/3.0.130-136-GA-2 https://github.com/cviebig/arch-aur-amdapp-sdk.git amdapp-sdk && \
    git clone https://aur.archlinux.org/amdapp-aparapi.git && \
    git clone https://aur.archlinux.org/clinfo.git

RUN useradd -ms /bin/bash buildbot
RUN chown -R buildbot:buildbot /var/abs/local
RUN chmod -R 744 /var/abs/local
RUN su -c "cd /var/abs/local/amdapp-aparapi && makepkg" - buildbot
RUN pacman -U --noconfirm /var/abs/local/amdapp-aparapi/amdapp-aparapi-*-x86_64.pkg.tar.xz
RUN pacman -S --noconfirm apache-ant
RUN su -c "cd /var/abs/local/amdapp-sdk && makepkg" - buildbot
RUN pacman -U --noconfirm /var/abs/local/amdapp-sdk/amdapp-sdk-*-x86_64.pkg.tar.xz
RUN pacman -U --noconfirm /var/abs/local/amdapp-sdk/amdapp-sdk-nocatalyst-*-x86_64.pkg.tar.xz
RUN pacman -S --noconfirm git
RUN su -c "cd /var/abs/local/clinfo && makepkg" - buildbot
RUN pacman -U --noconfirm /var/abs/local/clinfo/clinfo-*-x86_64.pkg.tar.xz

