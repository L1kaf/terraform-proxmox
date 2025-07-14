#!/bin/bash
apt update && apt install -y ${package}
systemctl enable ${package}
systemctl start ${package}
