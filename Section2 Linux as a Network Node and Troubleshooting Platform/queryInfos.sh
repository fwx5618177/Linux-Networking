echo -n "Basic Inventory for Hostname: "
uname -n

echo ========================

dmidecode | sed -n '/System Information/,+2p' | sed 's/\x09//'
dmesg | grep Hypervisor
dmidecode | grep "Serial Number" | grep -v "Not Specified" | grep -v None

echo ========================

echo "OS Information:"
uname -o -r

if [ -f /etc/redhat-release ]; then
    echo -n " "
    cat /etc/redhat-release
fi

if [ -f /etc/issue ]; then
    cat /etc/issue
fi

echo ========================

echo "IP Information: "
ip ad | grep inet | grep -v "127.0.0.1" | grep -v "::1/128" | tr -s " " | cut -d " " -f 3

# old version
#ifconfig | grep "inet" | grep -v "127.0.0.1" | grep -v "::1/128" | tr -s " " | cut -d " " -f 3

echo ========================

echo "CPU Information: "
cat /proc/cpuinfo | grep "model name\|MH\|vendor_id" | sort -r | uniq

echo -n "Socket Count: "
cat /proc/cpuinfo | grep processor | wc -l

echo -n "Core Count (Total): "
cat /proc/cpuinfo | grep cores | cut -d ":" -f 2 | awk '{ sum+=$1 } END { print sum }'

echo ========================

echo "Memory Information: "
grep MemTotal /proc/meminfo | awk '{ print $2, $3 }'

echo ========================

echo "Disk Information: "
fdisk -l | grep Disk | grep dev
