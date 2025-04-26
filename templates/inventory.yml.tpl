all:
  hosts:
%{ for i, ip in master_private_ips ~}
    master${i+1}:
      ansible_host: ${ip}
      ip: ${ip}
      access_ip: ${ip}
%{ endfor ~}
%{ for i, ip in node_private_ips ~}
    node${i+1}:
      ansible_host: ${ip}
      ip: ${ip}
      access_ip: ${ip}
%{ endfor ~}
  vars:
    supplementary_addresses_in_ssl_keys:
%{ for ip in master_public_ips ~}
      - "${ip}"
%{ endfor ~}
    kube_apiserver_node_port_range: 20000-25000  # Диапазон вне резерва Yandex Cloud

kube_control_plane:
  hosts:
%{ for i, ip in master_private_ips ~}
    master${i+1}: {}
%{ endfor ~}

kube_node:
  hosts:
%{ for i, ip in node_private_ips ~}
    node${i+1}: {}
%{ endfor ~}

etcd:
  hosts:
    master1: {}

k8s_cluster:
  children:
    kube_control_plane: {}
    kube_node: {}

calico_rr:
  hosts: {}

no_floating:
  hosts: {}

bastion:
  hosts: {}