web_epg_set = [
    "web1_epg",
    "web2_epg",
    "web3_epg"
    ]

app_bd_map = {
    "bd_10.0.1.0" = {
        bd_subnet   = "10.0.1.1/24" 
    }
    "bd_10.0.2.0" = {
        bd_subnet   = "10.0.2.1/24"
    }
}

app_epg_map = {
    "app1_epg" = {
        app_bd = "bd_10.0.1.0"
        }
    "app2_epg" = {
        app_bd = "bd_10.0.2.0"
        }
    }