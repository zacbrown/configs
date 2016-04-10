firewall {
    all-ping enable
    broadcast-ping disable
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians disable
    name WAN_IN {
        default-action drop
        description "WAN Inbound"
        rule 1 {
            action accept
            description "Accept Related"
            log disable
            protocol all
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 2 {
            action drop
            description "Drop Invalid"
            log disable
            protocol all
            state {
                established disable
                invalid enable
                new disable
                related disable
            }
        }
    }
    name WAN_LOCAL {
        default-action drop
        description "Internet to router"
        rule 1 {
            action accept
            description "Accept Related"
            log disable
            protocol all
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 2 {
            action drop
            description "Drop Invalid"
            log disable
            protocol all
            state {
                established disable
                invalid enable
                new disable
                related disable
            }
        }
    }
    options {
        mss-clamp {
            interface-type pppoe
            mss 1452
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        address 192.168.1.1/24
        description Local
        duplex auto
        speed auto
    }
    ethernet eth1 {
        description "Centurylink WAN"
        duplex auto
        speed auto
        vif 201 {
            description "Centurylink VLAN"
            pppoe 0 {
                default-route auto
                firewall {
                    in {
                        name WAN_IN
                    }
                    local {
                        name WAN_LOCAL
                    }
                }
                mtu 1492
                name-server auto
                password <your PPPoE password>
                user-id <your PPPoE user>@qwest.net
            }
        }
    }
    ethernet eth2 {
        disable
        duplex auto
        speed auto
    }
    loopback lo {
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update disable
        shared-network-name LAN-DHCP {
            authoritative disable
            subnet 192.168.1.0/24 {
                default-router 192.168.1.1
                dns-server 208.67.222.222
                dns-server 208.67.220.220
                lease 86400
                start 192.168.1.2 {
                    stop 192.168.1.255
                }
            }
        }
    }
    gui {
        https-port 443
    }
    nat {
        rule 5000 {
            description PPPoE
            log disable
            outbound-interface pppoe0
            protocol all
            type masquerade
        }
    }
    ssh {
        port 22
        protocol-version v2
    }
    ubnt-discover {
        disable
    }
}
system {
    config-management {
        commit-revisions 20
    }
    conntrack {
        expect-table-size 2048
        hash-size 32768
        table-size 262144
    }
    host-name ubnt
    login {
        user ubnt {
            authentication {
                plaintext-password "password"
            }
            full-name ""
            level admin
        }
    }
    ntp {
        server 0.ubnt.pool.ntp.org {
        }
        server 1.ubnt.pool.ntp.org {
        }
        server 2.ubnt.pool.ntp.org {
        }
        server 3.ubnt.pool.ntp.org {
        }
    }
    offload {
        ipsec enable
        ipv4 {
            forwarding enable
            pppoe enable
            vlan enable
        }
        ipv6 {
            forwarding disable
        }
    }
    time-zone America/Los_Angeles
}


/* Warning: Do not remove the following line. */
/* === vyatta-config-version: "config-management@1:conntrack@1:cron@1:dhcp-relay@1:dhcp-server@4:firewall@5:ipsec@4:nat@3:qos@1:quagga@2:system@4:ubnt-pptp@1:ubnt-util@1:vrrp@1:webgui@1:webproxy@1:zone-policy@1" === */
/* Release version: v1.7.0.4783374.150622.1534 */
