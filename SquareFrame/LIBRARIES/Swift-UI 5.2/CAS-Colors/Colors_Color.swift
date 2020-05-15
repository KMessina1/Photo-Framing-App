/*--------------------------------------------------------------------------------------------------------------------------
    File: Colors_Color.swift
  Author: Kevin Messina
 Created: Nov 13, 2019
Modified: Feb 3, 2020

©2019-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

@available(iOS 13.0, *) extension Color {
    // Crayons
    static let snow         = Color.Apple.Crayons.snow
    static let mercury      = Color.Apple.Crayons.mercury
    static let silver       = Color.Apple.Crayons.silver
    static let magnesium    = Color.Apple.Crayons.magnesium
    static let aluminum     = Color.Apple.Crayons.aluminum
    static let nickel       = Color.Apple.Crayons.nickel
    static let tin          = Color.Apple.Crayons.tin
    static let steel        = Color.Apple.Crayons.steel
    static let iron         = Color.Apple.Crayons.iron
    static let tungsten     = Color.Apple.Crayons.tungsten
    static let lead         = Color.Apple.Crayons.lead
    static let licorice     = Color.Apple.Crayons.licorice
    static let cayenne      = Color.Apple.Crayons.cayenne
    static let maraschino   = Color.Apple.Crayons.maraschino
    static let salmon       = Color.Apple.Crayons.salmon
    static let maroon       = Color.Apple.Crayons.maroon
    static let strawberry   = Color.Apple.Crayons.strawberry
    static let carnation    = Color.Apple.Crayons.carnation
    static let magenta      = Color.Apple.Crayons.magenta
    static let bubblegum    = Color.Apple.Crayons.bubblegum
    static let eggplant     = Color.Apple.Crayons.eggplant
    static let plum         = Color.Apple.Crayons.plum
    static let grape        = Color.Apple.Crayons.grape
    static let lavender     = Color.Apple.Crayons.lavender
    static let midnight     = Color.Apple.Crayons.midnight
    static let blueberry    = Color.Apple.Crayons.blueberry
    static let orchid       = Color.Apple.Crayons.orchid
    static let ocean        = Color.Apple.Crayons.ocean
    static let aqua         = Color.Apple.Crayons.aqua
    static let sky          = Color.Apple.Crayons.sky
    static let turquoise    = Color.Apple.Crayons.turquoise
    static let ice          = Color.Apple.Crayons.ice
    static let spindrift    = Color.Apple.Crayons.spindrift
    static let moss         = Color.Apple.Crayons.moss
    static let clover       = Color.Apple.Crayons.clover
    static let seafoam      = Color.Apple.Crayons.seafoam
    static let spring       = Color.Apple.Crayons.spring
    static let fern         = Color.Apple.Crayons.fern
    static let flora        = Color.Apple.Crayons.flora
    static let honeydew     = Color.Apple.Crayons.honeydew
    static let asparagus    = Color.Apple.Crayons.asparagus
    static let lemon        = Color.Apple.Crayons.lemon
    static let lime         = Color.Apple.Crayons.lime
    static let banana       = Color.Apple.Crayons.banana
    static let mocha        = Color.Apple.Crayons.mocha
    static let tangerine    = Color.Apple.Crayons.tangerine
    static let canteloupe   = Color.Apple.Crayons.canteloupe
// Apple Colors
    static let blue_Gray        = Color.Apple.blue_Gray
    static let purple_Light     = Color.Apple.purple_Light
    static let green_Dark       = Color.Apple.green_Dark
    static let green_Yellow     = Color.Apple.green_Yellow
    static let yellow_Light     = Color.Apple.yellow_Light
    static let linen            = Color.Apple.linen
    static let orange_Dark      = Color.Apple.orange_Dark
    static let gold             = Color.Apple.gold
    static let rust             = Color.Apple.rust
    static let brown            = Color.Apple.brown
    static let brown_Medium     = Color.Apple.brown_Medium
    static let brown_Dark       = Color.Apple.brown_Dark
    static let red_Light        = Color.Apple.red_Light
    static let red_Bright       = Color.Apple.red_Bright
    static let red_Dark         = Color.Apple.red_Dark

    struct Alert:colorLoopable {
        static let cancel           = UIColor(named: "alerts_cancel")!.toColor
        static let confirm          = UIColor(named: "alerts_confirm")!.toColor
        static let confirm2         = UIColor(named: "alerts_confirm2")!.toColor
        static let construction     = UIColor(named: "alerts_construction")!.toColor
        static let edit             = UIColor(named: "alerts_edit")!.toColor
        static let error            = UIColor(named: "alerts_error")!.toColor
        static let info             = UIColor(named: "alerts_info")!.toColor
        static let IAP              = UIColor(named: "alerts_IAP")!.toColor
        static let notice           = UIColor(named: "alerts_notice")!.toColor
        static let notAvail         = UIColor(named: "alerts_notAvail")!.toColor
        static let success          = UIColor(named: "alerts_success")!.toColor
        static let text             = UIColor(named: "alerts_text")!.toColor
        static let wait             = UIColor(named: "alerts_wait")!.toColor
        static let warning          = UIColor(named: "alerts_warning")!.toColor
    }

    struct Controls:colorLoopable {
        struct Buttons:colorLoopable {
            struct Blues:colorLoopable {
                static let blue         = Color.Apple.Controls.Buttons.Blues.blue
                static let disabled     = Color.Apple.Controls.Buttons.Blues.disabled
            }
            struct Greens:colorLoopable {
                static let green        = Color.Apple.Controls.Buttons.Greens.green
                static let disabled     = Color.Apple.Controls.Buttons.Greens.disabled
            }
        }
        
        struct Glyphs:colorLoopable {
            static let blue         = Color.Apple.Controls.Glyphs.blue
            static let disabled     = Color.Apple.Controls.Glyphs.disabled
        }
        
        struct Switches:colorLoopable {
            static let onGreen      = Color.Apple.Controls.Switches.onGreen
            static let OffRed       = Color.Apple.Controls.Switches.OffRed
        }
        
        struct Keyboards:colorLoopable {
            static let medium       = Color.Apple.Controls.Keyboards.medium
            static let dark         = Color.Apple.Controls.Keyboards.dark
        }
    }
    
// MARK: -
    /// Charts
    struct Charts:colorLoopable {
        static let moss     = UIColor(named: "charts_moss")!.toColor
        static let green    = UIColor(named: "charts_green")!.toColor
        static let yellow   = UIColor(named: "charts_yellow")!.toColor
        static let gold     = UIColor(named: "charts_gold")!.toColor
        static let copper   = UIColor(named: "charts_copper")!.toColor
        static let orange   = UIColor(named: "charts_orange")!.toColor
        static let red      = UIColor(named: "charts_red")!.toColor
        static let purple   = UIColor(named: "charts_purple")!.toColor
        static let indigo   = UIColor(named: "charts_indigo")!.toColor
        static let blue     = UIColor(named: "charts_blue")!.toColor
    }

// MARK: -
    /// Apple Colors
    struct Apple:colorLoopable {
        static let blue_Gray        = UIColor(named: "apple_color_blue_Gray")!.toColor
        static let blue             = UIColor(named: "apple_color_blue")!.toColor
        static let purple_Light     = UIColor(named: "apple_color_purple_Light")!.toColor
        static let purple           = UIColor(named: "apple_color_purple")!.toColor
        static let green            = UIColor(named: "apple_color_green")!.toColor
        static let green_Dark       = UIColor(named: "apple_color_green_Dark")!.toColor
        static let green_Yellow     = UIColor(named: "apple_color_green_Yellow")!.toColor
        static let yellow_Light     = UIColor(named: "apple_color_yellow_Light")!.toColor
        static let yellow           = UIColor(named: "apple_color_yellow")!.toColor
        static let linen            = UIColor(named: "apple_color_linen")!.toColor
        static let orange           = UIColor(named: "apple_color_orange")!.toColor
        static let orange_Dark      = UIColor(named: "apple_color_orange_Dark")!.toColor
        static let gold             = UIColor(named: "apple_color_gold")!.toColor
        static let rust             = UIColor(named: "apple_color_rust")!.toColor
        static let brown            = UIColor(named: "apple_color_brown")!.toColor
        static let brown_Medium     = UIColor(named: "apple_color_brown_Medium")!.toColor
        static let brown_Dark       = UIColor(named: "apple_color_brown_Dark")!.toColor
        static let red_Light        = UIColor(named: "apple_color_red_Light")!.toColor
        static let red_Bright       = UIColor(named: "apple_color_red_Bright")!.toColor
        static let red              = UIColor(named: "apple_color_red")!.toColor
        static let red_Dark         = UIColor(named: "apple_color_red_Dark")!.toColor

        struct Crayons:colorLoopable {
            static let snow         = UIColor(named: "snow")!.toColor
            static let mercury      = UIColor(named: "mercury")!.toColor
            static let silver       = UIColor(named: "silver")!.toColor
            static let magnesium    = UIColor(named: "magnesium")!.toColor
            static let aluminum     = UIColor(named: "aluminum")!.toColor
            static let nickel       = UIColor(named: "nickel")!.toColor
            static let tin          = UIColor(named: "tin")!.toColor
            static let steel        = UIColor(named: "steel")!.toColor
            static let iron         = UIColor(named: "iron")!.toColor
            static let tungsten     = UIColor(named: "tungsten")!.toColor
            static let lead         = UIColor(named: "lead")!.toColor
            static let licorice     = UIColor(named: "licorice")!.toColor
            static let cayenne      = UIColor(named: "cayenne")!.toColor
            static let maraschino   = UIColor(named: "maraschino")!.toColor
            static let salmon       = UIColor(named: "salmon")!.toColor
            static let maroon       = UIColor(named: "maroon")!.toColor
            static let strawberry   = UIColor(named: "strawberry")!.toColor
            static let carnation    = UIColor(named: "carnation")!.toColor
            static let magenta      = UIColor(named: "magenta")!.toColor
            static let bubblegum    = UIColor(named: "bubblegum")!.toColor
            static let eggplant     = UIColor(named: "eggplant")!.toColor
            static let plum         = UIColor(named: "plum")!.toColor
            static let grape        = UIColor(named: "grape")!.toColor
            static let lavender     = UIColor(named: "lavender")!.toColor
            static let midnight     = UIColor(named: "midnight")!.toColor
            static let blueberry    = UIColor(named: "blueberry")!.toColor
            static let orchid       = UIColor(named: "orchid")!.toColor
            static let ocean        = UIColor(named: "ocean")!.toColor
            static let aqua         = UIColor(named: "aqua")!.toColor
            static let sky          = UIColor(named: "sky")!.toColor
            static let turquoise    = UIColor(named: "turquoise")!.toColor
            static let ice          = UIColor(named: "ice")!.toColor
            static let spindrift    = UIColor(named: "spindrift")!.toColor
            static let moss         = UIColor(named: "moss")!.toColor
            static let clover       = UIColor(named: "clover")!.toColor
            static let seafoam      = UIColor(named: "seafoam")!.toColor
            static let spring       = UIColor(named: "spring")!.toColor
            static let fern         = UIColor(named: "fern")!.toColor
            static let flora        = UIColor(named: "flora")!.toColor
            static let honeydew     = UIColor(named: "honeydew")!.toColor
            static let asparagus    = UIColor(named: "asparagus")!.toColor
            static let lemon        = UIColor(named: "lemon")!.toColor
            static let lime         = UIColor(named: "lime")!.toColor
            static let banana       = UIColor(named: "banana")!.toColor
            static let mocha        = UIColor(named: "mocha")!.toColor
            static let tangerine    = UIColor(named: "tangerine")!.toColor
            static let canteloupe   = UIColor(named: "canteloupe")!.toColor
        }

        struct Controls:colorLoopable {
            struct Buttons:colorLoopable {
                struct Blues:colorLoopable {
                    static let blue         = UIColor(named: "controls_buttons_blue")!.toColor
                    static let disabled     = UIColor(named: "controls_buttons_blue_disabled")!.toColor
                }
                struct Greens:colorLoopable {
                    static let green        = UIColor(named: "controls_controls_buttons_green")!.toColor
                    static let disabled     = UIColor(named: "controls_controls_buttons_green_disabled")!.toColor
                }
            }
            struct Glyphs:colorLoopable {
                static let blue         = UIColor(named: "controls_glyphs_blue")!.toColor
                static let disabled     = UIColor(named: "controls_glyphs_blue_disabled")!.toColor
            }
            struct Switches:colorLoopable {
                static let onGreen      = UIColor(named: "controls_switches_onGreen")!.toColor
                static let OffRed       = UIColor(named: "controls_switches_OffRed")!.toColor
            }
            struct Keyboards:colorLoopable {
                static let medium       = UIColor(named: "controls_keyboard_medium")!.toColor
                static let dark         = UIColor(named: "controls_keyboard_medium")!.toColor
            }
        }
    }

// MARK: - *** SHADE COLORS ***
    struct Shades {
        struct Order {
            enum blues { case midnight,blueberry,orchid,ocean,aqua,sky,turquoise,ice,spindrift }
            enum red { case cayenne,maraschino,salmon,maroon,strawberry,carnation,magenta,bubblegum }
            enum grayscale { case snow,mercury,silver,magnesium,aluminum,nickel,tin,steel,iron,tungsten,lead,licorice }
            enum purples { case eggplant,plum,grape,lavender,orchid }
            enum greens { case moss,clover,seafoam,spindrift,spring,flora,fern,lime,honeydew }
            enum yellows { case asparagus,lemon,banana }
            enum oranges { case mocha,tangerine,canteloupe }
        }

        struct Yellows:colorLoopable {
            static let asparagus    = Color.asparagus
            static let lemon        = Color.lemon
            static let banana       = Color.banana
        }
    
        struct Oranges:colorLoopable {
            static let mocha        = Color.mocha
            static let tangerine    = Color.tangerine
            static let canteloupe   = Color.canteloupe
        }
    
        struct Greens:colorLoopable {
            static let moss         = Color.moss
            static let clover       = Color.clover
            static let seafoam      = Color.seafoam
            static let spindrift    = Color.spindrift
            static let spring       = Color.spring
            static let flora        = Color.flora
            static let fern         = Color.fern
            static let lime         = Color.lime
            static let honeydew     = Color.honeydew
        }
    
        struct Blues:colorLoopable {
            static let midnight     = Color.midnight
            static let blueberry    = Color.blueberry
            static let orchid       = Color.orchid
            static let ocean        = Color.ocean
            static let aqua         = Color.aqua
            static let sky          = Color.sky
            static let turquoise    = Color.turquoise
            static let ice          = Color.ice
            static let spindrift    = Color.spindrift
        }
    
        struct Purples:colorLoopable {
            static let eggplant     = Color.eggplant
            static let plum         = Color.plum
            static let grape        = Color.grape
            static let lavender     = Color.lavender
            static let orchid       = Color.orchid
        }
    
        struct Reds:colorLoopable {
            static let cayenne      = Color.cayenne
            static let maraschino   = Color.maraschino
            static let salmon       = Color.salmon
            static let maroon       = Color.maroon
            static let strawberry   = Color.strawberry
            static let carnation    = Color.carnation
            static let magenta      = Color.magenta
            static let bubblegum    = Color.bubblegum
        }

        struct Reds_Other:colorLoopable {
            static let bright           = UIColor(named: "bright")!.toColor
            static let ferrari          = UIColor(named: "ferrari")!.toColor
            static let candyApple       = UIColor(named: "candyApple")!.toColor
            static let scarlet          = UIColor(named: "scarlet")!.toColor
            static let imperial         = UIColor(named: "imperial")!.toColor
            static let USflag           = UIColor(named: "USflag")!.toColor
            static let raspberry        = UIColor(named: "raspberry")!.toColor
            static let persian          = UIColor(named: "persian")!.toColor
            static let crimson          = UIColor(named: "crimson")!.toColor
            static let fireBrick        = UIColor(named: "fireBrick")!.toColor
            static let burgundy         = UIColor(named: "burgundy")!.toColor
            static let carmine          = UIColor(named: "carmine")!.toColor
            static let vermillion       = UIColor(named: "vermillion")!.toColor
            static let maroon           = UIColor(named: "maroon2")!.toColor
            static let barn             = UIColor(named: "barn")!.toColor
            static let sangria          = UIColor(named: "sangria")!.toColor
            static let mahogany         = UIColor(named: "mahogany")!.toColor
            static let rust             = UIColor(named: "rust")!.toColor
            static let redwood          = UIColor(named: "redwood")!.toColor
            static let indian           = UIColor(named: "indian")!.toColor
            static let salmon           = UIColor(named: "salmon2")!.toColor
            static let desire           = UIColor(named: "desire")!.toColor
            static let ruby             = UIColor(named: "ruby")!.toColor
            static let hibiscus         = UIColor(named: "hibiscus")!.toColor
        }
    
        struct Grayscale:colorLoopable {
            static let snow         = Color.snow
            static let mercury      = Color.mercury
            static let silver       = Color.silver
            static let magnesium    = Color.magnesium
            static let aluminum     = Color.aluminum
            static let nickel       = Color.nickel
            static let tin          = Color.tin
            static let steel        = Color.steel
            static let iron         = Color.iron
            static let tungsten     = Color.tungsten
            static let lead         = Color.lead
            static let licorice     = Color.licorice
        }
    }
}

