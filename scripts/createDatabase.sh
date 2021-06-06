sudo apt install mysql-server -y
sudo mysql -e 'CREATE DATABASE CloudRemoteControl;'
cd .. 
cd source/sql

for i in *.sql
do
    echo "Importing: $i"
    sudo mysql CloudRemoteControl < $i
    wait
done 
sudo mysql -e "use CloudRemoteControl; CREATE USER 'developer'@'localhost' IDENTIFIED WITH mysql_native_password BY 'CloudRemoteControl';"
sudo mysql -e "GRANT ALL PRIVILEGES ON CloudRemoteControl.* TO 'developer'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "use CloudRemoteControl; FLUSH PRIVILEGES;"
