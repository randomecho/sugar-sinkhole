#!/usr/bin/env bash

config='config.php'

sed -i '' -E "s/(db_host_name' => ')([0-9\.]+)(')/\1localhost', \/\/ \2/" ${config}
sed -i '' -E "s/(db_user_name' => ')([a-zA-Z0-9_\-\.]+)(')/\1root', \/\/ \2/" ${config}
sed -i '' -E "s/(db_password' => ')([a-zA-Z0-9_\-\.]+)(')/\1root', \/\/ \2/" ${config}
sed -i '' -E "s/(site_url' => ')([a-zA-Z0-9_\-\:\/\.]+)(')/\1http:\/\/127.0.0.1\/sugar', \/\/ \2/" ${config}
