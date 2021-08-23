# cp -r /home/$(whoami)/ssh_dump/. /home/$(whoami)/.ssh
sudo chown $(whoami):$(whoami) /opt/$1
cp -avr /workspaces/$1/.vscode/ /opt/$1/.vscode
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
ssh-keyscan -H git.ventor.tech >> ~/.ssh/known_hosts
git clone git@git.ventor.tech:kabs/erp.git /opt/$1/erp
git clone git@git.ventor.tech:kabs/ext-addons.git --recurse-submodules
git clone -b 13.0 --single-branch --depth 1 https://github.com/odoo/odoo.git /opt/$1/odoo
mkdir /opt/$1/all-addons
python3 /opt/$1/.vscode/create-links.py --manifest-file=/opt/$1/erp/project_setup/__manifest__.py --addons-path=/opt/$1/erp/ --addons-path=/opt/$1/ext-addons/ --link-path=/opt/$1/all-addons/
sudo pip3 install --upgrade pip
sudo pip3 install -r /opt/$1/odoo/requirements.txt
sudo service postgresql start
createdb workdb
bash /workspaces/$1/.devcontainer/odooconfcreate.sh $1 $2
sudo pip3 install -r /opt/$1/.vscode/requirements.txt
sudo pip3 install pylint-odoo==3.8.0
