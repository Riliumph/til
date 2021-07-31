# Side Car Container

## ECSには色々な区切りが存在する

- Cluster
- Service
- Container

## コンテナの依存関係

たとえば、Proxy機能とログ機能の２つを持つサービスを考えよう。  
これを実現する方法は複数ある。

- 別クラスター（必然的に別サービス）に配置して通信を行う方法
- 同一クラスターの別サービスで動作し、同じ共有ディレクトリを見る方法
- 同一サービスで動作して、別コンテナとして動作する。

今回は、同一サービスの中の別コンテナとして動作させることとする。  
この場合、ログ機能が十分に起動していない状態でProxy機能が作動するとログを取りこぼす可能性がある。  
つまり、コンテナの起動順序には依存関係があることになる。  

その場合は、依存関係がある方（今回はproxy）に`dependsOn`機能を持たせることで解決できる。

あと、できるなら、ログ収集プロセスが死んでないか定期的にヘルスチェックとして`ps`コマンドを発行すればいいだろう。

## サンプル実装

```json:container_definition.json
[
    {
        "name": "proxy",
        "image": "${container_image}",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${ecs_log_group}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "proxy"
            }
        },
        "dependsOn": [
            {
                "containerName": "fluent-bit",
                "condition": "HEALTHY"
            }
        ],
        "portMappings": [
            {
                "containerPort": 8080,
                "protocol": "tcp",
                "hostPort": 8080
            }
        ],
        "command": [
            "${command}"
        ],
        "environment": [
            {
                "name": "ECS_ENABLE_CONTAINER_METADATA",
                "value": "true"
            },
            {
                "name": "CACHE_ADDRESS",
                "value": "${cache_addr}"
            },
            {
                "name": "CACHE_NAME",
                "value": "redis"
            },
            {
                "name": "DATABASE_DSN",
                "value": "${db_uri}"
            }
        ],
        "ulimits": [
            {
                "name": "nofile",
                "softLimit": 65536,
                "hardLimit": 65536
            }
        ],
        "mountPoints": [
            {
                "containerPath": "/home/var/log/",
                "sourceVolume": "shared_log"
            }
        ],
        "secrets": [
            {
                "valueFrom": "${db_password}",
                "name": "DB_PASSWORD"
            }
        ]
    },
    {
        "name": "fluent-bit",
        "image": "${log_processor_image}",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${ecs_log_group}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "fluent-bit"
            }
        },
        "entryPoint": [
            "/fluent-bit/bin/fluent-bit",
            "-e",
            "/fluent-bit/firehose.so",
            "-c",
            "/fluent-bit/etc/fluent-bit.conf",
            "-o",
            "firehose",
            "-p",
            "region=${region}",
            "-p",
            "delivery_stream=${delivery_stream}"
        ],
        "portMappings": [
            {
                "hostPort": 24224,
                "protocol": "tcp",
                "containerPort": 24224
            },
            {
                "hostPort": 24224,
                "protocol": "udp",
                "containerPort": 24224
            }
        ],
        "ulimits": [
            {
                "name": "nofile",
                "softLimit": 65536,
                "hardLimit": 65536
            }
        ],
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "ps -ef | grep -q [f]luent || exit 1"
            ],
            "interval": 10,
            "timeout": 5,
            "retries": 5,
            "startPeriod": 60
        }
    }
]
```
