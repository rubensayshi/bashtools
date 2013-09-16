gnome-terminal --working-directory="/work/jaws" \
               --maximize \
               --tab-with-profile="Default" --title="terminal.local" \
               --tab-with-profile="Default" --title="serve.local" \
               --tab-with-profile="Default" --title="watch.local" \
               --tab-with-profile="Default" --title="celery.local" \
               --tab-with-profile="Default" --title="mysql.local"

exit 0

gnome-terminal --working-directory="/work/jaws" \
               --maximize \
               --tab-with-profile="HOLD" --title="terminal.local" -e 'bash -c "export BASH_POST_RC=\"workon jaws;\"; exec bash"' \
               --tab-with-profile="HOLD" --title="serve.local" -e 'bash -c "export BASH_POST_RC=\"workon jaws; ck serve --host=\\\"0.0.0.0\\\" --port=\\\"5000\\\";\"; exec bash"' \
               --tab-with-profile="HOLD" --title="watch.local" -e 'bash -c "export BASH_POST_RC=\"workon jaws; grunt; grunt watch;\"; exec bash"' \
               --tab-with-profile="HOLD" --title="celery.local" -e 'bash -c "export BASH_POST_RC=\"workon jaws; celery worker --app=jaws.celery_d -l info -c 3;\"; exec bash"' \
               --tab-with-profile="HOLD" --title="mysql.local" -e 'bash -c "export BASH_POST_RC=\"workon jaws; mysql jaws;\"; exec bash"'




