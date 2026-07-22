## Описание проекта
Домашнее задание по курсу ClickHouse. 
Практика работы с таблицами, CRUD-операциями, 
sample dataset и операциями ATTACH/DETACH/DROP.

---
## Файл 1: CREATE_table.SQL

- Создана новая база данных `restaurant_db`
- Создана таблица `restaurant_menu` для бизнес-кейса "Меню ресторана"
- Таблица содержит поля:
  - `id` — уникальный идентификатор блюда
  - `name` — название блюда
  - `description` — описание (с модификатором `Nullable`)
  - `category` — категория блюда (с модификатором `LowCardinality`)
  - `price` — цена блюда
  - `currency` — валюта (`LowCardinality`)
  - `is_available` — доступность блюда
  - `created_at` — дата создания записи
  - `updated_at` — дата обновления записи (`Nullable`)
- К полям добавлены комментарии
- Движок таблицы: `MergeTree`

---

## Файл 2: crud.SQL

Протестированы все CRUD-операции:

### INSERT (Create)
- Добавлены 5 блюд: борщ, цезарь, стейк рибай, тирамису, лимонад
- Добавлены ещё 3 блюда: пицца маргарита, греческий салат, капучино

### SELECT (Read)
- Выборка всех записей из таблицы
- Выборка по условию цены (`WHERE price = 400.00`)
- Выборка по диапазону цен (`WHERE price BETWEEN 0 AND 500`)

### UPDATE (Update)
- Обновлена цена блюда с `id = 1` до `400.00` через `ALTER TABLE ... UPDATE`

### DELETE (Delete)
- Удалены блюда с `id IN (3, 5)` через `ALTER TABLE ... DELETE`
- Удалены блюда с ценой в диапазоне `BETWEEN 0 AND 300`
### ALTER TABLE add column 
- Добавлена колонка `callories` типа `Nullable(UInt32)` 
- Добавлена колонка `is_vegan` типа `UInt8` 
  с дефолтным значением `0` и комментарием
  - Значение `0` — блюдо не веганское
  - Значение `1` — блюдо веганское
  - Для существующих записей автоматически проставлено 
    значение по умолчанию `0`

### ALTER TABLE drop column 
- Удалена колонка `currency` 
- Удалена колонка `updated_at` 
 
---

## Файл 3: SAMPLE_DATASET_SELECT.SQL

- Использован датасет **"What's on the Menu?" (NYPL)** Действовал по инструкции из документации CH
- Созданы таблицы: `dish`, `menu`, `menu_page`, `menu_item`
- Выполнена выборка из таблицы `dish`:
  - Отфильтрованы блюда с ценой больше 0
  - Сортировка по убыванию максимальной цены
- Материализована таблица `dish_copy` — создана физическая 
  копия данных из `dish` через `CREATE TABLE ... AS SELECT`

---

## Файл 4: ATACH_DETACH.sql

Выполнены операции над таблицей и базой данных:

### DETACH TABLE
- Таблица `dish_copy` отсоединена командой 
  `DETACH TABLE dish_copy PERMANENTLY`
- Проверено: таблица недоступна для запросов

### ATTACH TABLE
- Таблица `dish_copy` возвращена командой `ATTACH TABLE dish_copy`
- Проверено: данные на месте

### Работа с базой данных
- Создана база данных `restaurant_archive`
- В ней создана таблица-копия `dish_copy`
- Выполнен `DETACH DATABASE restaurant_archive`
- Выполнен `ATTACH DATABASE restaurant_archive`

### Добавление новых данных
- В исходную таблицу `restaurant_menu` добавлены новые блюда: 
  борщ и наполеон

### DROP
- Удалена таблица `dish_copy` командой `DROP TABLE`
- Удалена база данных `restaurant_archive` командой `DROP DATABASE`

---
