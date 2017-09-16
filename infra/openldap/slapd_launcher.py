from jinja2 import Environment, FileSystemLoader
from shutil import copyfile
import os
import subprocess
import sys

TEMPLATE_PATH = '/etc/openldap/templates'
OUTPUT_PATH = '/etc/openldap/slapd.d'
TEMPLATE_FILES = [
    'cn=config/cn=module{0}.ldif',
    'cn=config/olcDatabase={-1}frontend.ldif',
    'cn=config/olcDatabase={1}hdb.ldif',
    'cn=config.ldif',
]


env = Environment(
    loader=FileSystemLoader(TEMPLATE_PATH)
)
args = {
    'dnsdomainname': os.environ['LDAP_DNS_DOMAINNAME'],
    'ldap_etc_path': '/etc/openldap',
    'ldap_data_path': '/var/lib/openldap/openldap-data',
    'ldap_base_dn': os.environ['LDAP_BASE_DN'],
    'ldap_module_path': '/usr/lib/openldap',
    'sasl_host': os.environ['LDAP_SASL_HOST'],
    'olc_root_pw': open('/secret/ldap_root_pw/manager').read(),
    }


def processFile(path):
    out_filename = os.path.join(OUTPUT_PATH, path)

    if path in TEMPLATE_FILES:
        template = env.get_template(path)
        output = open(out_filename, 'w')
        output.write(template.render(**args) + '\n')
        output.close()
    else:
        copyfile(os.path.join(TEMPLATE_PATH, path), out_filename)


def processDir(path):
    if not path:
        full_path = TEMPLATE_PATH
    else:
        full_path = os.path.join(TEMPLATE_PATH, path)

    for name in os.listdir(full_path):
        new_path = os.path.join(path, name)
        full_new_path = os.path.join(TEMPLATE_PATH, new_path)
        full_output_path = os.path.join(OUTPUT_PATH, new_path)

        if os.path.isdir(full_new_path):
            if not os.path.exists(full_output_path):
                os.mkdir(full_output_path)
            processDir(new_path)
        else:
            processFile(new_path)


if os.path.exists('/var/lib/openldap/ldap-rid'):
    rid = int(open('/var/lib/openldap/openldap-data/ldap-rid').read())
    args.update(ldap_syncrepl_rid=rid)

if 'LDAP_MASTER' in os.environ:
    args.update({
        'master': os.environ['LDAP_MASTER'],
        'syncrepl_pw': open('/secret/ldap_syncrepl_pw/syncrepl').read(),
    })

processDir('')
sys.stdout.flush()
sys.stderr.flush()

check = subprocess.run([
    '/usr/sbin/slaptest', '-F', '/etc/openldap/slapd.d', '-v'
    ])
if check.returncode != 0:
    sys.exit(check.returncode)

# Run slapd with -d 1 to force logging to stdout.
os.execl('/usr/sbin/slapd', '/usr/sbin/slapd', '-h', 'ldaps://0.0.0.0:1636/',
    '-g', 'ldap', '-u', 'ldap', '-F', '/etc/openldap/slapd.d', '-d', '1')
