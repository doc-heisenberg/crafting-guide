###
Crafting Guide - sample_modpack.coffee

Copyright (c) 2015 by Redwood Labs
All rights reserved.
###

GraphBuilder = require '../../src/coffee/models/crafting/graph_builder'
ItemSlug     = require '../../src/coffee/models/item_slug'
Mod          = require '../../src/coffee/models/mod'
ModPack      = require '../../src/coffee/models/mod_pack'
ModVersion   = require '../../src/coffee/models/mod_version'

########################################################################################################################

MOD_VERSION_FILE =
    """
    schema: 1

    item: Charcoal
        recipe:
            input: 8 Oak Wood, Coal
            pattern: .0. ... .1.

    item: Crafting Table
        recipe:
            input: Oak Planks
            pattern: .00 .00 ...

    item: Coal

    item: Cobblestone

    item: Furnace
        recipe:
            input: Cobblestone
            pattern: 000 0.0 000
            tools: Crafting Table

    item: Iron Ore

    item: Iron Ingot
        recipe:
            input: 8 Iron Ore, Charcoal
            pattern: .0. ... .1.
            tools: Furnace
        recipe:
            input: 8 Iron Ore, Coal
            pattern: .0. ... .1.
            tools: Furnace

    item: Iron Sword
        recipe:
            input: Iron Ingot, Stick
            pattern: .0. .0. .1.
            tools: Crafting Table

    item: Lever
        recipe:
            input: Stick, Cobblestone
            pattern: .0. .1. ...

    item: Oak Planks
        recipe:
            input: Oak Wood
            pattern: ... .0. ...
            quantity: 4

    item: Oak Wood

    item: Stick
        recipe:
            input: Oak Planks
            pattern: .0. .0. ...
            quantity: 4
    """

########################################################################################################################

module.exports = fixtures =

    makeModPack: ->
        modPack = new ModPack

        mod = new Mod name:'Test', slug:'test'
        modPack.addMod mod

        modVersion = new ModVersion modSlug:'test', version:'0.0'
        modVersion.parse MOD_VERSION_FILE
        mod.addModVersion modVersion

        return modPack

    makeGraphBuilder: ->
        return new GraphBuilder modPack:fixtures.makeModPack()

    makeTree: (itemSlug)->
        builder = fixtures.makeGraphBuilder()
        builder.wanted.add ItemSlug.slugify itemSlug
        builder.expandGraph()

        return builder.rootNode
