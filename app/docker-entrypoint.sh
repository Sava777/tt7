#!/bin/sh
HOME=/home/django/app
# configuring APP
cd $HOME
mv projectname $PROJECT_NAME
sed -i 's/{{ project_name }}/'$PROJECT_NAME'/g' $HOME/$PROJECT_NAME/wsgi.py
sed -i 's/{{ project_name }}/'$PROJECT_NAME'/g' $HOME/$PROJECT_NAME/settings/default.py
sed -i 's/projectname/'$PROJECT_NAME'/g' $HOME/$PROJECT_NAME/urls.py
sed -i 's/{{ db_name }}/'$MYSQL_DATABASE'/g' $HOME/$PROJECT_NAME/settings/default.py
sed -i 's/{{ db_user }}/'$MYSQL_USER'/g' $HOME/$PROJECT_NAME/settings/default.py
sed -i 's/{{ db_p@ssword }}/'$MYSQL_PASSWORD'/g' $HOME/$PROJECT_NAME/settings/default.py
sed -i 's/{{ db_engine }}/mysql/g' $HOME/$PROJECT_NAME/settings/default.py
sed -i 's/localhost/mysql/g' $HOME/$PROJECT_NAME/settings/default.py
sed -i "/DEBUG = False/c\DEBUG = True" $HOME/$PROJECT_NAME/settings/default.py
sed -i 's/django.db.backends.postgresql_psycopg2/django.db.backends.mysql/g' $HOME/$PROJECT_NAME/settings/default.py

# cp $HOME/$PROJECT_NAME/settings/local.template.py $HOME/$PROJECT_NAME/settings/local.py

# set SECRET_
SECRET_KEY=`python -c 'import random; import string; print "".join([random.SystemRandom().choice(string.digits + string.letters) for i in range(100)])'`
sed -i "/SECRET_KEY/c\SECRET_KEY='$SECRET_KEY'" $HOME/$PROJECT_NAME/settings/default.py

# while ! nc -z mysql 3306; do echo "*** looks like mysql is not ready yet"; sleep 3; done
while [ ! -e /entrypoint/mysql_started ]; do echo "*** looks like mysql is not ready yet"; sleep 3; done
echo "+++ Mysql server is ready +++"

echo Starting manage.py migrate
$HOME/$PROJECT_NAME/manage.py migrate

echo Starting manage.py collectstatic
$HOME/$PROJECT_NAME/manage.py collectstatic --no-post-process --noinput

echo Starting django dev server
cd $HOME && /usr/sbin/uwsgi  --socket 0.0.0.0:8080 --uid django --gid django --plugin-dir /usr/lib/uwsgi/ --plugin python --wsgi-file $PROJECT_NAME/wsgi.py

# cd $HOME && /usr/sbin/uwsgi  --socket 0.0.0.0:8080 --uid django --gid django --wsgi-file $PROJECT_NAME/wsgi.py
# cd $HOME && uwsgi --ini app.ini --plugin-dir /usr/lib/uwsgi/ --plugin python --protocol http --callable app --module wsgi --py-autoreload 1

