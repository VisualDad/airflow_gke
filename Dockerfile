FROM apache/airflow:2.2.1

ENV \
  AIRFLOW_HOME=/home/airflow

WORKDIR ${AIRFLOW_HOME}

COPY plugins/ plugins/
COPY requirements.txt .

RUN pip3 install -r requirements.txt