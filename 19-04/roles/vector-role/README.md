# Vector Role
Ansible role для установки Vector log aggregator с отправкой логов в ClickHouse.

## Требования
- Ansible 2.9+
- Целевая система: CentOS 7/8, RHEL, AlmaLinux
- В inventory должен быть хост `clickhouse-01`

## Переменные

### defaults/main.yml
| Переменная | Значение | Описание |
|-----------|----------|----------|
| `clickhouse_user` | `netology` | Пользователь ClickHouse |
| `clickhouse_password` | `netology` | Пароль пользователя |
| `vector_version` | `0.21.1` | Версия Vector |

## Пример использования
```yaml
- hosts: vector
  roles:
    - role: vector-role
      vars:
        clickhouse_user: myuser