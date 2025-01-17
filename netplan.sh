import os
import subprocess

def main():
    print("\nNetplan Static IP Configuration Script")
    print("=====================================")

    # Benutzer nach den erforderlichen Eingaben fragen
    interface = input("Geben Sie den Namen des Netzwerkinterfaces ein (z. B. eth0): ")
    static_ip = input("Geben Sie die statische IP-Adresse ein (z. B. 192.168.1.100): ")
    subnet_mask = input("Geben Sie die Subnetzmaske ein (z. B. 255.255.255.0): ")
    gateway = input("Geben Sie die Gateway-Adresse ein (z. B. 192.168.1.1): ")
    dns_servers = input(
        "Geben Sie die DNS-Server ein (kommagetrennt, z. B. 8.8.8.8,8.8.4.4): "
    )

    # Subnetzmaske in CIDR-Notation umwandeln
    subnet_bits = sum([bin(int(x)).count('1') for x in subnet_mask.split('.')])
    cidr_ip = f"{static_ip}/{subnet_bits}"

    # Netplan-Konfiguration erstellen
    netplan_config = f"""
network:
  version: 2
  renderer: networkd
  ethernets:
    {interface}:
      addresses:
        - {cidr_ip}
      gateway4: {gateway}
      nameservers:
        addresses: [{dns_servers}]
"""

    print("\nGenerierte Netplan-Konfiguration:\n")
    print(netplan_config)

    # Datei speichern
    config_path = f"/etc/netplan/{interface}-static.yaml"
    try:
        with open(config_path, "w") as config_file:
            config_file.write(netplan_config)
        print(f"\nKonfigurationsdatei wurde erfolgreich unter {config_path} gespeichert.")

        # Anwenden der Netplan-Konfiguration
        apply = input("Möchten Sie die Netplan-Konfiguration jetzt anwenden? (ja/nein): ").strip().lower()
        if apply in ["ja", "yes"]:
            subprocess.run(["netplan", "apply"], check=True)
            print("Netplan-Konfiguration wurde erfolgreich angewendet.")
        else:
            print("Netplan-Konfiguration wurde nicht angewendet. Sie können dies später mit 'netplan apply' tun.")
    except PermissionError:
        print("Fehler: Keine Berechtigung, die Datei zu schreiben. Führen Sie das Skript mit 'sudo' aus.")
    except Exception as e:
        print(f"Ein Fehler ist aufgetreten: {e}")

if __name__ == "__main__":
    main()
