#!/usr/bin/fish

# Run and ssh server
# Check if SSH host keys exist, generate them if they don't
if not test -f /etc/ssh/ssh_host_rsa_key
    echo "Generating new SSH host keys..."
    sudo ssh-keygen -A
end

# Start SSH server
sudo /usr/sbin/sshd

#########
# if there is a command passed to the entrypoint, execute it
# otherwise, just keep the container running
if test (count $argv) -eq 0; then
    echo "No command provided, keeping the container running..."
    sleep infinity
else
    exec $argv
end
