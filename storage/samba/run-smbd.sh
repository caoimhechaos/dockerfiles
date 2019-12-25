#!/bin/sh

set_smb_setting() {
	setting="$1"
	value="$2"

	sed -i -e "s/^[#;]*[ \t]*${setting} = .*$/   ${setting} = $value/g"	\
		/etc/samba/smb.conf
}

install -o root -g root -d 0755 /var/lib/samba /var/lib/samba/sysvol
install -o root -g root -d 0770 /var/lib/samba/bind-dns
install -o root -g root -d 0700 /var/lib/samba/private

if test x"$SAMBA_WORKGROUP" = x || test x"$SAMBA_SERVER_NAME" = x
then
	echo "Required environment variable not set. Required:" 1>&2
	echo SAMBA_WORKGROUP, SAMBA_SERVER_NAME, SAMBA_ROLE 1>&2
	exit 1
fi

if test x"$SAMBA_ROLE" = xsmbd || test x"$SAMBA_ROLE" = xnmbd
then
	:
else
	echo "SAMBA_ROLE must be set to either smbd or nmbd." 1>&2
	exit 1
fi

set_smb_setting "workgroup" "$SAMBA_WORKGROUP"
set_smb_setting "server string" "$SAMBA_SERVER_NAME"
set_smb_setting "server role" "standalone server"
set_smb_setting "guest account" "nobody"

if test x"$SAMBA_LDAP_SERVER" = x
then
	set_smb_setting "passdb backend" "tdbsam"

	# make sure all SAMBA users have UNIX equivalents.
	for user in `pdbedit -L -v | grep '^Unix username' | awk '{ print $3 }'`
	do
		/usr/sbin/adduser -G users -s /sbin/nologin -D "$user"
	done
else
	set_smb_setting "passdb backend" "ldapsam"
fi

set_smb_setting "wins support" "yes"

for dir in /export/*
do
	bn=`basename "$dir"`
	if test -f "$dir/.description"
	then
		description=`head -n 1 "$dir/.description"`
	else
		description="Directory $bn"
	fi
	cat << EOT >> /etc/samba/smb.conf

[$bn]
   comment = $description
   path = $dir
   public = no
   writable = yes
   create mask = 0660
   directory mask = 0770

EOT
	if test -f "$dir/.acl"
	then
		users=`xargs echo < "$dir/.acl"`
		echo "   valid users = $users" >> /etc/samba/smb.conf
	fi
done

echo "Launching $SAMBA_ROLE"
exec /usr/sbin/$SAMBA_ROLE --foreground -S --no-process-group -d 31 < /dev/null
