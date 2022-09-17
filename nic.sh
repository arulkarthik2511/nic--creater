ipplus(){
IP_HEX=$(printf '%.2x%.2x%.2X%.2X\n' `echo $IP1 | sed -e 's/\./ /g'`)
NEXT_IP_HEX=$(printf '%.8x' `echo $((0x$IP_HEX + 1))`)
NEXT_IP=$(printf '%d.%d.%d.%d\n' `echo $NEXT_IP_HEX | sed -r 's/(..)/0x\1 /g'`)
echo "$NEXT_IP"
}
$sudo modprobe dummy
echo -n "Enter the interface name of the ip address:"
read interface
n=${#interface}
l1=$(echo $n)
l2=1
l=`expr $l1 - $l2`
a=$(echo $interface | cut -c -$l)
echo -n "Enter the machine ip:"
read IP
IP1=$IP
echo -n "Enter the number of virtual IP addresses to be created:"
read NUM
i=1; while [ $i -le $NUM ];
do
     IP1=$(ipplus $IP1)
      $sudo ip link add $a$i type dummy
      m=$(echo -n 00-60-2F; dd bs=1 count=3 if=/dev/random 2>/dev/null |hexdump -v -e '/1 "-%02X"')
      $sudo ifconfig $a$i hw ether $m
      $sudo ip addr add $IP1/24 brd + dev $a$i  label $a$i
      $sudo ip link set dev $a$i up
      i=$((i+1)); 
done

