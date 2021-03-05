#!/bin/bash

# Register
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config

# Swap tuning
dd if=/dev/zero of=/swapfile bs=1M count=${swap_size}
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon -s
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
