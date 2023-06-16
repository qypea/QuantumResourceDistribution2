require("__base__.prototypes.entity.combinator-pictures")
require ("util")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local remnants =
{
  {
    type = "corpse",
    se_allow_in_space = true,
    name = "qrd-combinator-remnants",
    icon = "__QuantumResourceDistribution2__/graphics/qrdc-combinator-ico.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-neutral", "not-on-map"},
    subgroup = "circuit-network-remnants",
    order = "a-d-a",
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    tile_width = 1,
    tile_height = 1,
    selectable_in_game = false,
    time_before_removed = 60 * 60 * 15, -- 15 minutes
    final_render_layer = "remnants",
    remove_on_tile_placement = false,
    animation = make_rotated_animation_variations_from_sheet (1,
    {
      filename = "__QuantumResourceDistribution2__/graphics/constant-combinator-remnants.png",
      line_length = 1,
      width = 60,
      height = 56,
      frame_count = 1,
      variation_count = 1,
      axially_symmetrical = false,
      direction_count = 4,
      shift = util.by_pixel(0, 0),
      hr_version =
      {
        filename = "__QuantumResourceDistribution2__/graphics/hr-constant-combinator-remnants.png",
        line_length = 1,
        width = 118,
        height = 112,
        frame_count = 1,
        variation_count = 1,
        axially_symmetrical = false,
        direction_count = 4,
        shift = util.by_pixel(0, 0),
        scale = 0.5
      }
    })
  },
  
  {
    type = "corpse",
    se_allow_in_space = true,
    name = "qrd-chest-remnants",
    localised_name = {"remnant-name", {"entity-name.QuantumResourceDistributionContainer"}},
    icon = "__QuantumResourceDistribution2__/graphics/qrdc-ico.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-neutral", "building-direction-8-way", "not-on-map"},
    subgroup = "logistic-network-remnants",
    order = "a-f-a",
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    tile_width = 1,
    tile_height = 1,
    selectable_in_game = false,
    time_before_removed = 60 * 60 * 15, -- 15 minutes
    final_render_layer = "remnants",
    remove_on_tile_placement = false,
    animation =
    {
      filename = "__QuantumResourceDistribution2__/graphics/qrdc-remnants.png",
      line_length = 1,
      width = 60,
      height = 42,
      frame_count = 1,
      direction_count = 1,
      shift = util.by_pixel(10.5, -2.5),
      hr_version =
      {
        filename = "__QuantumResourceDistribution2__/graphics/hr-qrdc-remnants.png",
        line_length = 1,
        width = 116,
        height = 82,
        frame_count = 1,
        direction_count = 1,
        shift = util.by_pixel(10, -3),
        scale = 0.5
      }
    }
  }
  
}

for k, remnant in pairs (remnants) do
  if not remnant.localised_name then
    local name = remnant.name
    if name:find("%-remnants") then
      remnant.localised_name = {"remnant-name", {"entity-name."..name:gsub("%-remnants", "")}}
    end
  end
end

data:extend(remnants)



function GenerateQuantumResourceDistributionCombinator(combinator)
  combinator.sprites =
    make_4way_animation_from_spritesheet({ layers =
      {
        {
          filename = "__QuantumResourceDistribution2__/graphics/qrdc-combinator.png",
          width = 58,
          height = 52,
          frame_count = 1,
          shift = util.by_pixel(0, 5),
          hr_version =
          {
            scale = 0.5,
            filename = "__QuantumResourceDistribution2__/graphics/hr-qrdc-combinator.png",
            width = 114,
            height = 102,
            frame_count = 1,
            shift = util.by_pixel(0, 5)
          }
        },
        {
          filename = "__base__/graphics/entity/combinator/constant-combinator-shadow.png",
          width = 50,
          height = 34,
          frame_count = 1,
          shift = util.by_pixel(9, 6),
          draw_as_shadow = true,
          hr_version =
          {
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/hr-constant-combinator-shadow.png",
            width = 98,
            height = 66,
            frame_count = 1,
            shift = util.by_pixel(8.5, 5.5),
            draw_as_shadow = true
          }
        }
      }
    })
  combinator.activity_led_sprites =
  {
    north = util.draw_as_glow
    {
      filename = "__base__/graphics/entity/combinator/activity-leds/constant-combinator-LED-N.png",
      width = 8,
      height = 6,
      frame_count = 1,
      shift = util.by_pixel(9, -12),
      hr_version =
      {
        scale = 0.5,
        filename = "__base__/graphics/entity/combinator/activity-leds/hr-constant-combinator-LED-N.png",
        width = 14,
        height = 12,
        frame_count = 1,
        shift = util.by_pixel(9, -11.5)
      }
    },
    east = util.draw_as_glow
    {
      filename = "__base__/graphics/entity/combinator/activity-leds/constant-combinator-LED-E.png",
      width = 8,
      height = 8,
      frame_count = 1,
      shift = util.by_pixel(8, 0),
      hr_version =
      {
        scale = 0.5,
        filename = "__base__/graphics/entity/combinator/activity-leds/hr-constant-combinator-LED-E.png",
        width = 14,
        height = 14,
        frame_count = 1,
        shift = util.by_pixel(7.5, -0.5)
      }
    },
    south = util.draw_as_glow
    {
      filename = "__base__/graphics/entity/combinator/activity-leds/constant-combinator-LED-S.png",
      width = 8,
      height = 8,
      frame_count = 1,
      shift = util.by_pixel(-9, 2),
      hr_version =
      {
        scale = 0.5,
        filename = "__base__/graphics/entity/combinator/activity-leds/hr-constant-combinator-LED-S.png",
        width = 14,
        height = 16,
        frame_count = 1,
        shift = util.by_pixel(-9, 2.5)
      }
    },
    west = util.draw_as_glow
    {
      filename = "__base__/graphics/entity/combinator/activity-leds/constant-combinator-LED-W.png",
      width = 8,
      height = 8,
      frame_count = 1,
      shift = util.by_pixel(-7, -15),
      hr_version =
      {
        scale = 0.5,
        filename = "__base__/graphics/entity/combinator/activity-leds/hr-constant-combinator-LED-W.png",
        width = 14,
        height = 16,
        frame_count = 1,
        shift = util.by_pixel(-7, -15)
      }
    }
  }
  combinator.circuit_wire_connection_points =
  {
    {
      shadow =
      {
        red = util.by_pixel(7, -6),
        green = util.by_pixel(23, -6)
      },
      wire =
      {
        red = util.by_pixel(-8.5, -17.5),
        green = util.by_pixel(7, -17.5)
      }
    },
    {
      shadow =
      {
        red = util.by_pixel(32, -5),
        green = util.by_pixel(32, 8)
      },
      wire =
      {
        red = util.by_pixel(16, -16.5),
        green = util.by_pixel(16, -3.5)
      }
    },
    {
      shadow =
      {
        red = util.by_pixel(25, 20),
        green = util.by_pixel(9, 20)
      },
      wire =
      {
        red = util.by_pixel(9, 7.5),
        green = util.by_pixel(-6.5, 7.5)
      }
    },
    {
      shadow =
      {
        red = util.by_pixel(1, 11),
        green = util.by_pixel(1, -2)
      },
      wire =
      {
        red = util.by_pixel(-15, -0.5),
        green = util.by_pixel(-15, -13.5)
      }
    }
  }
  return combinator
end


data:extend
{
  GenerateQuantumResourceDistributionCombinator
  {
    type = "constant-combinator",
    se_allow_in_space = true,
    name = "QuantumResourceDistributionCombinator",
    icon = "__QuantumResourceDistribution2__/graphics/qrdc-combinator-ico.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.1, result = "QuantumResourceDistributionCombinator"},
    max_health = 120,
    corpse = "qrd-combinator-remnants",
    dying_explosion = "constant-combinator-explosion",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    damaged_trigger_effect = hit_effects.entity(),
    fast_replaceable_group = "QuantumResourceDistributionCombinator",

    item_slot_count = 10000,

    vehicle_impact_sound = sounds.generic_impact,
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,

    activity_led_light =
    {
      intensity = 0,
      size = 1,
      color = {r = 1.0, g = 1.0, b = 1.0}
    },

    activity_led_light_offsets =
    {
      {0.296875, -0.40625},
      {0.25, -0.03125},
      {-0.296875, -0.078125},
      {-0.21875, -0.46875}
    },

    circuit_wire_max_distance = 100
  }
}

data:extend
{
  {
    type = "logistic-container",
    se_allow_in_space = true,
    name = "QuantumResourceDistributionContainer",
    icon = "__QuantumResourceDistribution2__/graphics/qrdc-ico.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-player", "player-creation"},
    minable = {mining_time = 0.1, result = "QuantumResourceDistributionContainer"},
    max_health = 350,
    corpse = "qrd-chest-remnants",
    dying_explosion = "buffer-chest-explosion",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    damaged_trigger_effect = hit_effects.entity(),
    resistances =
    {
      {
        type = "fire",
        percent = 90
      },
      {
        type = "impact",
        percent = 60
      }
    },
    fast_replaceable_group = "container",
    inventory_size = 48,
    logistic_mode = "buffer",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.43 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.43 },
    animation_sound = sounds.logistics_chest_open,
    vehicle_impact_sound = sounds.generic_impact,
    opened_duration = logistic_chest_opened_duration,
    animation =
    {
      layers =
      {
        {
          filename = "__QuantumResourceDistribution2__/graphics/qrdc.png",
          priority = "extra-high",
          width = 34,
          height = 38,
          frame_count = 7,
          shift = util.by_pixel(0, -2),
          hr_version =
          {
            filename = "__QuantumResourceDistribution2__/graphics/hr-qrdc.png",
            priority = "extra-high",
            width = 66,
            height = 72,
            frame_count = 7,
            shift = util.by_pixel(0, -2),
            scale = 0.5
          }
        },
        {
          filename = "__base__/graphics/entity/logistic-chest/logistic-chest-shadow.png",
          priority = "extra-high",
          width = 56,
          height = 24,
          repeat_count = 7,
          shift = util.by_pixel(12, 5),
          draw_as_shadow = true,
          hr_version =
          {
            filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-shadow.png",
            priority = "extra-high",
            width = 112,
            height = 46,
            repeat_count = 7,
            shift = util.by_pixel(12, 4.5),
            draw_as_shadow = true,
            scale = 0.5
          }
        }
      }
    },
    circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
    circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance
  }
}



data:extend
{
  {
    type = "item",
    se_allow_in_space = true,
    name = "QuantumResourceDistributionCombinator",
    icon = "__QuantumResourceDistribution2__/graphics/qrdc-combinator-ico.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "circuit-network",
    place_result="QuantumResourceDistributionCombinator",
    order = "c[combinators]-c[constant-combinator]",
    stack_size= 50
  }
}



data:extend
{
  {
    type = "item",
    se_allow_in_space = true,
    name = "QuantumResourceDistributionContainer",
    icon = "__QuantumResourceDistribution2__/graphics/qrdc-ico.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "circuit-network",
    order = "c[combinators]-d[logistic-chest-buffer]",
    place_result = "QuantumResourceDistributionContainer",
    stack_size = 50
  }
}


data:extend
{
  {
    type = "recipe",
    name = "QuantumResourceDistributionCombinator",
    enabled = true,
    ingredients =
    {
      {"copper-cable", 5},
      {"iron-plate", 6},
      {"electronic-circuit", 1}
    },
    result = "QuantumResourceDistributionCombinator"
  }
}


data:extend
{
  {
    type = "recipe",
    name = "QuantumResourceDistributionContainer",
    enabled = true,
    ingredients =
    {
      {"iron-plate", 6}
    },
    result = "QuantumResourceDistributionContainer"
  }
}