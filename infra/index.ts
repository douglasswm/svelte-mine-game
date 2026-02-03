import * as pulumi from "@pulumi/pulumi";
import * as digitalocean from "@pulumi/digitalocean";

const config = new pulumi.Config();

// Configuration with sensible defaults
const region = config.get("region") || "nyc3";
const dropletSize = config.get("dropletSize") || "s-1vcpu-1gb";
const sshKeyFingerprint = config.get("sshKeyFingerprint");

// Repository URL for cloning the app
const repoUrl = "https://github.com/douglasswm/svelte-mine-game.git";

// User data script to set up the droplet
const userData = `#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -ex

# Update system packages
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Install Node.js 20.x LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Install nginx
apt-get install -y nginx

# Install git
apt-get install -y git

# Create app directory
mkdir -p /var/www/app
cd /var/www/app

# Clone the repository
git clone ${repoUrl} .

# Remove pnpm lock file to avoid conflicts with npm
rm -f pnpm-lock.yaml

# Install dependencies and build
npm install --legacy-peer-deps
npm run build

# Create systemd service for the Node.js app
cat > /etc/systemd/system/svelte-app.service << 'EOFSERVICE'
[Unit]
Description=Svelte Mine Game
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/app
ExecStart=/usr/bin/node build/index.js
Restart=on-failure
Environment=PORT=3000
Environment=HOST=0.0.0.0
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOFSERVICE

# Set ownership
chown -R www-data:www-data /var/www/app

# Configure nginx as reverse proxy
cat > /etc/nginx/sites-available/default << 'EOFNGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOFNGINX

# Enable and start services
systemctl daemon-reload
systemctl enable svelte-app
systemctl start svelte-app
systemctl enable nginx
systemctl restart nginx

echo "User data script completed successfully"
`;

// Create the droplet
const droplet = new digitalocean.Droplet("svelte-mine-game", {
    image: "ubuntu-24-04-x64",
    region: region,
    size: dropletSize,
    userData: userData,
    monitoring: true,
    dropletAgent: true,
    sshKeys: sshKeyFingerprint ? [sshKeyFingerprint] : undefined,
    tags: ["svelte-mine-game", "web"],
});

// Create firewall to allow HTTP, HTTPS, and SSH
const firewall = new digitalocean.Firewall("svelte-mine-game-fw", {
    dropletIds: [droplet.id.apply(id => parseInt(id))],
    inboundRules: [
        {
            protocol: "tcp",
            portRange: "22",
            sourceAddresses: ["0.0.0.0/0", "::/0"],
        },
        {
            protocol: "tcp",
            portRange: "80",
            sourceAddresses: ["0.0.0.0/0", "::/0"],
        },
        {
            protocol: "tcp",
            portRange: "443",
            sourceAddresses: ["0.0.0.0/0", "::/0"],
        },
        {
            protocol: "icmp",
            sourceAddresses: ["0.0.0.0/0", "::/0"],
        },
    ],
    outboundRules: [
        {
            protocol: "tcp",
            portRange: "1-65535",
            destinationAddresses: ["0.0.0.0/0", "::/0"],
        },
        {
            protocol: "udp",
            portRange: "1-65535",
            destinationAddresses: ["0.0.0.0/0", "::/0"],
        },
        {
            protocol: "icmp",
            destinationAddresses: ["0.0.0.0/0", "::/0"],
        },
    ],
});

// Export useful information
export const dropletIp = droplet.ipv4Address;
export const dropletUrn = droplet.dropletUrn;
export const appUrl = pulumi.interpolate`http://${droplet.ipv4Address}`;
