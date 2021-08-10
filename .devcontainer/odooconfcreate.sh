echo -e "[options]\n"\
"db_host=localhost\n"\
"db_port=$2\n"\
"db_user=$(whoami)\n"\
"db_password=1111\n"\
"db_name=workdb\n"\
"addons_path=/opt/$1/odoo/addons,/opt/$1/all-addons"\
>> /opt/$1/odoo.conf