/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    File: Colors_Clients.swift
  Author: Kevin Messina
 Created: Nov 13, 2019
Modified: Feb 3, 2020

©2019-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

--------------------------------------------------------------------------------------------------------------------------*/

import UIKit

extension UIColor {
    /// First Draught Press (FDP) branded Colors.
    struct FDP:colorLoopable {
        struct Greens:colorLoopable {
            static let medium = UIColor(named: "fdp_green_dark")
            static let dark = UIColor(named: "fdp_green_medium")

            static let arr:NSArray  = [
                colorArrayStruct(id: 0, name: "Green_Medium", color: Greens.medium!),
                colorArrayStruct(id: 1, name: "Green_Dark", color: Greens.dark!)
            ]
            
            static let dict:NSDictionary = [
                "Green_Medium":Greens.medium!,
                "Green_Dark":Greens.dark!
            ]
        }
    }
    
    /// The Modern Game (TMG) branded Colors.
    struct TMG:colorLoopable {
        struct Blues:colorLoopable {
            static let dark = UIColor(named: "tmg_blue_dark")!
            static let medium = UIColor(named: "tmg_blue_medium")!
            static let light = UIColor(named: "tmg_blue_light")!
            static let logo = UIColor(named: "tmg_blue_logo")!
            static let faded = UIColor(named: "tmg_blue_faded")!
        }

        struct Grays:colorLoopable {
            static let veryDark = UIColor(named: "tmg_gray_veryDark")!
            static let dark = UIColor(named: "tmg_gray_dark")!
            static let medium = UIColor(named: "tmg_gray_medium")!
            static let light = UIColor(named: "tmg_gray_light")!
            static let screenBackground = UIColor(named: "tmg_gray__screenBackground")!
        }

        struct Oranges:colorLoopable {
            static let logo = UIColor(named: "tmg_orange_logo")!
            static let faded = UIColor(named: "tmg_orange_faded")!
            static let light = UIColor(named: "tmg_orange_light")!
            static let medium = UIColor(named: "tmg_orange_medium")!
            static let dark = UIColor(named: "tmg_orange_dark")!
        }
        
        static let arr:NSArray = [
            colorArrayStruct(id: 0, name: "Blue_Dark", color: Blues.dark),
            colorArrayStruct(id: 1, name: "Blue_Med", color: Blues.medium),
            colorArrayStruct(id: 2, name: "Blue_Light", color: Blues.light),
            colorArrayStruct(id: 3, name: "Gray_VeryDark", color: Grays.veryDark),
            colorArrayStruct(id: 3, name: "Gray_Dark", color: Grays.dark),
            colorArrayStruct(id: 4, name: "Gray_Medium", color: Grays.medium),
            colorArrayStruct(id: 4, name: "Gray_Light", color: Grays.light),
            colorArrayStruct(id: 3, name: "Gray_ScreenBackground", color: Grays.screenBackground),
            colorArrayStruct(id: 5, name: "Logo_Blue", color: Blues.logo),
            colorArrayStruct(id: 6, name: "Logo_Orange", color: Oranges.logo),
            colorArrayStruct(id: 7, name: "LightBlue", color: Blues.faded),
            colorArrayStruct(id: 8, name: "Orange_Light", color: Oranges.light),
            colorArrayStruct(id: 9, name: "Orange_Med", color: Oranges.medium),
            colorArrayStruct(id: 10, name: "Orange_Dark", color: Oranges.dark),
            colorArrayStruct(id: 11, name: "LightOrange", color: Oranges.faded)
        ]

        static let dict:NSDictionary = [
            "Blue_Dark":Blues.dark,"Blue_Med":Blues.medium,"Blue_Light":Blues.light,
            "Gray_VeryDark":Grays.veryDark,"Gray_Dark":Grays.dark,"Gray_Medium":Grays.medium,"Gray_Light":Grays.light,
            "Logo_Blue":Blues.logo,"Logo_Orange":Oranges.logo,
            "LightBlue":Blues.faded,
            "Orange_Light":Oranges.light,"Orange_Med":Oranges.medium,"Orange_Dark":Oranges.dark
        ]
    }

    /// 2Camels Publishing (2CP or TCP) branded Colors.
    struct TCP:colorLoopable {
        static let midnightBlue = UIColor(named: "tcp_midnightBlue")
        static let peterRiver = UIColor(named: "tcp_peterRiver")
        static let emerald = UIColor(named: "tcp_emerald")
        static let pearl = UIColor(named: "tcp_pearl")
        static let silver = UIColor(named: "tcp_silver")
        static let amethyst = UIColor(named: "tcp_amethyst")
        
        static let arr:NSArray = [
            colorArrayStruct(id: 0, name: "MidnightBlue", color: midnightBlue!),
            colorArrayStruct(id: 1, name: "PeterRiver", color: peterRiver!),
            colorArrayStruct(id: 2, name: "Emerald", color: emerald!),
            colorArrayStruct(id: 3, name: "Pearl", color: pearl!),
            colorArrayStruct(id: 4, name: "Silver", color: silver!),
            colorArrayStruct(id: 5, name: "Amethyst", color: amethyst!)
        ]
        
        static let dict:NSDictionary = [
            "MidnightBlue":midnightBlue!,
            "PeterRiver":peterRiver!,
            "Emerald":emerald!,
            "Pearl":pearl!,"Silver":silver!,
            "Amethyst":amethyst!
        ]
    }

    /// Tire Safety Group branded Colors.
    struct TSG:colorLoopable {
        static let yellow   = UIColor(named: "tsg_yellow")
        static let red      = UIColor(named: "tsg_red")
    }
    
    /// Out-Walkabout brand Colors
    struct OWA:colorLoopable {
        static let Green    = UIColor(named: "owa_green")
        static let Blue     = UIColor(named: "owa_blue")
    }
    
    /// Exhibitus
    struct EXHIBITUS {
        /// Exhibitus (Astellas)
        struct ASTELLAS:colorLoopable {
            static let red      = UIColor(named: "astellas_gray")
            static let gray     = UIColor(named: "astellas_red")
        }
    
        /// Exhibitus (MBX)
        struct MBX:colorLoopable {
            static let blue     = UIColor(named: "mbx_blue")
            static let orange   = UIColor(named: "mbx_orange")
            static let gray     = UIColor(named: "mbx_gray")
        }
    }
    
    /// Creative Apps
    struct CAS {
        /// Creative Apps (OnSale)
        struct OnSale:colorLoopable {
            struct Green:colorLoopable {
                static let dark     = UIColor(named: "onSale_green_dark")
                static let light    = UIColor(named: "onSale_green_light")
                static let medium   = UIColor(named: "onSale_green_med")
            }
            struct Gold:colorLoopable {
                static let dark    = UIColor(named: "onSale_gold_dark")
                static let light   = UIColor(named: "onSale_gold_light")
            }
            static let red         = UIColor(named: "onSale_red")
        }
    }
}

