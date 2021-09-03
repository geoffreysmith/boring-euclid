<br />
<p align="center">
<a href="https://github.com/geoffreysmith/boring-euclid">
    <img src="assets/logo.png" alt="boring-euclid logo" height="120">
</a>
    <h3 align="center">boring-euclid</h3>
  <p align="center">
    🚢 Container Install Scripts for Windows
  </p>
</p>

## Non-Docker Issue Tracker

As of Sept-02-2021:

* Rancher: https://github.com/rancher-sandbox/rancher-desktop/issues/566
* nerdctl/containerd: https://github.com/containerd/nerdctl/pull/197
* k3s: https://github.com/k3s-io/k3s/issues/114
* podman: https://github.com/containers/podman/issues/8136
* Windows Containers on Windows 10: https://www.jamessturtevant.com/posts/Windows-Containers-on-Windows-10-without-Docker-using-Containerd/

## Setup Hyper-V & WSL2

The following should be part of the base Windows image, run separately as administrator otherwise.

* `dism.exe /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V`
* Restart
* `dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`
* `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`
* `Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart`
* Restart
* `wsl --set-default-version 2`

## Setup & Run

* `./install.ps1`

## SSHFS Manager

* [sshfs-win-manager](https://github.com/evsar3/sshfs-win-manager/releases/tag/v1.3.0-beta.1)

## Generate and copy SSH key
* `ssh-keygen -t rsa -b 4096 -f ./id_rsa_shared`
* `ssh-copy-id -i ./id_rsa_shared remoteuser@remotehost`
