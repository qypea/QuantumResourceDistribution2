function endswith(str,suf) return str:sub(-string.len(suf)) == suf end
function startswith(text, prefix) return text:find(prefix, 1, true) == 1 end
function contains(s, word) return s:find(word, 1, true) ~= nil end

-- b = startswith(s, prefix)
function split(s, delimiter)
  result = {};
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    result[match] = true;
  end
  return result;
end

function splitarray(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- ==================================================================================================

function item_prototype(name)
  return game.item_prototypes[name]
end

function get_localised_name(name)
    local item = game.item_prototypes[name]
    if item then
        return item.localised_name
    end
    local fluid = game.fluid_prototypes[name]
    if fluid then
        return fluid.localised_name
    end
    local recipe = game.recipe_prototypes[name]
    if recipe then
        return recipe.localised_name
    end
    return name
end

-- ==================================================================================================

function sb(data) game.players[1].force.print(serpent.block(data)) end
function print(line) game.players[1].force.print(line) end

-- ==================================================================================================

function create_variables(player)

  if not global.pool then global.pool = {} end
  if not global.chests then global.chests = {} end
  if not global.combinators then global.combinators = {} end
  
  if not global.pool[player.surface.name] then global.pool[player.surface.name] = {} end
  if not global.combinators[player.surface.name] then global.combinators[player.surface.name] = {} end

  
  for k1,v1 in pairs(global.pool) do
    for k2,v2 in pairs(global.pool[k1]) do
      if not item_prototype(k2) then
        global.pool[k1][k2] = nil
      end
    end
  end
  
  if not global.category then global.category = 'main' end
  
  global.whitelist = split(player.mod_settings["QuantumResourceDistribution_whitelist"].value,',')
  global.blacklist = split(player.mod_settings["QuantumResourceDistribution_blacklist"].value,',')
  
  global.allowed = split(player.mod_settings["QuantumResourceDistribution_allowed"].value,',')
  
  global.whitelist_subgroup = split(player.mod_settings["QuantumResourceDistribution_whitelist_subgroup"].value,',')
  global.blacklist_subgroup = split(player.mod_settings["QuantumResourceDistribution_blacklist_subgroup"].value,',')
end

-- ==================================================================================================

function update_mod_button()
  for i,player in pairs(game.players) do
    create_variables(player)
    if player.gui.top["QuantumResourceDistributionButton"] then player.gui.top["QuantumResourceDistributionButton"].destroy() end
    local button = player.gui.top.add{type="sprite-button",sprite="item/QuantumResourceDistributionContainer",name='QuantumResourceDistributionButton'}

    button.style.top_margin = 5
    
    button.style.width = player.mod_settings["QuantumResourceDistribution_icon_size"].value 
    button.style.height = player.mod_settings["QuantumResourceDistribution_icon_size"].value 
  end
end

-- ==================================================================================================

function set_combinator(entity)
  if not global.pool[entity.surface.name] then return end
  local surface_content = global.pool[entity.surface.name]
  local control = entity.get_control_behavior()
  
  local parameters = {}
  local index = 1
  
  for item,data in pairs(surface_content) do
    local signal = {name=item,type='item'}
    local slot = {count=data['amount'],index=index,signal=signal}
    table.insert(parameters, slot)
    index = index + 1
  end
  
  control.parameters = parameters
  -- sb(control.parameters)
end

-- ==================================================================================================

function create_gui(e)
  global.gui_open = false
  for i,player in pairs(game.players) do
    create_variables(player)
    if not player.gui.top["QuantumResourceDistributionFlow"] then
      player.gui.top.add{type="flow", name="QuantumResourceDistributionFlow", direction="horizontal"}
    end
    update_gui(player)
  end
end
      
-- ==================================================================================================
      
function on_player_created(e)
  local player = game.players[e.player_index]
  
  -- player.cheat_mode = true
  -- player.force.research_all_technologies()
  
  player.force.character_logistic_requests = true
  player.force.character_trash_slot_count = 10
  
  if player.character then 
    player.character_personal_logistic_requests_enabled = false
  end
  
  create_variables(player)

  -- global.pool[player.surface.name]['iron-plate'] = {amount=6, category='main'} 
end
      
-- ==================================================================================================

script.on_event({defines.events.on_player_changed_surface}, function(event)
  local player = game.players[event.player_index]
  if global.gui_open then global.gui_open = false end
  if player.gui.top["QuantumResourceDistributionFlow"] then 
    player.gui.top["QuantumResourceDistributionFlow"].destroy() 
  end
  
  create_variables(player)
  update_gui(player)
end)

-- ==================================================================================================

function entity_add(entity) 
  if entity then
    if entity.valid then
      if entity.name == 'QuantumResourceDistributionContainer' then
        table.insert(global.chests,entity)
      end
      
      if entity.name == 'QuantumResourceDistributionCombinator' then
        table.insert(global.combinators[entity.surface.name],entity)
      end      
      
    end
  end
end


function entity_del(entity) 
  if entity then
    local surface_name = entity.surface.name
  
    if entity.name == 'QuantumResourceDistributionContainer' then
      for index,chest in ipairs(global.chests) do
        if entity == chest then
          table.remove(global.chests, index)
          return
        end
      end
    end
    
    if entity.name == 'QuantumResourceDistributionCombinator' then
      for index,combinator in ipairs(global.combinators[surface_name]) do
        if entity == combinator then
          table.remove(global.combinators[surface_name], index)
          return
        end
      end
    end
    
  end
end

-- ==================================================================================================

script.on_event({defines.events.on_built_entity}, function(event) entity_add(event.created_entity) end)
script.on_event({defines.events.on_robot_built_entity}, function(event) entity_add(event.created_entity) end)
script.on_event({defines.events.on_entity_cloned}, function(event) entity_add(event.destination) end)

script.on_event({defines.events.on_entity_died}, function(event) entity_del(event.entity) end)
script.on_event({defines.events.on_player_mined_entity}, function(event) entity_del(event.entity) end)
script.on_event({defines.events.on_robot_mined_entity}, function(event) entity_del(event.entity) end)
