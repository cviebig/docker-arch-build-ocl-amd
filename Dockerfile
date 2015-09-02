FROM cviebig/arch-build-ocl

RUN pacman -S --noprogressbar --noconfirm opencl-headers java-environment unzip

RUN mkdir -v -p /var/abs/local
RUN cd /var/abs/local && \
    curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/amdapp-sdk.tar.gz && \
    curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/amdapp-aparapi.tar.gz && \
    curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/clinfo.tar.gz && \
    tar -xzvf amdapp-sdk.tar.gz && \
    tar -xzvf amdapp-aparapi.tar.gz && \
    tar -xzvf clinfo.tar.gz

COPY ./AMD-APP-SDK-v3.0-0.113.50-Beta-linux64.tar.bz2 /var/abs/local/amdapp-sdk/

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
