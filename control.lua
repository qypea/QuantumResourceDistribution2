require("functions")


function can_be_put_in_storage(prototype)
  if not prototype then return false end
  local flag = false
    
  -- if prototype.group.name == 'intermediate-products' then flag = true end
  -- if prototype.group.name == 'resources' then flag = true end
  -- if prototype.group.name == 'science' then flag = true end
  
  -- sb(global.blacklist_subgroup)
  -- sb(global.whitelist_subgroup)
  -- sb(prototype.subgroup)
  
  if global.allowed[prototype.group.name] then flag = true end 
  
  if global.blacklist_subgroup[prototype.subgroup.name] then flag = false end 
  if global.whitelist_subgroup[prototype.subgroup.name] then flag = true end   
  
  if global.blacklist[prototype.name] then flag = false end 
  if global.whitelist[prototype.name] then flag = true end 
  
  return flag
end


function update_gui(player)
  if global.button_size ~= player.mod_settings["QuantumResourceDistribution_icon_size"].value then 
    update_mod_button() 
  end

  global.button_size = player.mod_settings["QuantumResourceDistribution_icon_size"].value

  create_variables(player)

  for surface_name,surface_content in pairs(global.pool) do
    if surface_name == player.surface.name then
      if not player.gui.top["QuantumResourceDistributionButton"] then 
        local button = player.gui.top.add{type="sprite-button",sprite="item/logistic-chest-buffer",name='QuantumResourceDistributionButton'}
        button.style.top_margin = 5
        button.style.width = player.mod_settings["QuantumResourceDistribution_icon_size"].value 
        button.style.height = player.mod_settings["QuantumResourceDistribution_icon_size"].value
      end
      
      if player.gui.top["QuantumResourceDistributionFlow"] then 
        player.gui.top["QuantumResourceDistributionFlow"].destroy() 
      end
      
      if not global.gui_open then return end
      
      flow = player.gui.top.add{type = 'table', name = 'QuantumResourceDistributionFlow', column_count = player.mod_settings["QuantumResourceDistribution_columns"].value}
      
      local minimal_amount_to_show = 1
      if player.mod_settings["QuantumResourceDistribution_show_zero_count_items"].value then
        minimal_amount_to_show = 0
      end
      
      -- sb(surface_content)
      
      for item,data in pairs(surface_content) do
        local prototype = item_prototype(item)
        -- local skip = true
        
        -- if data['amount'] >= minimal_amount_to_show then
          -- sb(item.." "..prototype.group.name.." "..prototype.subgroup.name)
        -- end
        
        -- if prototype then
          -- if then 
            -- skip = false
          -- end
        -- end
        
        if prototype then
          if data['amount'] >= minimal_amount_to_show and data['category'] == global.category then
            local cell = flow.add({type = 'flow', direction = "vertical"})
            local button = cell.add{type="sprite-button",sprite="item/"..item,name=item,tooltip=get_localised_name(item)} 
            button.style.top_margin = 5
            button.name = 'QuantumResourceDistributionItem#'..item
            button.style.width = player.mod_settings["QuantumResourceDistribution_icon_size"].value 
            button.style.height = player.mod_settings["QuantumResourceDistribution_icon_size"].value 
            
            local frame = cell.add{type="frame"} 
            frame.style.width = player.mod_settings["QuantumResourceDistribution_icon_size"].value  
            frame.style.height = 30       
            frame.style.horizontal_align = 'center'      
            frame.style.padding = 0 
      
            local count = frame.add{type="label", caption=data['amount']} 
            count.style.horizontal_align = 'center'
          end
        end
      end
    end
  end
end
      
      
-- ==================================================================================================


function take(surface,inv,item,amount)
  if not can_be_put_in_storage(item_prototype(item)) then return end 
  if not global.pool[surface.name] then global.pool[surface.name] = {} end
  if not global.pool[surface.name][item] then 
    global.pool[surface.name][item] = {amount=0, category='main'} 
  end
  
  local max_capacity = settings.startup["QuantumResourceDistribution_storage"].value
  local itemdata = global.pool[surface.name][item]

  if itemdata['amount'] + amount > max_capacity then 
    amount = max_capacity - itemdata['amount']
  end
  
  if amount <= 0 then return end
  global.pool[surface.name][item]['amount'] = global.pool[surface.name][item]['amount'] + amount
  inv.remove({name=item, count=amount})
end
      
      
-- ==================================================================================================


function put(surface,inv,item,amount)
  if not global.pool[surface.name] then global.pool[surface.name] = {} end
  if not global.pool[surface.name][item] then 
    global.pool[surface.name][item] = {amount=0, category='main'} 
  end  
  
  if inv.get_insertable_count(item) < amount then return end
  
  local content = inv.get_contents()
  local needed = amount
  
  if content[item] then needed = needed - content[item] end
  if needed <= 0 then return end 
  if global.pool[surface.name][item]['amount'] < needed then return end
  
  global.pool[surface.name][item]['amount'] = global.pool[surface.name][item]['amount'] - needed
  inv.insert({name=item, count=needed})
end
      
      
-- ==================================================================================================
-- player.force.print(entity_id)

function on_tick_chests(endpoints)
  for index,entity in ipairs(endpoints) do 
    if entity ~= nil then
      if entity.valid then
        local inv = entity.get_inventory(defines.inventory.chest)
        if inv then
          local requested_items = {}
          if entity.request_slot_count > 0 then 
            for i = 1,entity.request_slot_count do
              local slot = entity.get_request_slot(i)
              if slot then          
                put(entity.surface,inv,slot['name'],slot['count'])
                requested_items[slot['name']] = true
              end
            end
          end
              
          for item,amount in pairs(inv.get_contents()) do
            if requested_items[item] == nil then
              take(entity.surface,inv,item,amount)
            end
          end
          
        end
      end
    end
  end
end

-- ==================================================================================================

function on_tick_logistic_inventory(player)
  if not player then return end
  if not player.character then return end 
  local inv = player.get_main_inventory()
  if not inv then return end
  local items = inv.get_contents()
  
  for i=1,100 do
    -- print()
    local slot = player.get_personal_logistic_slot(i)
    if slot['name'] then
      local item = slot['name']
      -- print(item.." - "..tostring(slot['min']).." : "..tostring(slot['max']))
      if items[item] then
        if items[item] > slot['max'] then
          local excess = items[item] - slot['max']
          take(player.surface,inv,item,excess)
        end
        
        if items[item] < slot['min'] then
          put(player.surface,inv,item,slot['min'])
        end    
        
      else
        put(player.surface,inv,item,slot['min'])
        
      end    
    end
  end
end

-- ==================================================================================================

function on_tick(event)  
  for surface_name,_ in pairs(global.endpoints) do
    endpoint = table.remove(global.endpoints[surface_name],1)
    if endpoint ~= nil then
      if endpoint.valid then
        table.insert(global.endpoints[surface_name],endpoint)
      end
    end
    -- print(surface_name .. " endpoints "..tostring(#global.endpoints[surface_name]))
    on_tick_chests(global.endpoints[surface_name])
  end

  for surface_name,_ in pairs(global.combinators) do
    for _,combinator in pairs(global.combinators[surface_name]) do
      if combinator ~= nil then
        if combinator.valid then
          set_combinator(combinator)
        end
      end
    end
  end

  for _,player in pairs(game.players) do    
    -- sb(player.get_personal_logistic_slot(2))
    -- sb(player.get_main_inventory().get_contents())
    -- player.force.character_inventory_slots_bonus = 100
    
    if player.mod_settings["QuantumResourceDistribution_logistic_inventory"].value then
      on_tick_logistic_inventory(player)
    end
   
    update_gui(player)
  end  
end

-- ==================================================================================================

script.on_nth_tick(settings.startup["QuantumResourceDistribution_tick"].value, on_tick)      
script.on_configuration_changed(update_mod_button)
script.on_event(defines.events.on_player_created, on_player_created)
script.on_event(defines.events.on_player_joined_game, on_player_created)

-- ==================================================================================================

script.on_event({defines.events.on_gui_click}, function(event)
  local player = game.players[event.player_index]
  
  if event.element.name == "QuantumResourceDistributionButton" then
    if global.gui_open then 
      if defines.mouse_button_type.left == event.button and global.category == 'main' then
        global.gui_open = false 
      elseif defines.mouse_button_type.left == event.button and global.category == 'sub' then
        global.category = 'main' 
      elseif defines.mouse_button_type.right == event.button and global.category == 'sub' then
        global.gui_open = false 
      elseif defines.mouse_button_type.right == event.button and global.category == 'main' then
        global.category = 'sub'     
      else
        global.gui_open = false 
      end
    else 
      if defines.mouse_button_type.left == event.button then global.category = 'main' end
      if defines.mouse_button_type.right == event.button then global.category = 'sub' end
      global.gui_open = true 
    end
    update_gui(player)
  end
  
  -- splitarray
  -- QuantumResourceDistributionItem
  
  if event.element.valid then 
    if event.element.name then
      local name = event.element.name
      if(startswith(name, 'QuantumResourceDistributionItem')) and global.gui_open then
        local s = splitarray(name,'#')
        if #s ~= 2 then return end
        
        if global.pool[player.surface.name][s[2]]['category'] == 'main' then
          global.pool[player.surface.name][s[2]]['category']='sub'
        else
          global.pool[player.surface.name][s[2]]['category']='main'
        end
          
        update_gui(player)
      end
    end
  end
  
  
	-- if defines.mouse_button_type.left==event.button then
		-- if event.shift then
      -- print("shift + left mouse button")
		-- elseif event.control then
      -- print("control + left mouse button")
		-- elseif event.alt then
      -- print("alt + left mouse button")
		-- else
      -- print("left mouse button")
		-- end
	-- end
	
	-- if defines.mouse_button_type.right==event.button then
		-- if event.shift then
      -- print("shift + right mouse button")
		-- elseif event.control then
      -- print("control + right mouse button")
		-- elseif event.alt then
      -- print("alt + right mouse button")
		-- else
      -- print("right mouse button")
		-- end
  -- end
  
  
  -- if event.element.valid then 
    -- if event.element.name then
      -- local name = event.element.name
      -- if(startswith(name, 'QuantumResourceDistributionFull')) and global.gui_open then
        -- local s = split(name,'#')
        -- if #s ~= 2 then return end
        -- if not event.shift then global.compact_display[s[2]] = true end
        -- if event.shift then global.restricted[s[2]] = true end
        -- update_gui(player)
      -- end
      
      
      -- if(startswith(name, 'QuantumResourceDistributionCompact')) and global.gui_open then
        -- local s = split(name,'#')
        -- if #s ~= 2 then return end
        -- if not event.shift then global.compact_display[s[2]] = false end
        -- if event.shift then global.restricted[s[2]] = true end
        -- update_gui(player)
      -- end  
      
      
      -- if(startswith(name, 'QuantumResourceDistributionRestrictedRemove')) and global.gui_open then
        -- local s = split(name,'#')
        -- if #s ~= 2 then return end
        -- global.restricted[s[2]] = false
        -- update_gui(player)
      -- end        
    -- end
  -- end
  
end)
