function build-stack {
    docker-compose -p saturn build $@
}

function bootstrap-backend {
    docker-compose run backend django-admin.py startproject saturn \
        && cp -r backend/saturn/* backend \
        && rm backend/saturn/manage.py \
        && rm -rf backend/saturn/saturn \
        && docker-compose run backend ./manage.py startapp api
}

function bootstrap {
    build-stack
    bootstrap-backend
}

function start-stack {
    docker-compose -p saturn up -d
}

function stop-stack {
    docker-compose -p saturn kill
}

function restart-stack {
    stop-stack && start-stack
}

function logs {
    docker-compose -p saturn logs -f $@
}

function db-make-migrations {
    docker exec saturn_backend_1 python manage.py makemigrations api
}

function db-migrate {
    docker exec saturn_backend_1 python manage.py migrate
}

function create-su {
    docker exec -it saturn_backend_1 python manage.py createsuperuser
}

echo -e "

Available commands:

\tbootstrap

\tbuild-stack
\tbootstrap-backend
\tstart-stack
\tstop-stack
\trestar-stack
\tlogs
\tdb-make-migrations
\tdb-migrate
\tcreate-su

"
