# ExScripts

Дополнительные скрипты для метеорных станций **[RMS](https://github.com/CroatianMeteorNetwork/RMS) Южно-российской метеорной сети ([SRMN](https://vk.com/meteors_ru))**.  
Используются на станциях:  
**RU0001, RU0003, RU0004, RU0008, RU0009, RU000E, RU000F, RU000Q, RU000M, RU000N, RU0016, RU0017, RU0018, RU0019**.

![Карта расположения станций](https://sun9-22.userapi.com/impg/JGGJCNlv7AOLHDvGvG7XxKrXFumi8wOMUoUZ9Q/KmM-aq6yIHc.jpg?size=837x717&quality=96&sign=fb18f0e06e173bdb89468c209823abdd&type=album)

# Назначение

* Загрузка **csv**-файлов в облачные хранилища [Dropbox](https://www.dropbox.com/scl/fo/yikgso2z4ryaomtkzf4k5/h?rlkey=lts3izkjqrjdbonw66yd7gutk&st=rjbr3pwz&dl=0) и [Яндекс-диск](https://disk.yandex.ru/d/OZFWYsc6uEfvCQ);
* Загрузка архивов в централизованное **FTP**-хранилище (для доступа обратитесь к [автору проекта](https://vk.com/rdaneel_olivaw));
* Загрузка изображений на сайт [проекта Starvisor](https://starvisor.ru/meteor/);
* [Проверка и очистка](https://github.com/sgkaufman/RMS_extra_tools/).

# Перед установкой

Обратитесь к [автору проекта](https://vk.com/rdaneel_olivaw) для получения [конфигурационного файла загрузки csv-файлов](UploadCSV/.up_csv.cfg) в облачные хранилища [Dropbox](https://www.dropbox.com/scl/fo/yikgso2z4ryaomtkzf4k5/h?rlkey=lts3izkjqrjdbonw66yd7gutk&st=rjbr3pwz&dl=0) и [Яндекс-диск](https://disk.yandex.ru/d/OZFWYsc6uEfvCQ),  а также для получения [конфигурационного файла загрузки архивов на FTP-сервер](UpArchives/.uparchives.cfg), IP-адреса, номера порта, логина и пароля.

Также свяжитесь с [Ильёй Янковским](https://vk.com/jankowsky) для создания [персональной страницы станции](https://starvisor.ru/meteor/) на сайте [проекта Starvisor](https://starvisor.ru/contacts/). После этого вы получите [третий конфигурационный файл загрузки](Starvisor/.starvisor.cfg).

В конечном итоге вы должны получить:

* Персональную страницу на сайте [проекта Starvisor](https://starvisor.ru/meteor/);
* Три конфигурационных файла (обратите внимание, что файлы с точкой являются скрытыми. Включите отображение скрытых файлов!):

    - **.up_csv.cfg**  
    - **.uparchives.cfg**  
    - **.starvisor.cfg**  

* Адрес, порт;
* Логин и пароль.

# Последовательность установки
## 1. Редактировать список репозиториев **APT**-пакетов
### 1.1. Определить версию дистрибутива
Открыть терминал (**Ctr+Alt+T**).
Ввести команду:

```
cat /etc/os-release
```

Определить значение параметра в первой строке: **'PRETTY_NAME='**  
В зависимости от версии ОС и модели компьютера она будет иметь следующий вид:  

PRETTY_NAME=**"Raspbian GNU/Linux 8 (jessie)"** для сборки **Raspberry Pi3 B+ Jessie**  
PRETTY_NAME=**"Raspbian GNU/Linux 10 (buster)"** для сборки **Raspberry Pi4 Buster**  
PRETTY_NAME=**"Debian GNU/Linux 11 (bullseye)"** для сборки **Raspberry Pi4 Bullseye**  

> [!WARNING]
> По состоянию на 16 сентября 2024 года **Raspberry Pi3 B+ Jessie** и **Raspberry Pi4 Buster** больше **не поддерживаются**!  
> Но образы **пока ещё** доступны для [скачивания](https://globalmeteornetwork.org/projects/sd_card_images/).  
> **UPD:** Поддержка **Raspberry Pi3 B+ Jessie** [продлена до 1 июля 2025 года](https://globalmeteornetwork.groups.io/g/main/message/12670).

### 1.2. Отредактировать список репозиториев в консольном текстовом редакторе **NANO**

```
sudo nano /etc/apt/sources.list
```

В зависимости от результата, полученного на предыдущем шаге, редактируем файл следующим образом:

* **Raspberry Pi3 B+ Jessie**  
Заменить содержимое файла:

```
deb http://archive.debian.org/debian/ jessie main non-free contrib
deb-src http://archive.debian.org/debian/ jessie main non-free contrib
deb http://archive.debian.org/debian-security/ jessie/updates main non-free contrib
deb-src http://archive.debian.org/debian-security/ jessie/updates main non-free contrib
```

* **Raspberry Pi4 Buster**  
Удалить комментарий: **'#'** перед последней строкой:

```
deb-src http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
```

Сохранить изменениия: **Ctr+O**.
Закрыть редактор: **Ctr+X**.
### 1.3. Обновить список репозиториев
```
sudo apt-get update
```
В случае появления ошибки (устаревшая **Raspberry Pi3 B+ Jessie**), выполнить:
```
sudo apt-get install debian-archive-keyring
sudo apt-get update
```
## 2. Установить пакеты

* Для **Raspberry Pi4 Buster** и **Raspberry Pi4 Bullseye**:
```
pip install dropbox
pip3 install yadisk
sudo apt install entr figlet ftp-upload
```

* Для устаревшей **Raspberry Pi3 B+ Jessie**
```
pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org dropbox

cd source
git clone https://github.com/ivknv/yadisk
cd yadisk
git checkout 45652154d017f8bc62a0ecc5079b0379a33a9689
sudo python3 setup.py install

cd ~/source
git clone https://github.com/eradman/entr.git
cd entr
./configure
make test
sudo make install

sudo apt install bc figlet ftp-upload
```
## 3. Клонировать репозиторий
```
cd ~/source
git clone https://github.com/Vasiliy1992/ExScripts.git
```
Поместите **с заменой** полученные вами ранее конфигурационные файлы

- .up_csv.cfg  
- .uparchives.cfg  
- .starvisor.cfg  

В соответствующие папки:

- **~/source/ExScripts/UploadCSV**/.up_csv.cfg  
- **~/source/ExScripts/UpArchives**/.uparchives.cfg 
- **~/source/ExScripts/Starvisor**/.starvisor.cfg 

где "**~**" - домашняя директория (**/home/pi** или **/home/rms** в последних сборках).  

Для этого используйте любой удобный для вас способ:

* Передачу файлов через **AnyDesk**  
* Утилиту **scp**  
* Файловый менеджер **mc**  
и пр.

## 4. Отредактировать конфигурационный файл RMS
```
nano ~/source/RMS/.config
```
Изменить путь к "внешнему скрипту" следующим образом:
```
external_script_path: /home/pi/source/ExScripts/MainExScript.py
```
> [!WARNING]
> В последних сборках (начиная с **Raspberry Pi4 Bullseye**) используйте **/home/rms** вместо **/home/pi**.

Для **Raspberry Pi4 Bullseye**:
```
external_script_path: /home/rms/source/ExScripts/MainExScript.py
```
А также изменить параметры:
```
; Enable running an external script at the end of every night. it will be passed
; three arguments: captured_night_dir, archived_night_dir, config
external_script_run: true

; Reboot the computer daily after processing and upload
reboot_after_processing: false

; Directory for log files
log_dir: logs/RMS_logs

; Enable/disable saving a live.jpg file in the data directory with the latest image
live_jpg: true
```
Если какой-либо из параметров отсутствует, введите его вручную.

## 5. Настроить **entr**
Добавить скрипт отслеживания изменений файла **live.jpg** в автозапуск:
* Для устаревшей **Raspberry Pi3 Jessie**:
```
sudo nano /home/pi/.config/lxsession/LXDE-pi/autostart
```
* Для  **Raspberry Pi4 Buster** и **Bullseye**:
```
sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
```
Перед строкой **@xscreensaver -no-splash** вставить:
* Для **Raspberry Pi3 Jessie** и **Raspberry Pi4 Buster**:
```
# Starvisor
/home/pi/source/ExScripts/Starvisor/entr_run.sh &
```
* Для **Raspberry Pi4 Bullseye**:
```
# Starvisor
/home/rms/source/ExScripts/Starvisor/entr_run.sh &
```
Для проверки работы перезагрузить систему:
```
sudo reboot
```
После загрузки скопировать тестовый файл:
```
cp ~/source/ExScripts/Starvisor/live.jpg ~/RMS_data
```
Затем проверить страницу станции.

## 6. Настройка загрузки архивов
Отредактировать файл:
```
sudo nano /etc/hosts
```
Вставить:

```
IP_adress     ru000q
```
где **IP_adress** - IP-адрес сервера, предоставленный вам ранее

Отредактировать файл:
```
sudo nano ~/.ssh/config
```
Вставить:
```
host SRMN
	Hostname hostname
	User srmn
	Port XXX
```
где **XXX** - номер порта, предоставленный вам ранее

Скопировать плюч:
```
ssh-copy-id SRMN
```
Ввести предоставленный вам логин и пароль.

## Завершающий этап

Отредактируйте файл:

```
nano ~/.bashrc
```
Вставьте в конец файла строки:

```
# Check RMS log
alias cklog='~/source/Utils/UserScripts/CheckLog.sh'

# Running an external script
alias exscript='~/source/ExScripts/Utils/ExScript_last_dir.sh'

# Upload archives
alias uparch='~/source/ExScripts/UpArchives/UpArchives.sh'
```
Перезапустите:
```
. ~/.bashrc
```
Вам будут доступны новые команды:

**cklog** - отображение текущего лога **RMS** в окне удалённого терминала (удобно при подключении по **ssh**);  
**exscript** - принудительный запуск "внешнего скрипта" - постпроцесса;  
**uparch** - принудительный запуск загрузки архивов.  

# Интернет-ресурсы

[Global Meteor Network](https://globalmeteornetwork.org/?topic=ufoorbit-support)  
[Wiki Main Page](https://globalmeteornetwork.org/wiki/index.php?title=Main_Page)  
[GitHub Global Meteor Network](https://github.com/CroatianMeteorNetwork)  
[YouTube Global Meteor Network](https://www.youtube.com/@globalmeteornetwork8382)  

[GMN camera status page for Russian Federation](https://globalmeteornetwork.org/weblog/RU/index.html)  
[GMN RU Latest Status](https://globalmeteornetwork.org/status/)  

[GMN Meteor Map](https://www.meteorview.net/map3)  
[Meteor map](https://tammojan.github.io/meteormap/)  

[Meteor Shower Flux Monitoring](https://globalmeteornetwork.org/flux/)  
[Radiants and data](https://globalmeteornetwork.org/data/)  

[Access our Data - GMN Data Explorer](https://explore.globalmeteornetwork.org/)  
[gmn-python-api](https://gmn-python-api.readthedocs.io/en/latest/)  

[Руководство по сборке и настройке станции](https://disk.yandex.ru/d/kr1lVkyqDzQY-Q)  
[Dropbox](https://www.dropbox.com/scl/fo/yikgso2z4ryaomtkzf4k5/h?rlkey=lts3izkjqrjdbonw66yd7gutk&st=rjbr3pwz&dl=0)  
[Яндекс-диск](https://disk.yandex.ru/d/OZFWYsc6uEfvCQ)  
[Starvisor](https://starvisor.ru/meteor/)  
