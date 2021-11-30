#!/bin/bash

# nextclod user list
# List for Example: nc-user.csv
# Basis elements of the csv list:
# username,group,group,display-name,email
# Can be expanded with the "password" field
# In my case, it is a complex system, (Postgresql, Dovecot, Postfix, Rspamd, Nextcloud).
# In this case, the username must include the domain name. By implication, the domain
# associated with the user name can be removed from the configuration.
# Replace nLusername with nUsername in the specified lines.
#
# Installed vHost as Domain
nDomain="nextcloud.home"
# Installed Directory
nDir=/var/www/$nDomain/htdocs/nextcloud
echo $nDir
# If there is a password field in the csv file, add the nPassword variable to the scan section and use it
# and put # in front of nPassword variable
nPassword="12Password_3"
{
read
while IFS="," read nUsername nGroup nGroup2 nDispname pEmail
#nPassword
do
  echo "Import: $nUsername"
  # Random password for live server. Uncomment it if you use
  # nPassword=$(pwgen 10 -c -n -N 1)
  export OC_PASS=$nPassword
  nLusername=$nUsername@$nDomain
  # Here you can replace nLusername with nUsername
  sudo -E -u apache php "$nDir"/occ user:add --password-from-env --display-name="$nDispname" --group="$nGroup" --group="$nGroup2" $nLusername
  sudo -E -u apache php "$nDir"/occ user:setting $nLusername settings email $pEmail
  # or delete
#  sudo -E -u apache php "$nDir"/occ user:delete $nLusername
  echo "$nUsername now is a user in $nDomain Domain"
  # CSV with username and password for users' email notifications
  # Here you can replace nLusername with nUsername
  echo $pEmail,$nLusername,$nPassword >> ./newusers.csv
done
} <  nc-users-list.csv
