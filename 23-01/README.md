## Создание куба
cd ~/IdeaProjects/devops/23-01
./terraform apply -auto-approve

## Ручное получение параметров подключения (в k8s прописано авто получение)
yc managed-kubernetes cluster get-credentials --id <введи номер куба> --external


yc managed-kubernetes cluster get-credentials --name netology-dev-k8s-cluster --external --force

