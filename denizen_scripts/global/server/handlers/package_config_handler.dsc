###################################################################
##            PACKAGE CONTROL SYSTEM - CONFIG LOADER             ##
###################################################################
## Example:
##
## package_data_RTP:
## type: data
## package_name: RTP
## server_configs:
##   yaml_id: path/to/file.yml
##   rtp_data: rtp/rtp_config.yml
###################################################################
## NOTE: path/to/file starts in %Denizen%/data/global/default_configs/
###################################################################

package_controller_load_configs:
  type: world
  debug: false
  load_configs:
    - flag server loaded_configs:!
    - define configs:!|:<server.scripts.filter[name.starts_with[package_data_]].parse_tag[data_key[server_configs]].merge_maps>
    - foreach <[configs]> as:name key:config:
      - if !<server.has_file[data/global/default_configs/<[config]>]>:
        - DEBUG ERROR "Config specified, but unable to find default<&co> <[config]>"
        - foreach next
      - if <yaml.list.contains[name]>:
        - DEBUG ERROR "Config name is already loaded - likely duplicate: <[name]>"
        - foreach next
      - if !<server.has_file[data/server_configs/<[config]>]>:
        - yaml id:<[name]> load:data/global/default_configs/<[config]>
        - yaml id:<[name]> savefile:data/server_configs/<[config]>
      - else:
        - yaml id:<[name]> load:data/server_configs/<[config]>
      - flag server loaded_configs:->:<[name]>
  unload_configs:
    - foreach <server.flag[loaded_configs]||<list[]>>:
      - yaml id:<[value]> unload
  events:
    on server start:
      - inject locally load_configs
    on script reload:
      - inject locally unload_configs
      - inject locally load_configs