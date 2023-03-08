###
## Variables.tf for Terraform
## Defines variables and local values
###

variable "vpc_cidr" { default = "10.0.0.0/16" }

# Oracle-Linux-7.6-2019.05.28-0
# https://docs.cloud.oracle.com/iaas/images/image/6180a2cb-be6c-4c78-a69f-38f2714e6b3d/
variable "images" {
  type = map(string)
  default = {
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaaj6pcmnh6y3hdi3ibyxhhflvp3mj2qad4nspojrnxc6pzgn2w3k5q"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaa2wadtmv6j6zboncfobau7fracahvweue6dqipmcd5yj6s54f3wpq"
  }
}


variable bastion_shape { default = "VM.Standard2.2" }
variable bastion_node_count { default = 1 }
variable bastion_hostname_prefix { default = "bastion-" }

variable gluster_server_shape { default = "VM.Standard2.2" }
variable gluster_server_node_count { default = 3 }
variable gluster_server_disk_count { default = 8 }
variable gluster_server_disk_size { default = 4000 }
# Make sure disk_count is a multiplier of num_of_disks_in_brick.  i.e: disk_count/num_of_disks_in_brick = an Integer, eg: disk_count=8,num_of_disks_in_brick=4 (8/4=2).
variable gluster_server_num_of_disks_in_brick { default = 1 }
# Block volume elastic performance tier.  The number of volume performance units (VPUs) that will be applied to this volume per GB, representing the Block Volume service's elastic performance options. See https://docs.cloud.oracle.com/en-us/iaas/Content/Block/Concepts/blockvolumeelasticperformance.htm for more information.  Allowed values are 0, 10, and 20.  Recommended value is 10 for balanced performance and 20 to receive higher performance (IO throughput and IOPS) per GB.
variable gluster_server_disk_vpus_per_gb { default = "20" }
variable gluster_server_hostname_prefix { default = "g-server-" }



# Client nodes variables
variable client_node_shape { default = "VM.Standard2.2" }
variable client_node_count { default = 1 }
variable client_node_hostname_prefix { default = "g-compute-" }




/*
  Gluster FS related variables
*/
# Valid values "5.9" , "3.12" on Oracle Linux Operating System
variable gluster_version { default = "5.9" }
# valid values are Distributed, Dispersed , DistributedDispersed, DistributedReplicated, Replicated
variable gluster_volume_types { default = "DistributedReplicated" }
# replica field used only when VolumeTypes is "Replicated" or "DistributedReplicated". Otherwise assume no replication of data (replica=1 means no replication, only 1 copy of data in filesystem.)
variable gluster_replica { default = 1 }
# Has to be in Kilobytes only. Mention only numerical value, example 256, not 256K
variable gluster_block_size { default = "128" }
variable gluster_mount_point { default = "/glusterfs" }
# To be supported in future
variable gluster_high_availability { default = false }


##################################################
## Variables which should not be changed by user
##################################################

variable "scripts_directory" { default = "scripts" }

variable "gluster_ol_repo_mapping" {
  type = map(string)
  default = {
    "5.9" = "http://yum.oracle.com/repo/OracleLinux/OL7/gluster5/x86_64"
    "3.12" = "http://yum.oracle.com/repo/OracleLinux/OL7/gluster312/x86_64"
  }
}

variable "volume_attach_device_mapping" {
  type = map(string)
  default = {
    "0" = "/dev/oracleoci/oraclevdb"
    "1" = "/dev/oracleoci/oraclevdc"
    "2" = "/dev/oracleoci/oraclevdd"
    "3" = "/dev/oracleoci/oraclevde"
    "4" = "/dev/oracleoci/oraclevdf"
    "5" = "/dev/oracleoci/oraclevdg"
    "6" = "/dev/oracleoci/oraclevdh"
    "7" = "/dev/oracleoci/oraclevdi"
    "8" = "/dev/oracleoci/oraclevdj"
    "9" = "/dev/oracleoci/oraclevdk"
    "10" = "/dev/oracleoci/oraclevdl"
    "11" = "/dev/oracleoci/oraclevdm"
    "12" = "/dev/oracleoci/oraclevdn"
    "13" = "/dev/oracleoci/oraclevdo"
    "14" = "/dev/oracleoci/oraclevdp" 
    "15" = "/dev/oracleoci/oraclevdq"
    "16" = "/dev/oracleoci/oraclevdr"
    "17" = "/dev/oracleoci/oraclevds"
    "18" = "/dev/oracleoci/oraclevdt"
    "19" = "/dev/oracleoci/oraclevdu"
    "20" = "/dev/oracleoci/oraclevdv"
    "21" = "/dev/oracleoci/oraclevdw"
    "22" = "/dev/oracleoci/oraclevdx"
    "23" = "/dev/oracleoci/oraclevdy"
    "24" = "/dev/oracleoci/oraclevdz"
    "25" = "/dev/oracleoci/oraclevdaa"
    "26" = "/dev/oracleoci/oraclevdab"
    "27" = "/dev/oracleoci/oraclevdac"
    "28" = "/dev/oracleoci/oraclevdad"
    "29" = "/dev/oracleoci/oraclevdae"
    "30" = "/dev/oracleoci/oraclevdaf"
    "31" = "/dev/oracleoci/oraclevdag"
  }
}


###############

variable "region" {}
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}


/*
  For instances created using Oracle Linux and CentOS images, the user name opc is created automatically.
  For instances created using the Ubuntu image, the user name ubuntu is created automatically.
  The ubuntu user has sudo privileges and is configured for remote access over the SSH v2 protocol using RSA keys. The SSH public keys that you specify while creating instances are added to the /home/ubuntu/.ssh/authorized_keys file.
  For more details: https://docs.cloud.oracle.com/iaas/Content/Compute/References/images.htm#one
  For Ubuntu images,  set to ubuntu.
  # variable "ssh_user" { default = "ubuntu" }
*/
variable "ssh_user" { default = "opc" }



/*
See https://docs.us-phoenix-1.oraclecloud.com/images/ or https://docs.cloud.oracle.com/iaas/images/
Oracle-provided image "CentOS-7-2019.08.26-0"
https://docs.cloud.oracle.com/iaas/images/image/ea67dd20-b247-4937-bfff-894962212415/
*/
/* imagesCentOS_Latest
variable "imagesCentOS" {
  type = map(string)
  default = {
    ap-mumbai-1 = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaabfqn5vmh3pg6ynpo6bqdbg7fwruu7qgbvondjic5ccr4atlj4j7q"
    ap-seoul-1   = "ocid1.image.oc1.ap-seoul-1.aaaaaaaaxfeztdrbpn452jk2yln7imo4leuhlqicoovoqu7cxqhkr3j2zuqa"
    ap-sydney-1    = "ocid1.image.oc1.ap-sydney-1.aaaaaaaanrubykp6xrff5xzd6gu2g6ul6ttnyoxgaeeq434urjz5j6wfq4fa"
    ap-tokyo-1   = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaakkqtoabcjigninsyalinvppokmgaza6amynam3gs2ldelpgesu6q"
    ca-toronto-1 = "ocid1.image.oc1.ca-toronto-1.aaaaaaaab4hxrwlcs4tniwjr4wvqocmc7bcn3apnaapxabyg62m2ynwrpe2a"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaawejnjwwnzapqukqudpczm4pwtpcsjhohl7qcqa5vzd3gxwmqiq3q"
    eu-zurich-1   = "ocid1.image.oc1.eu-zurich-1.aaaaaaaa7hdfqf54qcnu3bizufapscopzdlxp54yztuxauxyraprxnqjj7ia"
    sa-saopaulo-1 = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa2iqobvkeowx4n2nqsgy32etohkw2srqireqqk3bhn6hv5275my6a"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaakgrjgpq3jej3tyqfwsyk76tl25zoflqfjjuuv43mgisrmhfniofq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa5phjudcfeyomogjp6jjtpcl3ozgrz6s62ltrqsfunejoj7cqxqwq"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaag7vycom7jhxqxfl6rxt5pnf5wqolksl6onuqxderkqrgy4gsi3hq"
  }
}
*/

locals {
  server_dual_nics = (length(regexall("^BM", var.gluster_server_shape)) > 0 ? true : false)
  storage_subnet_domain_name=(local.server_dual_nics ? "${oci_core_subnet.private[0].dns_label}.${oci_core_virtual_network.gluster.dns_label}.oraclevcn.com" : "${oci_core_subnet.private[0].dns_label}.${oci_core_virtual_network.gluster.dns_label}.oraclevcn.com" )
  filesystem_subnet_domain_name=(local.server_dual_nics ? "${oci_core_subnet.privateb[0].dns_label}.${oci_core_virtual_network.gluster.dns_label}.oraclevcn.com" : "${oci_core_subnet.privateb[0].dns_label}.${oci_core_virtual_network.gluster.dns_label}.oraclevcn.com" )
  vcn_domain_name="${oci_core_virtual_network.gluster.dns_label}.oraclevcn.com"
  server_filesystem_vnic_hostname_prefix = "${var.gluster_server_hostname_prefix}fs-vnic-"

  # If ad_number is non-negative use it for AD lookup, else use ad_name.
  # Allows for use of ad_number in TF deploys, and ad_name in ORM.
  # Use of max() prevents out of index lookup call.
  ad = "${var.ad_number >= 0 ? lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[max(0,var.ad_number)],"name") : var.ad_name}"

}



# Not used for normal terraform apply, added for ORM deployments.
variable "ad_name" {
  default = ""
}

# This is currently used for the deployment. Valid values 0,1,2.
variable "ad_number" {
  default = "0"
}

#-------------------------------------------------------------------------------------------------------------
# Marketplace variables
# ------------------------------------------------------------------------------------------------------------
# Oracle Linux 7.7 UEK Image for GlusterFS filesystem

variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaa6fjcgyilbaa3zegmdvwsaztjq6gaijhnognzmipz2l6lhnx3ykza"
}
variable "mp_listing_resource_id" {
  default = "ocid1.image.oc1..aaaaaaaaqgspr7vy2xs2xdyqqvxyrdgizkxnbmq5pqwxr4rmnnbnl6cays2a"
}
variable "mp_listing_resource_version" {
 default = "1.0"
}

variable "use_marketplace_image" {
  default = true
}
