Я развернул кафку и клик через docker compose,
файл конфигурации будет прикреплен в репозиторий. 
Использовал загрузку данных в кафку из файла
Конкретно использовался датасет GitHub Events:
wget https://datasets-documentation.s3.eu-west-3.amazonaws.com/kafka/github_all_columns.ndjson
Установил kafkacat и залил данные из файла в кафку:
cat github_all_columns.ndjson | kcat -P -b localhost:9092 -t github
Далее сделал селект запрос из MV и увидел что там появились данные
Вроде бы всё, смысл проведенной работы понятен, после выполнения предыдущего ДЗ, попробую еще грузить данные в кафку через airflow