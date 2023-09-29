#!/bin/bash
#
# UserEndpoint SA for Outgoing Requests ( UC -> PS )
#
# \author Dragos Vingarzan vingarzan -at- fokus dot fraunhofer dot de
# \author xfrm Serge S. Yuriev  nevian -at- nevian dot org
#

ue=$1
port_uc=$2
pcscf=$3
port_ps=$4

spi_ps=$5

ealg=$6
ck=$7
alg=$8
ik=$9

if [ "$6" = "null" ] 
then
	ck='""'
fi

case "$ealg" in
	"aes-cbc" )
		ealg="cbc(aes)"
		;;
	"des-ede3-cbc" )
		ealg="cbc(des3_ede)"
		;;
	"null" )
		ealg="ecb(cipher_null)"
		;;
	* )
		echo Unknown EALG $ealg exiting..
		exit 127
		;;
esac

case "$alg" in
	"null" )
		alg="digest_null"
		;;
	"hmac-sha-1-96" )
		alg="hmac(sha1)"
		;;
	"hmac-md5-96" )
		alg="hmac(md5)"
		;;
	* )
		echo Unknown ALG $alg exiting..
		exit 127
		;;
esac

ip xfrm policy add src $ue dst $pcscf sport $port_uc dport $port_ps dir out tmpl proto esp reqid $$ mode transport
ip xfrm state add src $ue dst $pcscf proto esp spi $spi_ps mode transport enc $ealg $ck auth $alg $ik reqid $$
