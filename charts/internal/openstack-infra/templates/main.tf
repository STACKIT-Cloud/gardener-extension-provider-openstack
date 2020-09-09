provider "openstack" {
  auth_url    = "{{ required "openstack.authURL is required" .Values.openstack.authURL }}"
  domain_name = "{{ required "openstack.domainName is required" .Values.openstack.domainName }}"
  tenant_name = "{{ required "openstack.tenantName is required" .Values.openstack.tenantName }}"
  region      = "{{ required "openstack.region is required" .Values.openstack.region }}"
  user_name   = var.USER_NAME
  password    = var.PASSWORD
  insecure    = true
}

//=====================================================================
//= Networking: Router/Interfaces/Net/SubNet/SecGroup/SecRules
//=====================================================================

data "openstack_networking_network_v2" "fip" {
  name = "{{ required "openstack.floatingPoolName is required" .Values.openstack.floatingPoolName }}"
}

{{ if .Values.router.floatingPoolSubnetName -}}
data "openstack_networking_subnet_v2" "fip_subnet" {
  name = "{{ .Values.router.floatingPoolSubnetName }}"
}
{{- end }}

{{ if .Values.create.router -}}
resource "openstack_networking_router_v2" "router" {
  name                = "{{ required "clusterName is required" .Values.clusterName }}"
  region              = "{{ required "openstack.region is required" .Values.openstack.region }}"
  external_network_id = data.openstack_networking_network_v2.fip.id
  {{ if .Values.router.floatingPoolSubnetName -}}
  external_fixed_ip {
    subnet_id = data.openstack_networking_subnet_v2.fip_subnet.id
  }
  {{- end }}
}
{{- end}}

{{ if .Values.networks.dualHomed }}
# IPv6 Network in dual homed mode
resource "openstack_networking_network_v2" "cluster-v6" {
  name           = "{{ required "clusterName is required" .Values.clusterName }}"
  admin_state_up = "true"
}
{{- end}}

resource "openstack_networking_network_v2" "cluster" {
  name           = "{{ required "clusterName is required" .Values.clusterName }}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "cluster-v4" {
  name            = "{{ required "clusterName is required" .Values.clusterName }}-v4"

  cidr            = "{{ required "networks.workers is required" ((split "," .Values.networks.workers)._0) }}"

  network_id      = openstack_networking_network_v2.cluster.id
  ip_version      = 4

  {{- if .Values.dnsServers }}
  dns_nameservers = [{{- include "openstack-infra.dnsServers" . | trimSuffix ", " }}]
  {{- else }}
  dns_nameservers = []
  {{- end }}
}

{{ if gt (len (split "," .Values.networks.workers)) 1 }}
resource "openstack_networking_subnet_v2" "cluster-v6" {
  name            = "{{ required "clusterName is required" .Values.clusterName }}-v6"
  cidr            = "{{ required "networks.workers is required" (split "," .Values.networks.workers)._1 }}"
  {{ if .Values.networks.dualHomed }}
  network_id      = "${openstack_networking_network_v2.cluster-v6.id}"
  {{- else }}
  network_id      = "${openstack_networking_network_v2.cluster.id}"
  {{- end }}

  ip_version      = 6
  ipv6_ra_mode      = "dhcpv6-stateful"
  ipv6_address_mode = "dhcpv6-stateful"

  dns_nameservers = []
}
{{- end}}

resource "openstack_networking_router_interface_v2" "router_nodes_v4" {
  router_id = "{{ required "router.id is required" $.Values.router.id }}"
  subnet_id = "${openstack_networking_subnet_v2.cluster-v4.id}"
}

resource "openstack_networking_router_interface_v2" "router_nodes_v6" {
  router_id = "{{ required "router.id is required" $.Values.router.id }}"
  subnet_id = "${openstack_networking_subnet_v2.cluster-v6.id}"
}

resource "openstack_networking_secgroup_v2" "cluster" {
  name                 = "{{ required "clusterName is required" .Values.clusterName }}"
  description          = "Cluster Nodes"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "cluster_self_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.cluster.id
  remote_group_id   = openstack_networking_secgroup_v2.cluster.id
}

resource "openstack_networking_secgroup_rule_v2" "cluster_self_v6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  security_group_id = "${openstack_networking_secgroup_v2.cluster.id}"
  remote_group_id   = "${openstack_networking_secgroup_v2.cluster.id}"
}

resource "openstack_networking_secgroup_rule_v2" "cluster_egress_v4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.cluster.id
}

resource "openstack_networking_secgroup_rule_v2" "cluster_egress_v6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = "${openstack_networking_secgroup_v2.cluster.id}"
}

resource "openstack_networking_secgroup_rule_v2" "cluster_tcp_all_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.cluster.id
}

resource "openstack_networking_secgroup_rule_v2" "cluster_tcp_all_v6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "::/0"
  security_group_id = "${openstack_networking_secgroup_v2.cluster.id}"
}


//=====================================================================
//= SSH Key for Nodes (Bastion and Worker)
//=====================================================================

resource "openstack_compute_keypair_v2" "ssh_key" {
  name       = "{{ required "clusterName is required" .Values.clusterName }}"
  public_key = "{{ required "sshPublicKey is required" .Values.sshPublicKey }}"
}

// We have introduced new output variables. However, they are not applied for
// existing clusters as Terraform won't detect a diff when we run `terraform plan`.
// Workaround: Providing a null-resource for letting Terraform think that there are
// differences, enabling the Gardener to start an actual `terraform apply` job.
resource "null_resource" "outputs" {
  triggers = {
    recompute = "outputs"
  }
}

//=====================================================================
//= Output Variables
//=====================================================================

output "{{ .Values.outputKeys.routerID }}" {
  value = {{ required "router.id is required" .Values.router.id }}
}

output "{{ .Values.outputKeys.networkID }}" {
  value = openstack_networking_network_v2.cluster.id
}

output "{{ .Values.outputKeys.networkIDv6 }}" {
  {{ if .Values.networks.dualHomed }}
  value = "${openstack_networking_network_v2.cluster-v6.id}"
  {{- else }}
  value = "${openstack_networking_network_v2.cluster.id}"
  {{- end }}
}

output "{{ .Values.outputKeys.keyName }}" {
  value = openstack_compute_keypair_v2.ssh_key.name
}

output "{{ .Values.outputKeys.securityGroupID }}" {
  value = openstack_networking_secgroup_v2.cluster.id
}

output "{{ .Values.outputKeys.securityGroupName }}" {
  value = openstack_networking_secgroup_v2.cluster.name
}

output "{{ .Values.outputKeys.floatingNetworkID }}" {
  value = data.openstack_networking_network_v2.fip.id
}

{{ if .Values.router.floatingPoolSubnetName -}}
output "{{ .Values.outputKeys.floatingSubnetID }}" {
  value = data.openstack_networking_subnet_v2.fip_subnet.id
}
{{- end }}

output "{{ .Values.outputKeys.subnetID }}" {
  {{ if .Values.networks.dualHomed }}
  value = openstack_networking_subnet_v2.cluster-v4.id
  {{- else }}
  value = openstack_networking_subnet_v2.cluster-v6.id
  {{- end }}
}
