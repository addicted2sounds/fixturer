Сделать загрузчик фикстур

При загрузке приложение считывается конфигурационная папка с фикстурами. Название
файла совпадает с названием модели. Например: post.ini, user.json;
Данные из конфигурационного файла и сохраняются в БД (MySQL)
Формат файлов фикстур:
```
JSON -> [
	 {“field_1”: “value_1”, “field_2”: “value_2”},
	 {“field_1”: “value_3”, “field_2”: “value_4”},
]

INI ->
data[model_alias_1][field_1] = “value_1”
data[model_alias_1][field_2] = “value_2”
data[model_alias_2][field_1] = “value_3”
data[model_alias_2][field_2] = “value_4”
```

#Приложение поддерживает:
1. 2 модели:
1. User (id, name, last_name, age)
2. Post (id, name, text)
2. Поддерживаем 2 типа конфигураций фикстур: INI и JSON

#Требования по архитектуре:

1. Все модели должны работать по ActiveRecord паттерну. Делаем свою реализацию
патерна
1. Свой класс DB -> mysql. Singleton для работы с базой
2. Свой AR от которого наследуемся (getter/setter , save, find ).
2. Паттерн Factory для конфигурационных файлов
