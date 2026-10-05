from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.operators.python import PythonOperator
from airflow.providers.clickhousedb.hooks.clickhouse import ClickHouseHook
import os

CLICKHOUSE_CONN_ID = "clickhouse_default"
CLICKHOUSE_TABLE = "default.parquet_data"
PARQUET_FILE_PATH = "data.parquet"

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="parquet_to_clickhouse_pipeline",
    default_args=default_args,
    description="Загрузка данных из Parquet в ClickHouse",
    schedule_interval=None,  # одноразовый запуск; для регулярного — cron-выражение
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=["clickhouse", "parquet"],
) as dag:

    # 1. Создание таблицы (при необходимости скорректируйте схему под ваш Parquet)
    create_table = SQLExecuteQueryOperator(
        task_id="create_table",
        conn_id=CLICKHOUSE_CONN_ID,
        sql=f"""
        CREATE TABLE IF NOT EXISTS {CLICKHOUSE_TABLE} (
            id UInt64,
            name String,
            value Float64,
            created_at DateTime
        )
        ENGINE = MergeTree()
        ORDER BY id
        """,
    )

    # 2. Очистка таблицы перед загрузкой (для идемпотентности)
    truncate_table = SQLExecuteQueryOperator(
        task_id="truncate_table",
        conn_id=CLICKHOUSE_CONN_ID,
        sql=f"TRUNCATE TABLE {CLICKHOUSE_TABLE}",
    )

    # 3. Загрузка данных из Parquet через функцию file()
    load_parquet = SQLExecuteQueryOperator(
        task_id="load_parquet",
        conn_id=CLICKHOUSE_CONN_ID,
        sql=f"""
        INSERT INTO {CLICKHOUSE_TABLE}
        SELECT * FROM file('{PARQUET_FILE_PATH}', 'Parquet')
        """,
    )

    # 4. Проверка: подсчёт загруженных строк
    def validate_load(**context):
        hook = ClickHouseHook(clickhouse_conn_id=CLICKHOUSE_CONN_ID)
        result = hook.get_first(f"SELECT count() FROM {CLICKHOUSE_TABLE}")
        count = result[0] if result else 0
        print(f"Загружено строк: {count}")
        if count == 0:
            raise ValueError("Таблица пуста после загрузки!")
        return count

    validate = PythonOperator(
        task_id="validate_load",
        python_callable=validate_load,
    )

    # Определение порядка выполнения
    create_table >> truncate_table >> load_parquet >> validate
