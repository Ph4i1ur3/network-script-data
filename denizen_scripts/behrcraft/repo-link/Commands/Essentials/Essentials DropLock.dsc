droplock_Command:
    type: command
    name: droplock
    debug: false
    description: locks drops unless you click them
    permission: Behr.Essentials.Droplock
    usage: /droplock (on/off)
    tab complete:
        - define Arg1 <list[on|off]>
        - inject OneArg_Command_Tabcomplete
    script:
        - if <context.args.is_empty>:
            - define Arg null
        - else if <context.args.size> > 1:
            - inject Command_Syntax
        - else:
            - define Arg <context.args.first>

        - define ModeFlag Behr.Essentials.DropLock
        - define ModeName "drop lock"
        - inject Activation_Arg

#@Droplock_Handler:
#@    type: world
#@    debug: false
#@    events:
#@        on player quits:
#^            - if <player.has_flag[Behrry.Essentials.Droplock]>:
#^                - flag player Behrry.Bssentials.Droplock:!
#@        on player picks up item:
#%        # @ ██ [  Check if player is in droplock mode ] ██
#^            - if <player.has_flag[Behrry.Essentials.Droplock]>:
#%            # @ ██ [  Check for unique pickup ] ██
#^                - if <player.has_flag[Behrry.Essentials.Pickup]>:
#%                # @ ██ [  If the item is in the unique pickup list, allow pickup ] ██
#^                    - if <player.flag[Behrry.Essentials.Pickup]> == <context.item>:
#^                        - stop
#^                - else:
#^                    - determine cancelled
#@        on player right clicks block:
#%        # @ ██ [  Check if player is in droplock mode ] ██
#^            - if <player.has_flag[Behrry.Essentials.Droplock]>:
#%            # @ ██ [  Search for dropped items 0.5 blocks around the click location ] ██
#^                - define DroppedItems <player.location.precise_cursor_on.find.entities[DROPPED_ITEM].within[0.5].exclude[<player>]>
#^                - flag player Behrry.Essentials.Pickup:->:<[DroppedItems]> duration:1t
