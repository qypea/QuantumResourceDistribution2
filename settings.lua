data:extend({
    {
        type = "int-setting",
        name = "QuantumResourceDistribution_tick",
        setting_type = "startup",
        default_value = 60,
        order = "a"
    }
})

data:extend({
    {
        type = "int-setting",
        name = "QuantumResourceDistribution_storage",
        setting_type = "startup",
        default_value = 99999,
        order = "b"
    }
})

data:extend({
    {
        type = "int-setting",
        name = "QuantumResourceDistribution_icon_size",
        setting_type = "runtime-per-user",
        default_value = 50,
        order = "1"
    }
})

data:extend({
    {
        type = "int-setting",
        name = "QuantumResourceDistribution_columns",
        setting_type = "runtime-per-user",
        default_value = 20,
        order = "2"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "QuantumResourceDistribution_logistic_inventory",
        setting_type = "runtime-per-user",
        default_value = true,
        order = "3"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "QuantumResourceDistribution_show_zero_count_items",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "4"
    }
})

data:extend({
    {
        type = "string-setting",
        name = "QuantumResourceDistribution_allowed",
        setting_type = "runtime-per-user",
        default_value = 'intermediate-products,resources,science',
        allow_blank = true,
        auto_trim = true,
        order = "5"
    }
})

data:extend({
    {
        type = "string-setting",
        name = "QuantumResourceDistribution_whitelist",
        setting_type = "runtime-per-user",
        default_value = 'repair-pack,big-electric-pole,se-meteor-defence-ammo',
        allow_blank = true,
        auto_trim = true,
        order = "5"
    }
})

data:extend({
    {
        type = "string-setting",
        name = "QuantumResourceDistribution_blacklist",
        setting_type = "runtime-per-user",
        default_value = 'pump,kr-steel-pump',
        allow_blank = true,
        auto_trim = true,
        order = "6"
    }
})

data:extend({
    {
        type = "string-setting",
        name = "QuantumResourceDistribution_whitelist_subgroup",
        setting_type = "runtime-per-user",
        default_value = 'belt,transport-belt,underground-belt,inserter,splitter,ammo,pipe,terrain,spaceship-structure',
        allow_blank = true,
        auto_trim = true,
        order = "7"
    }
})

data:extend({
    {
        type = "string-setting",
        name = "QuantumResourceDistribution_blacklist_subgroup",
        setting_type = "runtime-per-user",
        default_value = '',
        allow_blank = true,
        auto_trim = true,
        order = "8"
    }
})
