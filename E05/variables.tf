variable "web_epg_set" {
    type = set (string)
}

variable "app_bd_map" {
  type = map(object( {
    bd_subnet = string
  }))
}

variable "app_epg_map" {
    type = map (object( {
        app_bd = string
    }
    ))
}