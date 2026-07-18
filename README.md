# 🐳 Enterprise Ubuntu 24.04 LTS VM inside Docker (KVM/QEMU)

An advanced, cloud-optimized **Ubuntu 24.04 LTS Virtual Machine** operating seamlessly inside a Docker container via QEMU hypervisor orchestration. This image bypasses standard interactive OS setups by launching a pre-baked cloud image instantly, allowing fully customizable dynamic hardware profiles (RAM, CPU, Storage) and direct user provisioning at runtime.

## ⚡ Core Engine Capabilities

* 🚀 **Instant Boot Architecture:** Powered by official Ubuntu Cloud image layers—zero setup waiting times.
* 💿 **Base OS Infrastructure:** * **Image Format**: Cloud-optimized `QCOW2` (Native Virtio support).
* **Base Distribution**: Ubuntu 24.04 LTS (Noble Numbat) Server Edition.
* **Boot Method**: Headless Cloud-Init provisioned (No interactive installer/ISO boot process).


* ⚙️ **Dynamic Sizing Configurations:** Control compute resources and automatically expand storage limits via initialization flags.
* 🔐 **Automated Secure Provisioning:** Built-in **cloud-init** configurations to inject specific deployment profiles instantly.

## 🔐 **Quick Access Credentials** * **Default Username**: root

* **Default Password**: root
* **Access**: root / root

## 🚀 Usage & Deployment Profiles

Fire up your Virtual Private Server (VPS) by passing your desired hardware capacity directly to the `docker run` statement through environment variables (`-e`):

### ⚡ Balanced VPS Profile (4GB RAM, 2 CPU Cores, 25GB Storage Disk)

```bash
docker run -it --rm \
  -v "$PWD/vmdata:/vmdata" \
  -p 2026:2222 \
  -e RAM=4098 \
  -e CPU=2 \
  -e DISK_SIZE=25G \
  walksysdev/ubuntu-vm

```

### 💻 Performance Profile (8GB RAM, 4 CPU Cores, 50GB Storage Disk)

```bash
docker run -it --rm \
  -v "$PWD/vmdata:/vmdata" \
  -p 2026:2222 \
  -e RAM=8192 \
  -e CPU=4 \
  -e DISK_SIZE=50G \
  walksysdev/ubuntu-vm

```

### 📦 CodeSanxBox VPS Profile (Defaults: 8GB RAM, 3 Cores, 100GB Storage Disk)

```bash
docker run -it --rm \
  -v "$PWD/vmdata:/vmdata" \
  -p 2026:2222 \
  -e RAM=7900 \
  -e CPU=4 \
  -e DISK_SIZE=100G \
  walksysdev/ubuntu-vm

```

## 🌐 Network Routing & Access Protocols

Once the container initialization is running, you can interact with your newly spawned Ubuntu machine through your web browser or terminal:

| Access Type | Protocol / Command | Default Credentials |
| --- | --- | --- |
| 🔐 **Secure SSH Console** | `ssh root@localhost -p 2026` | Username: `root` <br> <br> Password: `root` |

## 🛠️ Infrastructure Build Management

If you want to pull down the source configurations or compile the container manually:

### Image Download Command

```bash
docker pull walksysdev/ubuntu-vm:latest

```

### Manual Compilation Pipeline

```bash
docker rmi walksysdev/ubuntu-vm:latest --force 2>/dev/null || true && docker build --no-cache -t walksysdev/ubuntu-vm .

```

*Maintained with absolute precision by 🚀 [@walksysdev](https://hub.docker.com/r/walksysdev).*
