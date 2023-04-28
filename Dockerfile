FROM python:3.11.3-slim-bullseye

ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 \
    # pip:
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    # poetry:
    POETRY_VERSION=2.0 \
    POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    PATH="$PATH:/root/.local/bin"

# install poetry
# RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
RUN pip install pipx
RUN pipx install "poetry"
#RUN pipx install "poetry"
RUN pipx ensurepath

# install dependencies
COPY pyproject.toml poetry.lock /
ADD requirements.txt 
RUN poetry add $( cat requirements.txt )
RUN poetry install --no-dev --no-root --no-interaction --no-ansi

# copy and run program
ADD main.py /main.py
CMD [ "poetry", "run", "python", "/main.py" ]
