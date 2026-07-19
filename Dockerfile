FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    qemu-system-x86 \
    qemu-utils \
    genisoimage \
    curl \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV RAM=7900
ENV CPU=3
ENV DISK_SIZE=100G
ENV IMAGE_URL=https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

RUN mkdir -p /vmdata
WORKDIR /vmdata

RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'set -e' >> /entrypoint.sh && \
    echo 'IMAGE_NAME=$(basename "$IMAGE_URL")' >> /entrypoint.sh && \
    echo 'clear' >> /entrypoint.sh && \
    echo 'echo "=================================================="' >> /entrypoint.sh && \
    echo 'echo "    Welcome to WalksysDev Ubuntu KVM VPS           "' >> /entrypoint.sh && \
    echo 'echo "=================================================="' >> /entrypoint.sh && \
    echo 'if [ -f "$IMAGE_NAME" ]; then' >> /entrypoint.sh && \
    echo '    echo "Found an existing VPS disk image."' >> /entrypoint.sh && \
    echo '    echo "1) Start existing VPS (Keep all your data)"' >> /entrypoint.sh && \
    echo '    echo "2) Re-install VPS (Wipe data and fresh start)"' >> /entrypoint.sh && \
    echo '    printf \"Choose an option [1-2]: \"' >> /entrypoint.sh && \
    echo '    read -r CHOICE' >> /entrypoint.sh && \
    echo 'else' >> /entrypoint.sh && \
    echo '    CHOICE=\"2\"' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo 'if [ "$CHOICE" = \"2\" ]; then' >> /entrypoint.sh && \
    echo '    echo \"Preparing a fresh installation...\"' >> /entrypoint.sh && \
    echo '    rm -f \"$IMAGE_NAME\" cloud-init.iso user-data meta-data' >> /entrypoint.sh && \
    echo '    echo \"Downloading Ubuntu cloud image...\"' >> /entrypoint.sh && \
    echo '    curl -L -# -o \"$IMAGE_NAME\" \"$IMAGE_URL\"' >> /entrypoint.sh && \
    echo '    echo \"Resizing disk to $DISK_SIZE...\"' >> /entrypoint.sh && \
    echo '    qemu-img resize \"$IMAGE_NAME\" \"$DISK_SIZE\" > /dev/null 2>&1' >> /entrypoint.sh && \
    echo '    cat <<EOF > user-data' >> /entrypoint.sh && \
    echo '#cloud-config' >> /entrypoint.sh && \
    echo 'hostname: WalksysDev' >> /entrypoint.sh && \
    echo 'ssh_pwauth: true' >> /entrypoint.sh && \
    echo 'chpasswd:' >> /entrypoint.sh && \
    echo '  list: |' >> /entrypoint.sh && \
    echo '    root:root' >> /entrypoint.sh && \
    echo '  expire: false' >> /entrypoint.sh && \
    echo 'EOF' >> /entrypoint.sh && \
    echo '    echo \"instance-id: walksysdev-vps\" > meta-data' >> /entrypoint.sh && \
    echo '    echo \"local-hostname: WalksysDev\" >> meta-data' >> /entrypoint.sh && \
    echo '    genisoimage -output cloud-init.iso -volid cidata -joliet -rock user-data meta-data > /dev/null 2>&1' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo 'if [ -e /dev/kvm ]; then' >> /entrypoint.sh && \
    echo '    KVM_ARGS=\"-enable-kvm -cpu host\"' >> /entrypoint.sh && \
    echo 'else' >> /entrypoint.sh && \
    echo '    KVM_ARGS=\"-cpu qemu64\"' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo 'echo \"Starting VPS...\"' >> /entrypoint.sh && \
    echo 'exec qemu-system-x86_64 -m \"$RAM\" -smp \"$CPU\" $KVM_ARGS -drive file=\"$IMAGE_NAME\",format=qcow2,if=virtio,cache=writeback,discard=ignore -drive file=cloud-init.iso,format=raw,readonly=on,if=virtio -net nic,model=virtio -net user,hostfwd=tcp::2222-:22 -nographic 2>/dev/null' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
