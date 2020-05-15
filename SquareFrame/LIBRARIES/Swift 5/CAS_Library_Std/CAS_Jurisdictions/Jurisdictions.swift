/*--------------------------------------------------------------------------------------------------------------------------
   File: Jurisdictions.swift
 Author: Kevin Messina
Created: August 28, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift 3.0 on September 16, 2016
--------------------------------------------------------------------------------------------------------------------------*/


// MARK: - *** FUNCTIONS ***
/// Structs for custom colors.
@objc(Jurisdictions) public final class Jurisdictions:UIColor {
    var Version: String { return "2.01" }
    
    public enum Juristype { case state,province,territory,district,outlyingTerritories,freeStates,militaryMailCode,minorTerritory,provincialTerritory,country,unknown}
    public enum JurisRegion { case continental,nonContiguous,possession,military,country,unknown}

// MARK: - *** JURISDICTION STRUCTS ***
// MARK: --> *** Continents ***
    public struct Continents {
        static let Africa = "Africa"
        static let Antarctica = "Antarctica"
        static let Asia = "Asia"
        static let Australia = "Australia"
        static let Europe = "Europe"
        static let NorthAmerica = "North America"
        static let SouthAmerica = "South America"
        static let all = [Africa,Antarctica,Asia,Australia,Europe,NorthAmerica,SouthAmerica].sorted()
    }

// MARK: --> *** Seas ***
    public struct Seas {
        static let Arctic = "Arctic"
        static let NorthAtlantic = "North Atlantic"
        static let SouthAtlantic = "South Atlantic"
        static let NorthPacific = "North Pacific"
        static let SouthPacific = "South Pacific"
        static let Indian = "Indian"
        static let Southern = "Southern"
        static let all = [Arctic,NorthAtlantic,SouthAtlantic,NorthPacific,SouthPacific,Indian,Southern].sorted()
    }

// MARK: --> *** Oceans ***
    public struct Oceans {
        static let Arctic = "Arctic"
        static let Atlantic = "Atlantic"
        static let Pacific = "Pacific"
        static let Indian = "Indian"
        static let Southern = "Southern"
        static let all = [Arctic,Atlantic,Pacific,Indian,Southern].sorted()
    }

// MARK: --> *** JurisdictionStruct ***
    struct JurisdictionStruct {
        var name:String!
        var code:String!
        var country:String!
        var type:Juristype!
        var region:JurisRegion!
        var flagImgName:String!
        var currency:String!
        var currencyCode:String!
        var currencySymbol:String!
        var codeISO:String!
        
        init(
            name:String? = "",
            code:String? = "",
            country:String? = "",
            type:Juristype? = Juristype.country,
            region:JurisRegion = JurisRegion.country,
            flagImgName:String? = "",
            currency:String? = "",
            currencyCode:String? = "",
            currencySymbol:String? = "",
            codeISO:String? = ""
        ){
            self.name = name
            self.code = code
            self.country = country
            self.type = type
            self.region = region
            self.flagImgName = flagImgName
            self.currency = currency
            self.currencyCode = currencyCode
            self.currencySymbol = currencySymbol
            self.codeISO = codeISO!
        }
    }

// MARK: --> *** Canada ***
    struct Canada {
        static let all:[JurisdictionStruct] = (Provinces.all + Territories.all).sorted(by: { ($0.name < $1.name) })
        
        struct Provinces {
            static let Alberta:JurisdictionStruct = JurisdictionStruct(name:"Alberta",code:"AB",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let BritishColumbia:JurisdictionStruct = JurisdictionStruct(name:"British Columbia",code:"BC",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let Manitoba:JurisdictionStruct = JurisdictionStruct(name:"Manitoba",code:"MB",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let NewBrunswick:JurisdictionStruct = JurisdictionStruct(name:"New Brunswick",code:"NB",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let NewfoundlandAndLabrador:JurisdictionStruct = JurisdictionStruct(name:"Newfoundland and Labrador",code:"NL",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let NovaScotia:JurisdictionStruct = JurisdictionStruct(name:"Nova Scotia",code:"NS",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let Nunavut:JurisdictionStruct = JurisdictionStruct(name:"Nunavut",code:"NU",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let Ontario:JurisdictionStruct = JurisdictionStruct(name:"Ontario",code:"ON",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let PrinceEdwardIsland:JurisdictionStruct = JurisdictionStruct(name:"Prince Edward Island",code:"PE",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let Quebec:JurisdictionStruct = JurisdictionStruct(name:"Quebec",code:"QC",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let Saskatchewan:JurisdictionStruct = JurisdictionStruct(name:"Saskatchewan",code:"SK",country:"Canada",type:.province,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let all:[JurisdictionStruct] = [Alberta,BritishColumbia,Manitoba,NewBrunswick,NewfoundlandAndLabrador,NovaScotia,Nunavut,Ontario,PrinceEdwardIsland,Quebec,].sorted(by: { ($0.name < $1.name) })
        }
        
        struct Territories {
            static let Northwest:JurisdictionStruct = JurisdictionStruct(name:"Northwest Territories",code:"NT",country:"Canada",type:.provincialTerritory,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let Yukon:JurisdictionStruct = JurisdictionStruct(name:"Yukon Territory",code:"YT",country:"Canada",type:.provincialTerritory,region:.country,flagImgName:"Canada",currency:"Canadian Dollar",currencyCode:"CD",currencySymbol:"$")
            static let all:[JurisdictionStruct] = [Northwest,Yukon].sorted(by: { ($0.name < $1.name) })
        }
        
        static var arrNames:[String] {
            var provinces:[String] = []
            
            Provinces.all.forEach { (provinceStruct) in
                provinces.append( provinceStruct.name )
            }
            
            return provinces.sorted()
        }
    }
    
// MARK: --> *** Mexico ***
    struct Mexico  {
        static let all:[JurisdictionStruct] = States.all.sorted(by: { ($0.name < $1.name) })
        
        struct States {
            static let Aguascalientes:JurisdictionStruct = JurisdictionStruct(name:"Aguascalientes",code:"AG",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let BajaCalifornia:JurisdictionStruct = JurisdictionStruct(name:"Baja California",code:"BC",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let BajaCaliforniaSur:JurisdictionStruct = JurisdictionStruct(name:"Baja California Sur",code:"BS",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Campeche:JurisdictionStruct = JurisdictionStruct(name:"Campeche",code:"CM",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Coahuila:JurisdictionStruct = JurisdictionStruct(name:"Coahuila",code:"CO",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Colima:JurisdictionStruct = JurisdictionStruct(name:"Colima",code:"CL",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Chiapas:JurisdictionStruct = JurisdictionStruct(name:"Chiapas",code:"CS",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Chihuahua:JurisdictionStruct = JurisdictionStruct(name:"Chihuahua",code:"CH",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Durango:JurisdictionStruct = JurisdictionStruct(name:"Durango",code:"DG",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Guanajuato:JurisdictionStruct = JurisdictionStruct(name:"Guanajuato",code:"GT",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Guerrero:JurisdictionStruct = JurisdictionStruct(name:"Guerrero",code:"GR",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Hidalgo:JurisdictionStruct = JurisdictionStruct(name:"Hidalgo",code:"HG",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Jalisco:JurisdictionStruct = JurisdictionStruct(name:"Jalisco",code:"JA",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Mexico:JurisdictionStruct = JurisdictionStruct(name:"Mexico",code:"EM",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let MexicoCity:JurisdictionStruct = JurisdictionStruct(name:"Mexico City",code:"DF",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Michoacan:JurisdictionStruct = JurisdictionStruct(name:"Michoacan",code:"MI",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Morelos:JurisdictionStruct = JurisdictionStruct(name:"Morelos",code:"MO",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Nayarit:JurisdictionStruct = JurisdictionStruct(name:"Nayarit",code:"NA",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let NuevoLeón:JurisdictionStruct = JurisdictionStruct(name:"Nuevo León",code:"NL",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Oaxaca:JurisdictionStruct = JurisdictionStruct(name:"Oaxaca",code:"OA",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Puebla:JurisdictionStruct = JurisdictionStruct(name:"Puebla",code:"PU",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Queretaro:JurisdictionStruct = JurisdictionStruct(name:"Queretaro",code:"QT",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let QuintanaRoo:JurisdictionStruct = JurisdictionStruct(name:"Quintana Roo",code:"QR",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let SanLuisPotosi:JurisdictionStruct = JurisdictionStruct(name:"San Luis Potosi",code:"SL",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Sinaloa:JurisdictionStruct = JurisdictionStruct(name:"Sinaloa",code:"SI",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Sonora:JurisdictionStruct = JurisdictionStruct(name:"Sonora",code:"SO",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Tabasco:JurisdictionStruct = JurisdictionStruct(name:"Tabasco",code:"TB",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Tamaulipas:JurisdictionStruct = JurisdictionStruct(name:"Tamaulipas",code:"TM",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Tlaxcala:JurisdictionStruct = JurisdictionStruct(name:"Tlaxcala",code:"TL",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Veracruz:JurisdictionStruct = JurisdictionStruct(name:"Veracruz",code:"VE",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Yucatán:JurisdictionStruct = JurisdictionStruct(name:"Yucatán",code:"YU",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let Zacatecas:JurisdictionStruct = JurisdictionStruct(name:"Zacatecas",code:"ZA",country:"Mexico",type:.state,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
            static let all:[JurisdictionStruct] = [
                Aguascalientes,BajaCalifornia,BajaCaliforniaSur,Campeche,Coahuila,Colima,Chiapas,Chihuahua,Durango,
                Guanajuato,Guerrero,Hidalgo,Jalisco,Mexico,MexicoCity,Michoacan,Morelos,Nayarit,NuevoLeón,Oaxaca,
                Puebla,Queretaro,QuintanaRoo,SanLuisPotosi,Sinaloa,Sonora,Tabasco,Tamaulipas,Tlaxcala,Veracruz,Yucatán,Zacatecas
            ].sorted(by: { ($0.name < $1.name) })
            
            static var arrNames:[String] {
                var states:[String] = []
                
                States.all.forEach { (stateStruct) in
                    states.append( stateStruct.name )
                }
                
                return states.sorted()
            }
        }
    }
    
// MARK: --> *** U.S. ***
    struct US {
        static let DC:JurisdictionStruct = JurisdictionStruct(name:"Washington D.C.",code:"DC",country:"United States Distric of Columbia",type:.district,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
        static let StatesAndDC:[JurisdictionStruct] = (States.all + [DC]).sorted(by: { ($0.name < $1.name) })
        static let StatesAndDCAndPR:[JurisdictionStruct] = (States.all + [DC] + Territories.GuamAndPuertoRico).sorted(by: { ($0.name < $1.name) })
        static let StatesAndDCAndTerritories:[JurisdictionStruct] = (StatesAndDC + Territories.all).sorted(by: { ($0.name < $1.name) })
        
        struct States {
            static let Continental:[JurisdictionStruct] = Contiguous.all.sorted(by: { ($0.name < $1.name) })
            static let all:[JurisdictionStruct] = (NonContiguous.all + Contiguous.all).sorted(by: { ($0.name < $1.name) })
            
            struct NonContiguous {
                static let Alaska:JurisdictionStruct = JurisdictionStruct(name:"Alaska",code:"AK",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Hawaii:JurisdictionStruct = JurisdictionStruct(name:"Hawaii",code:"HI",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let all:[JurisdictionStruct] = [Alaska,Hawaii].sorted(by: { ($0.name < $1.name) })
            }
            
            struct Contiguous {
                static let Alabama:JurisdictionStruct = JurisdictionStruct(name:"Alabama",code:"AL",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Arizona:JurisdictionStruct = JurisdictionStruct(name:"Arizona",code:"AZ",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Arkansas:JurisdictionStruct = JurisdictionStruct(name:"Arkansas",code:"AR",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let California:JurisdictionStruct = JurisdictionStruct(name:"California",code:"CA",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Colorado:JurisdictionStruct = JurisdictionStruct(name:"Colorado",code:"CO",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Connecticut:JurisdictionStruct = JurisdictionStruct(name:"Connecticut",code:"CT",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Delaware:JurisdictionStruct = JurisdictionStruct(name:"Delaware",code:"DE",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Florida:JurisdictionStruct = JurisdictionStruct(name:"Florida",code:"FL",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Georgia:JurisdictionStruct = JurisdictionStruct(name:"Georgia",code:"GA",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Idaho:JurisdictionStruct = JurisdictionStruct(name:"Idaho",code:"ID",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Illinois:JurisdictionStruct = JurisdictionStruct(name:"Illinois",code:"IL",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Indiana:JurisdictionStruct = JurisdictionStruct(name:"Indiana",code:"IN",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Iowa:JurisdictionStruct = JurisdictionStruct(name:"Iowa",code:"IA",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Kansas:JurisdictionStruct = JurisdictionStruct(name:"Kansas",code:"KS",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Kentucky:JurisdictionStruct = JurisdictionStruct(name:"Kentucky",code:"KY",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Louisiana:JurisdictionStruct = JurisdictionStruct(name:"Louisiana",code:"LA",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Maine:JurisdictionStruct = JurisdictionStruct(name:"Maine",code:"ME",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Maryland:JurisdictionStruct = JurisdictionStruct(name:"Maryland",code:"MD",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Massachusettes:JurisdictionStruct = JurisdictionStruct(name:"Massachusettes",code:"MA",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Michigan:JurisdictionStruct = JurisdictionStruct(name:"Michigan",code:"MI",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Minnesota:JurisdictionStruct = JurisdictionStruct(name:"Minnesota",code:"MN",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Mississippi:JurisdictionStruct = JurisdictionStruct(name:"Mississippi",code:"MS",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Missouri:JurisdictionStruct = JurisdictionStruct(name:"Missouri",code:"MO",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Montana:JurisdictionStruct = JurisdictionStruct(name:"Montana",code:"MT",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Nebraska:JurisdictionStruct = JurisdictionStruct(name:"Nebraska",code:"NE",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Nevada:JurisdictionStruct = JurisdictionStruct(name:"Nevada",code:"NV",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let NewHampshire:JurisdictionStruct = JurisdictionStruct(name:"New Hampshire",code:"NH",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let NewJersey:JurisdictionStruct = JurisdictionStruct(name:"New Jersey",code:"NJ",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let NewMexico:JurisdictionStruct = JurisdictionStruct(name:"New Mexico",code:"NM",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let NewYork:JurisdictionStruct = JurisdictionStruct(name:"New York",code:"NY",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let NorthCarolina:JurisdictionStruct = JurisdictionStruct(name:"North Carolina",code:"NC",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let NorthDakota:JurisdictionStruct = JurisdictionStruct(name:"North Dakota",code:"ND",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Ohio:JurisdictionStruct = JurisdictionStruct(name:"Ohio",code:"OH",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Oklahoma:JurisdictionStruct = JurisdictionStruct(name:"Oklahoma",code:"OK",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Oregon:JurisdictionStruct = JurisdictionStruct(name:"Oregon",code:"OR",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Pennsylvania:JurisdictionStruct = JurisdictionStruct(name:"Pennsylvania",code:"PA",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let RhodeIsland:JurisdictionStruct = JurisdictionStruct(name:"Rhode Island",code:"RI",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let SouthCarolina:JurisdictionStruct = JurisdictionStruct(name:"South Carolina",code:"SC",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let SouthDakota:JurisdictionStruct = JurisdictionStruct(name:"South Dakota",code:"SD",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Tennessee:JurisdictionStruct = JurisdictionStruct(name:"Tennessee",code:"TN",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Texas:JurisdictionStruct = JurisdictionStruct(name:"Texas",code:"TX",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Utah:JurisdictionStruct = JurisdictionStruct(name:"Utah",code:"UT",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Vermont:JurisdictionStruct = JurisdictionStruct(name:"Vermont",code:"VT",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Virginia:JurisdictionStruct = JurisdictionStruct(name:"Virginia",code:"VA",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Washington:JurisdictionStruct = JurisdictionStruct(name:"Washington",code:"WA",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let WestVirginia:JurisdictionStruct = JurisdictionStruct(name:"West Virginia",code:"WV",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Wisconsin:JurisdictionStruct = JurisdictionStruct(name:"Wisconsin",code:"WI",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Wyoming:JurisdictionStruct = JurisdictionStruct(name:"Wyoming",code:"WY",country:"United States",type:.state,region:.country,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let all:[JurisdictionStruct] = [
                    Alabama,Arizona,Arkansas,California,Colorado,Connecticut,Delaware,Florida,Georgia,Idaho,
                    Illinois,Indiana,Iowa,Kansas,Kentucky,Louisiana,Maine,Maryland,Massachusettes,Michigan,
                    Minnesota,Mississippi,Missouri,Montana,Nebraska,Nevada,NewHampshire,NewJersey,NewMexico,
                    NewYork,NorthCarolina,NorthDakota,Ohio,Oklahoma,Oregon,Pennsylvania,RhodeIsland,SouthCarolina,
                    SouthDakota,Tennessee,Texas,Utah,Vermont,Virginia,Washington,WestVirginia,Wisconsin,Wyoming
                ].sorted(by: { ($0.name < $1.name) })
            }
            
            static var arrNames:[String] {
                var states:[String] = []
                
                States.all.forEach { (stateStruct) in
                    states.append( stateStruct.name )
                }
                
                return states.sorted()
            }
        }
        
        struct Territories {
            static let Guam:JurisdictionStruct = JurisdictionStruct(name:"Guam",code:"GU",country:"United States Territory",type:.minorTerritory,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
            static let PuertoRico:JurisdictionStruct = JurisdictionStruct(name:"Puerto Rico",code:"PR",country:"United States Territory",type:.territory,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
            static let GuamAndPuertoRico:[JurisdictionStruct] = [Guam,PuertoRico].sorted(by: { ($0.name < $1.name) })
            static let all:[JurisdictionStruct] = (GuamAndPuertoRico + Minor.all + Outlying.all + FreeStates.all).sorted(by: { ($0.name < $1.name) })
            
            struct Minor {
                static let AmericanSamoa:JurisdictionStruct = JurisdictionStruct(name:"American Samoa",code:"AS",country:"United States Minor Territories",type:.minorTerritory,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let NorthernMarianaIslands:JurisdictionStruct = JurisdictionStruct(name:"Northern Mariana Islands",code:"MP",country:"United States Minor Territories",type:.minorTerritory,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let VirginIslands:JurisdictionStruct = JurisdictionStruct(name:"US Virgin Islands",code:"VI",country:"United States Minor Territories",type:.minorTerritory,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let all:[JurisdictionStruct] = [AmericanSamoa,NorthernMarianaIslands,VirginIslands].sorted(by: { ($0.name < $1.name) })
            }
            struct Outlying {
                static let BakerIsland:JurisdictionStruct = JurisdictionStruct(name:"Baker Island",code:"81",country:"United States Minor Outlying Territories",type:.outlyingTerritories,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let HowlandIsland:JurisdictionStruct = JurisdictionStruct(name:"Howland Island",code:"84",country:"United States Minor Outlying Territories",type:.outlyingTerritories,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let JarvisIsland:JurisdictionStruct = JurisdictionStruct(name:"Jarvis Island",code:"86",country:"United States Minor Outlying Territories",type:.outlyingTerritories,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let JohnstonAtoll:JurisdictionStruct = JurisdictionStruct(name:"Johnston Atoll",code:"67",country:"United States Minor Outlying Territories",type:.outlyingTerritories,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let KingmanReef:JurisdictionStruct = JurisdictionStruct(name:"Kingman Reef",code:"89",country:"United States Minor Outlying Territories",type:.outlyingTerritories,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let MidwayIslands:JurisdictionStruct = JurisdictionStruct(name:"Midway Islands",code:"71",country:"United States Minor Outlying Territories",type:.outlyingTerritories,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let NavassaIsland:JurisdictionStruct = JurisdictionStruct(name:"Navassa Island",code:"76",country:"United States Minor Outlying Territories",type:.outlyingTerritories,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let PalmyraAtoll:JurisdictionStruct = JurisdictionStruct(name:"Palmyra Atoll",code:"95",country:"United States Minor Outlying Territories",type:.outlyingTerritories,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let WakeIsland:JurisdictionStruct = JurisdictionStruct(name:"Wake Island",code:"79",country:"United States Minor Outlying Territories",type:.outlyingTerritories,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let all:[JurisdictionStruct] = [BakerIsland,HowlandIsland,JarvisIsland,JohnstonAtoll,KingmanReef,MidwayIslands,NavassaIsland,PalmyraAtoll,WakeIsland].sorted(by: { ($0.name < $1.name) })
            }
            struct FreeStates {
                static let Micronesia:JurisdictionStruct = JurisdictionStruct(name:"Micronesia",code:"FM",country:"United States Free States",type:.freeStates,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let MarshallIslands:JurisdictionStruct = JurisdictionStruct(name:"Marshall Islands",code:"MH",country:"United States Free States",type:.freeStates,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Palau:JurisdictionStruct = JurisdictionStruct(name:"Palau",code:"PW",country:"United States Free States",type:.freeStates,region:.possession,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let all:[JurisdictionStruct] = [Micronesia,MarshallIslands,Palau].sorted(by: { ($0.name < $1.name) })
            }
        }
        
        struct ArmedForces {
            static let Americas:JurisdictionStruct = JurisdictionStruct(name:"U.S. Armed Forces: Americas",code:"AA",country:"United States",type:.militaryMailCode,region:.military,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
            static let Europe:JurisdictionStruct = JurisdictionStruct(name:"U.S. Armed Forces: Europe",code:"AE",country:"United States",type:.militaryMailCode,region:.military,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
            static let Pacific:JurisdictionStruct = JurisdictionStruct(name:"U.S. Armed Forces: Pacific",code:"AP",country:"United States",type:.militaryMailCode,region:.military,flagImgName:"United States",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
            static let all:[JurisdictionStruct] = [Americas,Europe,Pacific].sorted(by: { ($0.name < $1.name) })
        }
    }

// MARK: --> *** Countries ***
    struct Countries {
        static let all:[JurisdictionStruct] = Regions.all.sorted(by: { ($0.name < $1.name) })

// MARK: ---> *** Regions ***
        struct Regions {
            static let all:[JurisdictionStruct] = (
                Americas.all + Europe.all + Asia.all + AustraliaOceania.all + Africa.all + Carribean.all + Other.all
            ).sorted(by: { ($0.name < $1.name) })

            struct Americas {
                static let all:[JurisdictionStruct] = (NorthAmerica.all + Mexico.all + CentralAmerica.all + SouthAmerica.all).sorted(by: { ($0.name < $1.name) })
                static let LatinAmerica:[JurisdictionStruct] = (Mexico.all + CentralAmerica.all + SouthAmerica.all).sorted(by: { ($0.name < $1.name) })

                struct NorthAmerica {
                    static let Canada:JurisdictionStruct = JurisdictionStruct(name:"Canada",code:"CA",country:"Canada",type:.country,region:.country,flagImgName:"Canada",currency:"Canada Dollar",currencyCode:"CAD",currencySymbol:"$")
                    static let Mexico:JurisdictionStruct = JurisdictionStruct(name:"Mexico",code:"MX",country:"Mexico",type:.country,region:.country,flagImgName:"Mexico",currency:"Mexico Peso",currencyCode:"MXN",currencySymbol:"$")
                    static let UnitedStates:JurisdictionStruct = JurisdictionStruct(name:"United States",code:"US",country:"United States",type:.country,region:.country,flagImgName:"UnitedStates",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                    static let all:[JurisdictionStruct] = [Canada,UnitedStates,Mexico].sorted(by: { ($0.name < $1.name) })
                }
                
                struct CentralAmerica  {
                    static let Belize:JurisdictionStruct = JurisdictionStruct(name:"Belize",code:"BZ",country:"Belize",type:.country,region:.country,flagImgName:"Belize",currency:"Belize Dollar",currencyCode:"BZD",currencySymbol:"BZ$")
                    static let CostaRica:JurisdictionStruct = JurisdictionStruct(name:"Costa Rica",code:"CR",country:"Costa Rica",type:.country,region:.country,flagImgName:"CostaRica",currency:"Costa Rica Colon",currencyCode:"CRC",currencySymbol:"₡")
                    static let ElSalvador:JurisdictionStruct = JurisdictionStruct(name:"El Salvador",code:"SV",country:"El Salvador",type:.country,region:.country,flagImgName:"ElSalvador",currency:"El Salvador Colon",currencyCode:"SVC",currencySymbol:"$")
                    static let Guatemala:JurisdictionStruct = JurisdictionStruct(name:"Guatemala",code:"GT",country:"Guatemala",type:.country,region:.country,flagImgName:"Guatemala",currency:"Guatemala Quetzal",currencyCode:"GTQ",currencySymbol:"Q")
                    static let Honduras:JurisdictionStruct = JurisdictionStruct(name:"Honduras",code:"HN",country:"Honduras",type:.country,region:.country,flagImgName:"Honduras",currency:"Honduras Lempira",currencyCode:"HNL",currencySymbol:"L")
                    static let Nicaragua:JurisdictionStruct = JurisdictionStruct(name:"Nicaragua",code:"NI",country:"Nicaragua",type:.country,region:.country,flagImgName:"Nicaragua",currency:"Nicaragua Cordoba",currencyCode:"NIO",currencySymbol:"C$")
                    static let Panama:JurisdictionStruct = JurisdictionStruct(name:"Panama",code:"PA",country:"Panama",type:.country,region:.country,flagImgName:"Panama",currency:"Panama Balboa",currencyCode:"PAB",currencySymbol:"B/.")
                    static let all:[JurisdictionStruct] = [Belize,CostaRica,ElSalvador,Honduras,Nicaragua,Panama].sorted(by: { ($0.name < $1.name) })
                }
                
                struct SouthAmerica  {
                    static let Argentina:JurisdictionStruct = JurisdictionStruct(name:"Argentina",code:"AR",country:"Argentina",type:.country,region:.country,flagImgName:"Argentina",currency:"Argentina Peso",currencyCode:"ARS",currencySymbol:"$")
                    static let Bolivia:JurisdictionStruct = JurisdictionStruct(name:"Bolivia",code:"BO",country:"Bolivai, Lurinational State Of",type:.country,region:.country,flagImgName:"Bolivia",currency:"Bolivia Boliviano",currencyCode:"BOB",currencySymbol:"$b")
                    static let Brazil:JurisdictionStruct = JurisdictionStruct(name:"Brazil",code:"BR",country:"Brazil",type:.country,region:.country,flagImgName:"Brazil",currency:"Brazil Real",currencyCode:"BRL",currencySymbol:"R$")
                    static let Chile:JurisdictionStruct = JurisdictionStruct(name:"Chile",code:"CL",country:"Chile",type:.country,region:.country,flagImgName:"Chile",currency:"Chile Peso",currencyCode:"CLP",currencySymbol:"$")
                    static let Colombia:JurisdictionStruct = JurisdictionStruct(name:"Colombia",code:"CO",country:"Columbia",type:.country,region:.country,flagImgName:"Colombia",currency:"Colombia Peso",currencyCode:"COP",currencySymbol:"$")
                    static let Ecuador:JurisdictionStruct = JurisdictionStruct(name:"Ecuador",code:"EC",country:"Ecuador",type:.country,region:.country,flagImgName:"Ecuador",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                    static let FrenchGuiana:JurisdictionStruct = JurisdictionStruct(name:"French Guiana",code:"GF",country:"French Guiana",type:.country,region:.country,flagImgName:"FrenchGuiana",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                    static let Guyana:JurisdictionStruct = JurisdictionStruct(name:"Guyana",code:"GY",country:"Guyana",type:.country,region:.country,flagImgName:"Guyana",currency:"Guyana Dollar",currencyCode:"GYD",currencySymbol:"$")
                    static let Paraguay:JurisdictionStruct = JurisdictionStruct(name:"Paraguay",code:"PY",country:"Paraguay",type:.country,region:.country,flagImgName:"Paraguay",currency:"Paraguay Guarani",currencyCode:"PYG",currencySymbol:"Gs")
                    static let Peru:JurisdictionStruct = JurisdictionStruct(name:"Peru",code:"PE",country:"Peru",type:.country,region:.country,flagImgName:"Peru",currency:"Peru Nuevo Sol",currencyCode:"PEN",currencySymbol:"S/.")
                    static let Suriname:JurisdictionStruct = JurisdictionStruct(name:"Suriname",code:"SR",country:"Suriname",type:.country,region:.country,flagImgName:"Suriname",currency:"Suriname Dollar",currencyCode:"SRD",currencySymbol:"$")
                    static let Uruguay:JurisdictionStruct = JurisdictionStruct(name:"Uruguay",code:"UY",country:"Uruguay",type:.country,region:.country,flagImgName:"Uruguay",currency:"Uruguay Peso",currencyCode:"UYU",currencySymbol:"$U")
                    static let Venezuela:JurisdictionStruct = JurisdictionStruct(name:"Venezuela",code:"VE",country:"Venezuela, Bolivarian Republic Of",type:.country,region:.country,flagImgName:"Venezuela",currency:"Venezuela Bolivar",currencyCode:"VEF",currencySymbol:"Bs")
                    static let all:[JurisdictionStruct] = [
                        Argentina,Bolivia,Brazil,Chile,Colombia,Ecuador,FrenchGuiana,Guyana,Paraguay,Peru,Suriname,
                        Uruguay,Venezuela
                    ].sorted(by: { ($0.name < $1.name) })
                }
            }
            
            struct Europe {
                static let all:[JurisdictionStruct] = [
                    Albania,Andorra,Armenia,Austria,Azerbaijan,Belarus,Belgium,BosniaAndHerzogovina,Bulgaria,Croatia,
                    Cyprus,CzechRepublic,Denmark,Estonia,Finland,France,Georgia,Germany,Greece,Hungary,Iceland,Ireland,
                    Italy,Khazakhstan,Kosovo,Latvia,Liechtenstein,Lithuania,Luxembourg,Malta,Moldova,Monaco,Montenegro,
                    Netherlands,NorthMacedonia,Norway,Poland,Portugal,Romania,Russia,SanMarino,Serbia,Slovakia,Slovenia,
                    Spain,Sweden,Switzerland,Turkey,Ukraine,UnitedKingdom,VaticanCity
                ].sorted(by: { ($0.name < $1.name) })

                static let Albania:JurisdictionStruct = JurisdictionStruct(name:"Albania",code:"AL",country:"Albania",type:.country,region:.country,flagImgName:"Albania",currency:"Albania Lek",currencyCode:"ALL",currencySymbol:"Lek")
                static let Andorra:JurisdictionStruct = JurisdictionStruct(name:"Andorra",code:"AD",country:"Andorra",type:.country,region:.country,flagImgName:"Andorra",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Armenia:JurisdictionStruct = JurisdictionStruct(name:"Armenia",code:"AM",country:"Armenia",type:.country,region:.country,flagImgName:"Armenia",currency:"Aremenia Dram",currencyCode:"AMD",currencySymbol:"AMD")
                static let Austria:JurisdictionStruct = JurisdictionStruct(name:"Austria",code:"AT",country:"Austria",type:.country,region:.country,flagImgName:"Austria",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Azerbaijan:JurisdictionStruct = JurisdictionStruct(name:"Azerbaijan",code:"AZ",country:"Azerbaijan",type:.country,region:.country,flagImgName:"Azerbaijan",currency:"New Manats",currencyCode:"AZN",currencySymbol:"MaH")
                static let Belarus:JurisdictionStruct = JurisdictionStruct(name:"Belarus",code:"BY",country:"Belarus",type:.country,region:.country,flagImgName:"Belarus",currency:"Belarus Ruble",currencyCode:"BYR",currencySymbol:"Br")
                static let Belgium:JurisdictionStruct = JurisdictionStruct(name:"Belgium",code:"BE",country:"Belgium",type:.country,region:.country,flagImgName:"Belgium",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let BosniaAndHerzogovina:JurisdictionStruct = JurisdictionStruct(name:"Bosnia and Herzogovina",code:"BA",country:"Bosnia and Herzogovina",type:.country,region:.country,flagImgName:"BosniaAndHerzegovina",currency:"Bosnia and Herzegovina Convertible Marka",currencyCode:"BAM",currencySymbol:"KM")
                static let Bulgaria:JurisdictionStruct = JurisdictionStruct(name:"Bulgaria",code:"BG",country:"Bulgaria",type:.country,region:.country,flagImgName:"Bulgaria",currency:"Bulgaria Lev",currencyCode:"BGN",currencySymbol:"BGN")
                static let Croatia:JurisdictionStruct = JurisdictionStruct(name:"Croatia",code:"HR",country:"Croatia",type:.country,region:.country,flagImgName:"Croatia",currency:"Croatia Kuna",currencyCode:"HRK",currencySymbol:"kn")
                static let Cyprus:JurisdictionStruct = JurisdictionStruct(name:"Cyprus",code:"CY",country:"Cyprus",type:.country,region:.country,flagImgName:"Cyprus",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let CzechRepublic:JurisdictionStruct = JurisdictionStruct(name:"Czech Republic",code:"CZ",country:"Czech Republic",type:.country,region:.country,flagImgName:"CzechRepublic",currency:"Czech Republic Koruna",currencyCode:"CZK",currencySymbol:"Kč")
                static let Denmark:JurisdictionStruct = JurisdictionStruct(name:"Denmark",code:"DK",country:"Denmark",type:.country,region:.country,flagImgName:"Denmark",currency:"Denmark Krone",currencyCode:"DKK",currencySymbol:"kr")
                static let Estonia:JurisdictionStruct = JurisdictionStruct(name:"Estonia",code:"EE",country:"Estonia",type:.country,region:.country,flagImgName:"Estonia",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Finland:JurisdictionStruct = JurisdictionStruct(name:"Finland",code:"FI",country:"Finland",type:.country,region:.country,flagImgName:"Finland",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let France:JurisdictionStruct = JurisdictionStruct(name:"France",code:"FR",country:"France",type:.country,region:.country,flagImgName:"France",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Georgia:JurisdictionStruct = JurisdictionStruct(name:"Georgia",code:"GE",country:"Georgia",type:.country,region:.country,flagImgName:"Georgia",currency:"Lari",currencyCode:"GEL",currencySymbol:"₾")
                static let Germany:JurisdictionStruct = JurisdictionStruct(name:"Germany",code:"DE",country:"Germany",type:.country,region:.country,flagImgName:"Germany",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Greece:JurisdictionStruct = JurisdictionStruct(name:"Greece",code:"GR",country:"Greece",type:.country,region:.country,flagImgName:"Greece",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Hungary:JurisdictionStruct = JurisdictionStruct(name:"Hungary",code:"HU",country:"Hungary",type:.country,region:.country,flagImgName:"Hungary",currency:"Hungary Forint",currencyCode:"HUF",currencySymbol:"Ft")
                static let Iceland:JurisdictionStruct = JurisdictionStruct(name:"Iceland",code:"IS",country:"Iceland",type:.country,region:.country,flagImgName:"Iceland",currency:"Iceland Krona",currencyCode:"ISK",currencySymbol:"kr")
                static let Ireland:JurisdictionStruct = JurisdictionStruct(name:"Ireland",code:"IE",country:"Ireland",type:.country,region:.country,flagImgName:"Ireland",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Italy:JurisdictionStruct = JurisdictionStruct(name:"Italy",code:"IT",country:"Italy",type:.country,region:.country,flagImgName:"Italy",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Khazakhstan:JurisdictionStruct = JurisdictionStruct(name:"Khazakhstan",code:"KZ",country:"Khazakhstan",type:.country,region:.country,flagImgName:"Kazakhstan",currency:"Kazakhstan Tenge",currencyCode:"KZT",currencySymbol:"KZT")
                static let Kosovo:JurisdictionStruct = JurisdictionStruct(name:"Kosovo",code:"XK",country:"Kosovo, Republic Of",type:.country,region:.country,flagImgName:"Kosovo",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Latvia:JurisdictionStruct = JurisdictionStruct(name:"Latvia",code:"LV",country:"Latvia",type:.country,region:.country,flagImgName:"Latvia",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Liechtenstein:JurisdictionStruct = JurisdictionStruct(name:"Liechtenstein",code:"LI",country:"Liechtenstein",type:.country,region:.country,flagImgName:"Liechtenstein",currency:"Swiss Franc",currencyCode:"CHF",currencySymbol:"CHF")
                static let Lithuania:JurisdictionStruct = JurisdictionStruct(name:"Lithuania",code:"LT",country:"Lithuania",type:.country,region:.country,flagImgName:"Lithuania",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Luxembourg:JurisdictionStruct = JurisdictionStruct(name:"Luxembourg",code:"LU",country:"Luxembourg",type:.country,region:.country,flagImgName:"Luxembourg",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Malta:JurisdictionStruct = JurisdictionStruct(name:"Malta",code:"MT",country:"Malta",type:.country,region:.country,flagImgName:"Malta",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Moldova:JurisdictionStruct = JurisdictionStruct(name:"Moldova",code:"MD",country:"Moldova, Republic Of",type:.country,region:.country,flagImgName:"Moldova",currency:"Moldovan Leu",currencyCode:"MDL",currencySymbol:"L")
                static let Monaco:JurisdictionStruct = JurisdictionStruct(name:"Monaco",code:"MC",country:"Monaco",type:.country,region:.country,flagImgName:"Monaco",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Montenegro:JurisdictionStruct = JurisdictionStruct(name:"Montenegro",code:"ME",country:"Montenegro",type:.country,region:.country,flagImgName:"Montenegro",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Netherlands:JurisdictionStruct = JurisdictionStruct(name:"Netherlands",code:"NL",country:"Netherlands",type:.country,region:.country,flagImgName:"Netherlands",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let NorthMacedonia:JurisdictionStruct = JurisdictionStruct(name:"North Macedonia",code:"MK",country:"North Macedonia, Formerly Macedonia",type:.country,region:.country,flagImgName:"Macedonia",currency:"Macedonia Denar",currencyCode:"MKD",currencySymbol:"ден")
                static let Norway:JurisdictionStruct = JurisdictionStruct(name:"Norway",code:"NO",country:"Norway",type:.country,region:.country,flagImgName:"Norway",currency:"Norwegian Krone",currencyCode:"NOK",currencySymbol:"kr")
                static let Poland:JurisdictionStruct = JurisdictionStruct(name:"Poland",code:"PL",country:"Poland",type:.country,region:.country,flagImgName:"Poland",currency:"Poland Zloty",currencyCode:"PLN",currencySymbol:"zł")
                static let Portugal:JurisdictionStruct = JurisdictionStruct(name:"Portugal",code:"PT",country:"Portugal",type:.country,region:.country,flagImgName:"Portugal",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Romania:JurisdictionStruct = JurisdictionStruct(name:"Romania",code:"RO",country:"Romania",type:.country,region:.country,flagImgName:"Romania",currency:"Romania New Leu",currencyCode:"RON",currencySymbol:"lei")
                static let Russia:JurisdictionStruct = JurisdictionStruct(name:"Russia",code:"RU",country:"Russian Federation",type:.country,region:.country,flagImgName:"Russia",currency:"Russia Ruble",currencyCode:"RUB",currencySymbol:"₽")
                static let SanMarino:JurisdictionStruct = JurisdictionStruct(name:"San Marino",code:"SM",country:"San Marino",type:.country,region:.country,flagImgName:"SanMarino",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Serbia:JurisdictionStruct = JurisdictionStruct(name:"Serbia",code:"RS",country:"Serbia",type:.country,region:.country,flagImgName:"Serbia",currency:"Serbia Dinar",currencyCode:"RSD",currencySymbol:"RSD")
                static let Slovakia:JurisdictionStruct = JurisdictionStruct(name:"Slovakia",code:"SK",country:"Slovakia",type:.country,region:.country,flagImgName:"Slovakia",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Slovenia:JurisdictionStruct = JurisdictionStruct(name:"Slovenia",code:"SI",country:"Slovenia",type:.country,region:.country,flagImgName:"Slovenia",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Spain:JurisdictionStruct = JurisdictionStruct(name:"Spain",code:"ES",country:"Espania",type:.country,region:.country,flagImgName:"Spain",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Sweden:JurisdictionStruct = JurisdictionStruct(name:"Sweden",code:"SE",country:"Sweden",type:.country,region:.country,flagImgName:"Sweden",currency:"Sweden Krona",currencyCode:"SEK",currencySymbol:"kr")
                static let Switzerland:JurisdictionStruct = JurisdictionStruct(name:"Switzerland",code:"CH",country:"Switzerland",type:.country,region:.country,flagImgName:"Switzerland",currency:"Swiss Franc",currencyCode:"CHF",currencySymbol:"CHF")
                static let Turkey:JurisdictionStruct = JurisdictionStruct(name:"Turkey",code:"TR",country:"Turkey",type:.country,region:.country,flagImgName:"Turkey",currency:"Turkey Lira",currencyCode:"TRY",currencySymbol:"₺")
                static let Ukraine:JurisdictionStruct = JurisdictionStruct(name:"Ukraine",code:"UA",country:"Ukraine",type:.country,region:.country,flagImgName:"Ukraine",currency:"Ukraine Hryvna",currencyCode:"UAH",currencySymbol:"₴")
                static let UnitedKingdom:JurisdictionStruct = JurisdictionStruct(name:"United Kingdom",code:"GB",country:"United Kingdom",type:.country,region:.country,flagImgName:"UnitedKingdom",currency:"Pound Sterling",currencyCode:"GBP",currencySymbol:"£")
                static let VaticanCity:JurisdictionStruct = JurisdictionStruct(name:"Vatican City",code:"VA",country:"Holy See (Vatican City State)",type:.country,region:.country,flagImgName:"VaticanCity",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
            }
            
            struct Asia {
                static let all:[JurisdictionStruct] = [
                    Afghanistan,Bahrain,Bangladesh,Bhutan,Brunei,Cambodia,China,India,Indonesia,Iran,Iraq,Israel,
                    Japan,Jordan,Kuwait,Krygystan,Laos,Lebanon,Malaysia,Maldives,Mongolia,Myanmar,Nepal,NorthKorea,
                    Oman,Pakistan,Philippines,Qatar,SaudiArabia,Singapore,SouthKorea,SriLanka,Syria,Taiwan,Tajikistan,
                    Thailand,TimorLeste,Turkmenistan,UnitedArabEmirates,Uzbekistan,Vietnam,Yemen
                ].sorted(by: { ($0.name < $1.name) })

                static let Afghanistan:JurisdictionStruct = JurisdictionStruct(name:"Afghanistan",code:"AF",country:"Afghanistan",type:.country,region:.country,flagImgName:"Afghanistan",currency:"Afghanistan Afghanis",currencyCode:"AFN",currencySymbol:"؋")
                static let Bahrain:JurisdictionStruct = JurisdictionStruct(name:"Bahrain",code:"BH",country:"Bahrain",type:.country,region:.country,flagImgName:"Bahrain",currency:"Bahraini Dinar",currencyCode:"BHD",currencySymbol:"BD")
                static let Bangladesh:JurisdictionStruct = JurisdictionStruct(name:"Bangladesh",code:"BD",country:"Bangladesh",type:.country,region:.country,flagImgName:"Bangladesh",currency:"Taka",currencyCode:"BDT",currencySymbol:"৳")
                static let Bhutan:JurisdictionStruct = JurisdictionStruct(name:"Bhutan",code:"BT",country:"Bhutan",type:.country,region:.country,flagImgName:"Bhutan",currency:"Bhutanese ngultrum",currencyCode:"BTN",currencySymbol:"BTN")
                static let Brunei:JurisdictionStruct = JurisdictionStruct(name:"Brunei",code:"BN",country:"Brunei Darussalam",type:.country,region:.country,flagImgName:"Brunei",currency:"Brunei Darussalam Dollar",currencyCode:"BND",currencySymbol:"$")
                static let Cambodia:JurisdictionStruct = JurisdictionStruct(name:"Cambodia",code:"KH",country:"Cambodia",type:.country,region:.country,flagImgName:"Cambodia",currency:"Cambodia Riel",currencyCode:"KHR",currencySymbol:"KHR")
                static let China:JurisdictionStruct = JurisdictionStruct(name:"China",code:"CN",country:"China",type:.country,region:.country,flagImgName:"China",currency:"China Yuan Renminbi",currencyCode:"CNY",currencySymbol:"¥")
                static let India:JurisdictionStruct = JurisdictionStruct(name:"India",code:"IN",country:"India",type:.country,region:.country,flagImgName:"India",currency:"India Rupee",currencyCode:"INR",currencySymbol:"₨")
                static let Indonesia:JurisdictionStruct = JurisdictionStruct(name:"Indonesia",code:"ID",country:"Indonesia",type:.country,region:.country,flagImgName:"Indonesia",currency:"Indonesia Rupiah",currencyCode:"IDR",currencySymbol:"Rp")
                static let Iran:JurisdictionStruct = JurisdictionStruct(name:"Iran",code:"IR",country:"Iran, Islamic Replubli Of",type:.country,region:.country,flagImgName:"Iran",currency:"Iran Rial",currencyCode:"IRR",currencySymbol:"﷼")
                static let Iraq:JurisdictionStruct = JurisdictionStruct(name:"Iraq",code:"IQ",country:"Iraq",type:.country,region:.country,flagImgName:"Iraq",currency:"Iraqi Dinar",currencyCode:"IQD",currencySymbol:"IQD")
                static let Israel:JurisdictionStruct = JurisdictionStruct(name:"Israel",code:"IL",country:"Isreal",type:.country,region:.country,flagImgName:"Israel",currency:"Israel Shekel",currencyCode:"ILS",currencySymbol:"₪")
                static let Japan:JurisdictionStruct = JurisdictionStruct(name:"Japan",code:"JP",country:"Japan",type:.country,region:.country,flagImgName:"Japan",currency:"Japan Yen",currencyCode:"JPY",currencySymbol:"¥")
                static let Jordan:JurisdictionStruct = JurisdictionStruct(name:"Jordan",code:"JO",country:"Jordan",type:.country,region:.country,flagImgName:"Jordan",currency:"Jordanian Dinar",currencyCode:"JOD",currencySymbol:"JD")
                static let Kuwait:JurisdictionStruct = JurisdictionStruct(name:"Kuwait",code:"KW",country:"Kuwait",type:.country,region:.country,flagImgName:"Kuwait",currency:"Kuwaiti Dinar",currencyCode:"KWD",currencySymbol:"KD")
                static let Krygystan:JurisdictionStruct = JurisdictionStruct(name:"Krygystan",code:"KG",country:"Krygystan",type:.country,region:.country,flagImgName:"Kyrgyzstan",currency:"Kyrgyzstan Som",currencyCode:"KGS",currencySymbol:"KGS")
                static let Laos:JurisdictionStruct = JurisdictionStruct(name:"Laos",code:"LA",country:"Laos People's Republic Of",type:.country,region:.country,flagImgName:"Laos",currency:"Laos Kip",currencyCode:"LAK",currencySymbol:"₭")
                static let Lebanon:JurisdictionStruct = JurisdictionStruct(name:"Lebanon",code:"LB",country:"Lebanon",type:.country,region:.country,flagImgName:"Lebanon",currency:"Lebanon Pound",currencyCode:"LBP",currencySymbol:"£")
                static let Malaysia:JurisdictionStruct = JurisdictionStruct(name:"Malaysia",code:"MY",country:"Malaysia",type:.country,region:.country,flagImgName:"Malaysia",currency:"Malaysia Ringgit",currencyCode:"MYR",currencySymbol:"RM")
                static let Maldives:JurisdictionStruct = JurisdictionStruct(name:"Maldives",code:"MV",country:"Maldives",type:.country,region:.country,flagImgName:"Maldives",currency:"Rufiyaa",currencyCode:"MVR",currencySymbol:"Rf")
                static let Mongolia:JurisdictionStruct = JurisdictionStruct(name:"Mongolia",code:"MN",country:"Mongolia",type:.country,region:.country,flagImgName:"Mongolia",currency:"Mongolia Tughrik",currencyCode:"MNT",currencySymbol:"₮")
                static let Myanmar:JurisdictionStruct = JurisdictionStruct(name:"Myanmar",code:"MM",country:"Myanmar formerly Burma",type:.country,region:.country,flagImgName:"Myanmar",currency:"Kyat",currencyCode:"MMK",currencySymbol:"Ks")
                static let Nepal:JurisdictionStruct = JurisdictionStruct(name:"Nepal",code:"NP",country:"Nepal",type:.country,region:.country,flagImgName:"Nepal",currency:"Nepal Rupee",currencyCode:"NPR",currencySymbol:"₨")
                static let NorthKorea:JurisdictionStruct = JurisdictionStruct(name:"North Korea",code:"KP",country:"Democratic People's Republic of",type:.country,region:.country,flagImgName:"KoreaNorth",currency:"Korea (North) Won",currencyCode:"KPW",currencySymbol:"₩")
                static let Oman:JurisdictionStruct = JurisdictionStruct(name:"Oman",code:"OM",country:"Oman",type:.country,region:.country,flagImgName:"Oman",currency:"Oman Rial",currencyCode:"OMR",currencySymbol:"﷼")
                static let Pakistan:JurisdictionStruct = JurisdictionStruct(name:"Pakistan",code:"PK",country:"Pakistan",type:.country,region:.country,flagImgName:"Pakistan",currency:"Pakistan Rupee",currencyCode:"PKR",currencySymbol:"₨")
                static let Philippines:JurisdictionStruct = JurisdictionStruct(name:"Philippines",code:"PH",country:"Philippines",type:.country,region:.country,flagImgName:"Philippines",currency:"Philippines Peso",currencyCode:"PHP",currencySymbol:"₱")
                static let Qatar:JurisdictionStruct = JurisdictionStruct(name:"Qatar",code:"QA",country:"Qatar",type:.country,region:.country,flagImgName:"Qatar",currency:"Qatar Riyal",currencyCode:"QAR",currencySymbol:"﷼")
                static let SaudiArabia:JurisdictionStruct = JurisdictionStruct(name:"Saudi Arabia",code:"SA",country:"Saudi Arabia",type:.country,region:.country,flagImgName:"SaudiArabia",currency:"Saudi Arabia Riyal",currencyCode:"SAR",currencySymbol:"﷼")
                static let Singapore:JurisdictionStruct = JurisdictionStruct(name:"Singapore",code:"SG",country:"Singapore",type:.country,region:.country,flagImgName:"Singapore",currency:"Singapore Dollar",currencyCode:"SGD",currencySymbol:"$")
                static let SouthKorea:JurisdictionStruct = JurisdictionStruct(name:"South Korea",code:"KR",country:"Korea, Republic Of",type:.country,region:.country,flagImgName:"KoreaSouth",currency:"Korea (South) Won",currencyCode:"KRW",currencySymbol:"₩")
                static let SriLanka:JurisdictionStruct = JurisdictionStruct(name:"Sri Lanka",code:"LK",country:"Sri Lanka",type:.country,region:.country,flagImgName:"SriLanka",currency:"Sri Lanka Rupee",currencyCode:"LKR",currencySymbol:"₨")
                static let Syria:JurisdictionStruct = JurisdictionStruct(name:"Syria",code:"SY",country:"Syrian Arab republic",type:.country,region:.country,flagImgName:"Syria",currency:"Syria Pound",currencyCode:"SYP",currencySymbol:"£")
                static let Taiwan:JurisdictionStruct = JurisdictionStruct(name:"Taiwan",code:"TW",country:"Taiwan, Province of China",type:.country,region:.country,flagImgName:"Taiwan",currency:"Taiwan New Dollar",currencyCode:"TWD",currencySymbol:"NT$")
                static let Tajikistan:JurisdictionStruct = JurisdictionStruct(name:"Tajikistan",code:"TJ",country:"Tajikistan",type:.country,region:.country,flagImgName:"Tajikistan",currency:"Somoni",currencyCode:"TJS",currencySymbol:"T")
                static let Thailand:JurisdictionStruct = JurisdictionStruct(name:"Thailand",code:"TH",country:"Thailand",type:.country,region:.country,flagImgName:"Thailand",currency:"Thailand Baht",currencyCode:"THB",currencySymbol:"฿")
                static let TimorLeste:JurisdictionStruct = JurisdictionStruct(name:"Timor-Leste",code:"TL",country:"Democratic Republic of Timor-Leste",type:.country,region:.country,flagImgName:"Timor-Leste",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                static let Turkmenistan:JurisdictionStruct = JurisdictionStruct(name:"Turkmenistan",code:"TM",country:"Turkmenistan",type:.country,region:.country,flagImgName:"Turkmenistan",currency:"Turkmenistan New Manat",currencyCode:"TMT",currencySymbol:"T")
                static let UnitedArabEmirates:JurisdictionStruct = JurisdictionStruct(name:"United Arab Emirates",code:"AE",country:"United Arab Emirates",type:.country,region:.country,flagImgName:"UnitedArabEmirates",currency:"UAE Dirham",currencyCode:"AED",currencySymbol:"د.إ")
                static let Uzbekistan:JurisdictionStruct = JurisdictionStruct(name:"Uzbekistan",code:"UZ",country:"Uzbekistan",type:.country,region:.country,flagImgName:"Uzbekistan",currency:"Uzbekistan Som",currencyCode:"UZS",currencySymbol:"UZS")
                static let Vietnam:JurisdictionStruct = JurisdictionStruct(name:"Vietnam",code:"VN",country:"Viet Nam",type:.country,region:.country,flagImgName:"Vietnam",currency:"Viet Nam Dong",currencyCode:"VND",currencySymbol:"₫")
                static let Yemen:JurisdictionStruct = JurisdictionStruct(name:"Yemen",code:"YE",country:"Yemen",type:.country,region:.country,flagImgName:"Yemen",currency:"Yemen Rial",currencyCode:"YER",currencySymbol:"﷼")
            }
            
            struct AustraliaOceania {
                static let all:[JurisdictionStruct] = [
                    Australia,CookIslands,Fiji,FrenchPolynesia,Kiribati,Nauru,Niue,NewCaledonia,NewZealand,
                    NorfolkIsland,PapuaNewGuinea,PitcairnIsland,Samoa,SolomonIslands,Tokelau,Tonga,Tuvalu,
                    Vanuatu,WallisAndFutuna
                ].sorted(by: { ($0.name < $1.name) })

                static let Australia:JurisdictionStruct = JurisdictionStruct(name:"Australia",code:"AU",country:"Australia",type:.country,region:.country,flagImgName:"Australia",currency:"Australia Dollar",currencyCode:"AUD",currencySymbol:"$")
                static let CookIslands:JurisdictionStruct = JurisdictionStruct(name:"Cook Islands",code:"CK",country:"Cook Islands",type:.country,region:.country,flagImgName:"CookIslands",currency:"New Zealand Dollar",currencyCode:"NZD",currencySymbol:"$")
                static let Fiji:JurisdictionStruct = JurisdictionStruct(name:"Fiji",code:"FJ",country:"Fiji",type:.country,region:.country,flagImgName:"Fiji",currency:"Fiji Dollar",currencyCode:"FJD",currencySymbol:"$")
                static let FrenchPolynesia:JurisdictionStruct = JurisdictionStruct(name:"French Polynesia",code:"PF",country:"French Polynesia",type:.country,region:.country,flagImgName:"FrenchPolynesia",currency:"CFP Franc",currencyCode:"XPF",currencySymbol:"₣")
                static let Kiribati:JurisdictionStruct = JurisdictionStruct(name:"Kiribati",code:"KI",country:"Kiribati",type:.country,region:.country,flagImgName:"Kiribati",currency:"Australia Dollar",currencyCode:"AUD",currencySymbol:"$")
                static let Nauru:JurisdictionStruct = JurisdictionStruct(name:"Nauru",code:"NR",country:"Nauru",type:.country,region:.country,flagImgName:"Nauru",currency:"Australia Dollar",currencyCode:"AUD",currencySymbol:"$")
                static let Niue:JurisdictionStruct = JurisdictionStruct(name:"Niue",code:"NU",country:"Niue",type:.country,region:.country,flagImgName:"Niue",currency:"New Zealand Dollar",currencyCode:"NZD",currencySymbol:"$")
                static let NewCaledonia:JurisdictionStruct = JurisdictionStruct(name:"New Caledonia",code:"NC",country:"New Caledonia",type:.country,region:.country,flagImgName:"NewCaledonia",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let NewZealand:JurisdictionStruct = JurisdictionStruct(name:"New Zealand",code:"NZ",country:"New Zealand",type:.country,region:.country,flagImgName:"NewZealand",currency:"New Zealand Dollar",currencyCode:"NZD",currencySymbol:"$")
                static let NorfolkIsland:JurisdictionStruct = JurisdictionStruct(name:"Norfolk Island",code:"NF",country:"Norfolk Island",type:.country,region:.country,flagImgName:"NorfolkIsland",currency:"Australia Dollar",currencyCode:"AUD",currencySymbol:"$")
                static let PapuaNewGuinea:JurisdictionStruct = JurisdictionStruct(name:"Papua New Guinea",code:"PG",country:"Papua New Guinea",type:.country,region:.country,flagImgName:"PapuaNewGuinea",currency:"Kina",currencyCode:"PGK",currencySymbol:"K")
                static let Samoa:JurisdictionStruct = JurisdictionStruct(name:"Samoa",code:"WS",country:"Samoa",type:.country,region:.country,flagImgName:"Samoa",currency:"Tala",currencyCode:"WST",currencySymbol:"WS$")
                static let SolomonIslands:JurisdictionStruct = JurisdictionStruct(name:"Solomon Islands",code:"SB",country:"Solomon Islands",type:.country,region:.country,flagImgName:"SolomonIslands",currency:"Solomon Islands Dollar",currencyCode:"SBD",currencySymbol:"$")
                static let Tonga:JurisdictionStruct = JurisdictionStruct(name:"Tonga",code:"TO",country:"Tonga",type:.country,region:.country,flagImgName:"Tonga",currency:"Pa'Anga",currencyCode:"TOP",currencySymbol:"T$")
                static let Tuvalu:JurisdictionStruct = JurisdictionStruct(name:"Tuvalu",code:"TV",country:"Tuvalu",type:.country,region:.country,flagImgName:"Tuvalu",currency:"Tuvalu Dollar",currencyCode:"AUD",currencySymbol:"$")
                static let Vanuatu:JurisdictionStruct = JurisdictionStruct(name:"Vanuatu",code:"VU",country:"Vanuatu",type:.country,region:.country,flagImgName:"Vanuatu",currency:"Vanuatu Vatu",currencyCode:"VUV",currencySymbol:"VT")
                static let PitcairnIsland:JurisdictionStruct = JurisdictionStruct(name:"Pitcairn Island",code:"PN",country:"Pitcairn Island",type:.country,region:.country,flagImgName:"PitcairnIslands",currency:"New Zealand Dollar",currencyCode:"NZD",currencySymbol:"$")
                static let Tokelau:JurisdictionStruct = JurisdictionStruct(name:"Tokelau",code:"TK",country:"Tokelau",type:.country,region:.country,flagImgName:"Tokelau",currency:"New Zealand Dollar",currencyCode:"NZD",currencySymbol:"$")
                static let WallisAndFutuna:JurisdictionStruct = JurisdictionStruct(name:"Wallis and Futuna",code:"WF",country:"Wallis and Futuna",type:.country,region:.country,flagImgName:"WallisAndFutuna",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
            }

            struct Africa {
                static let all:[JurisdictionStruct] = [
                    Algeria,Angola,Benin,Botswana,BurkinaFaso,Burundi,CapeVerde,Cameroon,CentralAfricanRepublic,
                    Chad,Comoros,CongoDemocraticRepublic,CongoRepublic,IvoryCoast,Djibouti,Egypt,EquatorialGuinea,
                    Eritrea,Eswatini,Ethiopia,Gabon,Gambia,Ghana,Guinea,GuineaBissau,Kenya,Lesotho,Liberia,Libya,
                    Madagascar,Malawi,Mauritania,Mauritius,Morocco,Mozambique,Namimbia,Niger,Nigeria,Rwanda,
                    SaoTomeAndPrincipe,Senegal,Seychelles,SierraLeone,Somalia,SouthAfrica,SouthSudan,Sudan,Tanzania,
                    Togo,Tunisia,Uganda,Zambia,Zimbabwe
                ].sorted(by: { ($0.name < $1.name) })

                static let Algeria:JurisdictionStruct = JurisdictionStruct(name:"Algeria",code:"DZ",country:"Algeria",type:.country,region:.country,flagImgName:"Algeria",currency:"Algeria Dinar",currencyCode:"DZD",currencySymbol:"DA")
                static let Angola:JurisdictionStruct = JurisdictionStruct(name:"Angola",code:"AO",country:"Angola",type:.country,region:.country,flagImgName:"Angola",currency:"Angola Kwnaza",currencyCode:"AOA",currencySymbol:"Kz")
                static let Benin:JurisdictionStruct = JurisdictionStruct(name:"Benin",code:"BJ",country:"Benin",type:.country,region:.country,flagImgName:"Benin",currency:"West African CFA Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Botswana:JurisdictionStruct = JurisdictionStruct(name:"Botswana",code:"BW",country:"Botswana",type:.country,region:.country,flagImgName:"Botswana",currency:"Botswana Pula",currencyCode:"BWP",currencySymbol:"P")
                static let BurkinaFaso:JurisdictionStruct = JurisdictionStruct(name:"Burkina Faso",code:"BF",country:"Burkina Faso",type:.country,region:.country,flagImgName:"BurkinaFaso",currency:"West African CFA Franc",currencyCode:"XOF",currencySymbol:"CFA")
                static let Burundi:JurisdictionStruct = JurisdictionStruct(name:"Burundi",code:"BI",country:"Burundi",type:.country,region:.country,flagImgName:"Burundi",currency:"Burundi Franc",currencyCode:"BIF",currencySymbol:"₣")
                static let CapeVerde:JurisdictionStruct = JurisdictionStruct(name:"Cape Verde",code:"CV",country:"Cape Verde",type:.country,region:.country,flagImgName:"CapeVerdeIslands",currency:"Cape Verde Escudo",currencyCode:"CVE",currencySymbol:"$")
                static let Cameroon:JurisdictionStruct = JurisdictionStruct(name:"Cameroon",code:"CM",country:"Cameroon",type:.country,region:.country,flagImgName:"Cameroon",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let CentralAfricanRepublic:JurisdictionStruct = JurisdictionStruct(name:"Central African Republic",code:"CF",country:"Central African Republic",type:.country,region:.country,flagImgName:"CentralAfricanRepublic",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Chad:JurisdictionStruct = JurisdictionStruct(name:"Chad",code:"TD",country:"Chad",type:.country,region:.country,flagImgName:"Chad",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Comoros:JurisdictionStruct = JurisdictionStruct(name:"Comoros",code:"KM",country:"Comoros",type:.country,region:.country,flagImgName:"Comoros",currency:"Comorian Franc",currencyCode:"KMF",currencySymbol:"KMF")
                static let CongoDemocraticRepublic:JurisdictionStruct = JurisdictionStruct(name:"Congo, Democratic Republic of",code:"CD",country:"Congo, Democratic Republic Of",type:.country,region:.country,flagImgName:"CongoDemRep",currency:"Congolese Franc",currencyCode:"CDF",currencySymbol:"CDF")
                static let CongoRepublic:JurisdictionStruct = JurisdictionStruct(name:"Congo, Republic of",code:"CG",country:"Congo",type:.country,region:.country,flagImgName:"CongoRepublic",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let IvoryCoast:JurisdictionStruct = JurisdictionStruct(name:"Ivory Coast",code:"CI",country:"Cote D'Ivoire",type:.country,region:.country,flagImgName:"IvoryCoast",currency:"West African CFA Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Djibouti:JurisdictionStruct = JurisdictionStruct(name:"Djibouti",code:"DJ",country:"Djibouti",type:.country,region:.country,flagImgName:"Djibouti",currency:"Djibouti Franc",currencyCode:"DJF",currencySymbol:"Fdj")
                static let Egypt:JurisdictionStruct = JurisdictionStruct(name:"Egypt",code:"EG",country:"Egypt",type:.country,region:.country,flagImgName:"Egypt",currency:"Egypt Pound",currencyCode:"EGP",currencySymbol:"£")
                static let EquatorialGuinea:JurisdictionStruct = JurisdictionStruct(name:"Equatorial Guinea",code:"GQ",country:"Equatorial Guinea",type:.country,region:.country,flagImgName:"EquatorialGuinea",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Eritrea:JurisdictionStruct = JurisdictionStruct(name:"Eritrea",code:"ER",country:"Eritrea",type:.country,region:.country,flagImgName:"Eritrea",currency:"Eritrea Nakfa",currencyCode:"ERN",currencySymbol:"ERN")
                static let Eswatini:JurisdictionStruct = JurisdictionStruct(name:"Eswatini",code:"SZ",country:"Eswatini, formerly Swaziland",type:.country,region:.country,flagImgName:"Swaziland",currency:"Lilangeni",currencyCode:"SZL",currencySymbol:"L")
                static let Ethiopia:JurisdictionStruct = JurisdictionStruct(name:"Ethiopia",code:"ET",country:"Ethiopia",type:.country,region:.country,flagImgName:"Ethiopia",currency:"Ehtiopia Birr",currencyCode:"ETB",currencySymbol:"ETB")
                static let Gabon:JurisdictionStruct = JurisdictionStruct(name:"Gabon",code:"GA",country:"Gabon",type:.country,region:.country,flagImgName:"Gabon",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Gambia:JurisdictionStruct = JurisdictionStruct(name:"Gambia",code:"GM",country:"Gambia",type:.country,region:.country,flagImgName:"Gambia",currency:"Dalasi",currencyCode:"GMD",currencySymbol:"D")
                static let Ghana:JurisdictionStruct = JurisdictionStruct(name:"Ghana",code:"GH",country:"Ghana",type:.country,region:.country,flagImgName:"Ghana",currency:"Ghana Cedis",currencyCode:"GHS",currencySymbol:"₵")
                static let Guinea:JurisdictionStruct = JurisdictionStruct(name:"Guinea",code:"GN",country:"Guinea",type:.country,region:.country,flagImgName:"Guinea",currency:"Guinea Franc",currencyCode:"GNF",currencySymbol:"GF")
                static let GuineaBissau:JurisdictionStruct = JurisdictionStruct(name:"Guinea-Bissau",code:"GW",country:"Guinea-Bissau",type:.country,region:.country,flagImgName:"Guinea-Bissau",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Kenya:JurisdictionStruct = JurisdictionStruct(name:"Kenya",code:"KE",country:"Kenya",type:.country,region:.country,flagImgName:"Kenya",currency:"Kenyan Shilling",currencyCode:"KES",currencySymbol:"KSh")
                static let Lesotho:JurisdictionStruct = JurisdictionStruct(name:"Lesotho",code:"LS",country:"Lesotho",type:.country,region:.country,flagImgName:"Liberia",currency:"Loti",currencyCode:"LSL",currencySymbol:"L")
                static let Liberia:JurisdictionStruct = JurisdictionStruct(name:"Liberia",code:"LR",country:"Liberia",type:.country,region:.country,flagImgName:"Liberia",currency:"Liberia Dollar",currencyCode:"LRD",currencySymbol:"$")
                static let Libya:JurisdictionStruct = JurisdictionStruct(name:"Libya",code:"LY",country:"Libya",type:.country,region:.country,flagImgName:"Libya",currency:"Libyan Dinar",currencyCode:"LYD",currencySymbol:"LD")
                static let Madagascar:JurisdictionStruct = JurisdictionStruct(name:"Madagascar",code:"MG",country:"Madagascar",type:.country,region:.country,flagImgName:"Madagascar",currency:"Malagasy Ariary",currencyCode:"MGA",currencySymbol:"Ar")
                static let Malawi:JurisdictionStruct = JurisdictionStruct(name:"Malawi",code:"MW",country:"Malawi",type:.country,region:.country,flagImgName:"Malawi",currency:"Kwacha",currencyCode:"MWK",currencySymbol:"ZK")
                static let Mali:JurisdictionStruct = JurisdictionStruct(name:"Mali",code:"ML",country:"Mali",type:.country,region:.country,flagImgName:"Mali",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Mauritania:JurisdictionStruct = JurisdictionStruct(name:"Mauritania",code:"MR",country:"Mauritania",type:.country,region:.country,flagImgName:"Mauritania",currency:"Mauritanian Ouguiya",currencyCode:"MRO",currencySymbol:"UM")
                static let Mauritius:JurisdictionStruct = JurisdictionStruct(name:"Mauritius",code:"MU",country:"Mauritius",type:.country,region:.country,flagImgName:"Mauritius",currency:"Mauritius Rupee",currencyCode:"MUR",currencySymbol:"₨")
                static let Morocco:JurisdictionStruct = JurisdictionStruct(name:"Morocco",code:"MA",country:"Morocco",type:.country,region:.country,flagImgName:"Morocco",currency:"Moroccan Dirham",currencyCode:"MAD",currencySymbol:"MAD")
                static let Mozambique:JurisdictionStruct = JurisdictionStruct(name:"Mozambique",code:"MZ",country:"Mozambique",type:.country,region:.country,flagImgName:"Mozambique",currency:"Mozambique Metical",currencyCode:"MZN",currencySymbol:"MT")
                static let Namimbia:JurisdictionStruct = JurisdictionStruct(name:"Namimbia",code:"NA",country:"Namimbia",type:.country,region:.country,flagImgName:"Namibia",currency:"Namibia Dollar",currencyCode:"NAD",currencySymbol:"$")
                static let Niger:JurisdictionStruct = JurisdictionStruct(name:"Niger",code:"NE",country:"Niger",type:.country,region:.country,flagImgName:"Niger",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Nigeria:JurisdictionStruct = JurisdictionStruct(name:"Nigeria",code:"NG",country:"Nigeria",type:.country,region:.country,flagImgName:"Nigeria",currency:"Nigeria Naira",currencyCode:"NGN",currencySymbol:"₦")
                static let Rwanda:JurisdictionStruct = JurisdictionStruct(name:"Rwanda",code:"RW",country:"Rwanda",type:.country,region:.country,flagImgName:"Rwanda",currency:"Rwanda Franc",currencyCode:"RWF",currencySymbol:"FRw")
                static let SaoTomeAndPrincipe:JurisdictionStruct = JurisdictionStruct(name:"Sao Tome and Principe",code:"ST",country:"Sao Tome and Principe",type:.country,region:.country,flagImgName:"SaoTomeAndPrincipe",currency:"Dobra",currencyCode:"STD",currencySymbol:"Db")
                static let Senegal:JurisdictionStruct = JurisdictionStruct(name:"Senegal",code:"SN",country:"Senegal",type:.country,region:.country,flagImgName:"Senegal",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Seychelles:JurisdictionStruct = JurisdictionStruct(name:"Seychelles",code:"SC",country:"Seychelles",type:.country,region:.country,flagImgName:"Seychelles",currency:"Seychelles Rupee",currencyCode:"SCR",currencySymbol:"₨")
                static let SierraLeone:JurisdictionStruct = JurisdictionStruct(name:"Sierra Leone",code:"SL",country:"Sierra Leone",type:.country,region:.country,flagImgName:"SierraLeone",currency:"Leone",currencyCode:"SLL",currencySymbol:"Le")
                static let Somalia:JurisdictionStruct = JurisdictionStruct(name:"Somalia",code:"SO",country:"Somalia",type:.country,region:.country,flagImgName:"Somalia",currency:"Somalia Shilling",currencyCode:"SOS",currencySymbol:"S")
                static let SouthAfrica:JurisdictionStruct = JurisdictionStruct(name:"South Africa",code:"ZA",country:"South Africa",type:.country,region:.country,flagImgName:"SouthAfrica",currency:"South Africa Rand",currencyCode:"ZAR",currencySymbol:"R")
                static let SouthSudan:JurisdictionStruct = JurisdictionStruct(name:"South Sudan",code:"SS",country:"Republic of South Sudan",type:.country,region:.country,flagImgName:"SouthSudan",currency:"Sudanese Pound",currencyCode:"SDG",currencySymbol:"£")
                static let Sudan:JurisdictionStruct = JurisdictionStruct(name:"Sudan",code:"SD",country:"Sudan",type:.country,region:.country,flagImgName:"Sudan",currency:"Sudanese Pound",currencyCode:"SDG",currencySymbol:"£")
                static let Tanzania:JurisdictionStruct = JurisdictionStruct(name:"Tanzania",code:"TZ",country:"Tanzania, United Republic Of",type:.country,region:.country,flagImgName:"Tanzania",currency:"Tanzanian Shilling",currencyCode:"TZS",currencySymbol:"x/y")
                static let Togo:JurisdictionStruct = JurisdictionStruct(name:"Togo",code:"TG",country:"Togo",type:.country,region:.country,flagImgName:"Togo",currency:"Central African Franc",currencyCode:"XAF",currencySymbol:"CFA")
                static let Tunisia:JurisdictionStruct = JurisdictionStruct(name:"Tunisia",code:"TN",country:"Tunisia",type:.country,region:.country,flagImgName:"Tunisia",currency:"Tunisian Dinar",currencyCode:"TND",currencySymbol:"DT")
                static let Uganda:JurisdictionStruct = JurisdictionStruct(name:"Uganda",code:"UG",country:"Uganda",type:.country,region:.country,flagImgName:"Uganda",currency:"Uganda Shilling",currencyCode:"UGX",currencySymbol:"USh")
                static let Zambia:JurisdictionStruct = JurisdictionStruct(name:"Zambia",code:"ZM",country:"Zambia",type:.country,region:.country,flagImgName:"Zambia",currency:"Zambia Kwacha",currencyCode:"ZMK",currencySymbol:"ZMK")
                static let Zimbabwe:JurisdictionStruct = JurisdictionStruct(name:"Zimbabwe",code:"ZW",country:"Zimbabwe",type:.country,region:.country,flagImgName:"Zimbabwe",currency:"Zimbabwe Dollar",currencyCode:"ZWL",currencySymbol:"Z$")
            }

            struct Carribean {
                static let all:[JurisdictionStruct] = (Independent.all + Dependent.all).sorted(by: { ($0.name < $1.name) })

                struct Independent {
                    static let AntiguaAndBarbuda:JurisdictionStruct = JurisdictionStruct(name:"Antigua and Barbuda",code:"AG",country:"Antigua and Barbuda",type:.country,region:.country,flagImgName:"AntiguaAndBarbuda",currency:"East Caribbean Dollar",currencyCode:"XCD",currencySymbol:"$")
                    static let Bahamas:JurisdictionStruct = JurisdictionStruct(name:"Bahamas",code:"BS",country:"Bahamas",type:.country,region:.country,flagImgName:"Bahamas",currency:"Bahamas Dollar",currencyCode:"BSD",currencySymbol:"$")
                    static let Barbados:JurisdictionStruct = JurisdictionStruct(name:"Barbados",code:"BB",country:"Barbados",type:.country,region:.country,flagImgName:"Barbados",currency:"Barados Dollar",currencyCode:"BBD",currencySymbol:"$")
                    static let Cuba:JurisdictionStruct = JurisdictionStruct(name:"Cuba",code:"CU",country:"Cuba",type:.country,region:.country,flagImgName:"Cuba",currency:"Cuba Peso",currencyCode:"CUP",currencySymbol:"₱")
                    static let Dominica:JurisdictionStruct = JurisdictionStruct(name:"Dominica",code:"DM",country:"Dominica",type:.country,region:.country,flagImgName:"Dominica",currency:"East Caribbean Dollar",currencyCode:"XCD",currencySymbol:"$")
                    static let DominicanRepublic:JurisdictionStruct = JurisdictionStruct(name:"Dominican Republic",code:"DO",country:"Dominican Republic",type:.country,region:.country,flagImgName:"DominicanRepublic",currency:"Dominican Republic Peso",currencyCode:"DOP",currencySymbol:"RD$")
                    static let Grenada:JurisdictionStruct = JurisdictionStruct(name:"Grenada",code:"GD",country:"Grenada",type:.country,region:.country,flagImgName:"Grenada",currency:"East Caribbean Dollar",currencyCode:"XCD",currencySymbol:"$")
                    static let Haiti:JurisdictionStruct = JurisdictionStruct(name:"Haiti",code:"HT",country:"Haiti",type:.country,region:.country,flagImgName:"Haiti",currency:"Haitian Gourde",currencyCode:"HTG",currencySymbol:"G")
                    static let Jamaica:JurisdictionStruct = JurisdictionStruct(name:"Jamaica",code:"JM",country:"Jamaica",type:.country,region:.country,flagImgName:"Jamaica",currency:"Jamaica Dollar",currencyCode:"JMD",currencySymbol:"$")
                    static let SaintKittsAndNevis:JurisdictionStruct = JurisdictionStruct(name:"Saint Kitts and Nevis",code:"KN",country:"Saint Kitts and Nevis",type:.country,region:.country,flagImgName:"SaintKittsAndNevis",currency:"East Caribbean Dollar",currencyCode:"XCD",currencySymbol:"$")
                    static let SaintLucia:JurisdictionStruct = JurisdictionStruct(name:"Saint Lucia",code:"LC",country:"Saint Lucia",type:.country,region:.country,flagImgName:"SaintLucia",currency:"East Caribbean Dollar",currencyCode:"XCD",currencySymbol:"$")
                    static let SaintVincentAndTheGrenadines:JurisdictionStruct = JurisdictionStruct(name:"Saint Vincent and the Grenadines",code:"VC",country:"Saint Vincent and the Grenadines",type:.country,region:.country,flagImgName:"SaintVincentAndTheGrenadines",currency:"East Caribbean Dollar",currencyCode:"XCD",currencySymbol:"$")
                    static let TrinidadAndTobago:JurisdictionStruct = JurisdictionStruct(name:"Trinidad and Tobago",code:"TT",country:"Trinidad and Tobago",type:.country,region:.country,flagImgName:"TrinidadAndTobago",currency:"Trinidad and Tobago Dollar",currencyCode:"TTD",currencySymbol:"TT$")
                    static let all:[JurisdictionStruct] = [
                        AntiguaAndBarbuda,Bahamas,Barbados,Cuba,Dominica,DominicanRepublic,Grenada,Haiti,
                        Jamaica,SaintKittsAndNevis,SaintLucia,SaintVincentAndTheGrenadines,TrinidadAndTobago
                    ].sorted(by: { ($0.name < $1.name) })
                }

                struct Dependent {
                    static let Anguilla:JurisdictionStruct = JurisdictionStruct(name:"Anguilla",code:"AI",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"Anguilla",currency:"East Caribbean Dollar",currencyCode:"XCD",currencySymbol:"$")
                    static let Aruba:JurisdictionStruct = JurisdictionStruct(name:"Aruba",code:"AW",country:"Netherlands Antilles",type:.territory,region:.possession,flagImgName:"Aruba",currency:"Aruba Guilder",currencyCode:"AWG",currencySymbol:"ƒ")
                    static let Bermuda:JurisdictionStruct = JurisdictionStruct(name:"Bermuda",code:"BM",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"Bermuda",currency:"Bermuda Dollar",currencyCode:"BMD",currencySymbol:"$")
                    static let Bonaire:JurisdictionStruct = JurisdictionStruct(name:"Bonaire",code:"BQ-BO",country:"Netherlands Antilles",type:.territory,region:.possession,flagImgName:"Bonaire",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                    static let BritishVirginIslands:JurisdictionStruct = JurisdictionStruct(name:"British Virgin Islands",code:"VG",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"BritishVirginIslands",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                    static let CaymanIslands:JurisdictionStruct = JurisdictionStruct(name:"Cayman Islands",code:"KY",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"CaymanIslands",currency:"Cayman Islands Dollar",currencyCode:"KYD",currencySymbol:"$")
                    static let Curacao:JurisdictionStruct = JurisdictionStruct(name:"Curacao",code:"CW",country:"Netherlands Antilles",type:.territory,region:.possession,flagImgName:"Curacao",currency:"Netherlands Antillean Guilder",currencyCode:"ANG",currencySymbol:"ƒ")
                    static let Guadeloupe:JurisdictionStruct = JurisdictionStruct(name:"Guadeloupe",code:"GP",country:"France Overseas Region",type:.territory,region:.possession,flagImgName:"Guadeloupe",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                    static let Martinique:JurisdictionStruct = JurisdictionStruct(name:"Martinique",code:"MQ",country:"Netherlands Antilles",type:.territory,region:.possession,flagImgName:"Martinique",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                    static let Montserrat:JurisdictionStruct = JurisdictionStruct(name:"Montserrat",code:"MS",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"Montserrat",currency:"East Caribbean Dollar",currencyCode:"XCD",currencySymbol:"$")
                    static let Saba:JurisdictionStruct = JurisdictionStruct(name:"Saba",code:"BQ-SA",country:"Netherlands Antilles",type:.territory,region:.possession,flagImgName:"Netherlands",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                    static let SaintBarthelemy:JurisdictionStruct = JurisdictionStruct(name:"Saint Barthelemy",code:"BL",country:"France Overseas Region",type:.territory,region:.possession,flagImgName:"France",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                    static let SaintEustatius:JurisdictionStruct = JurisdictionStruct(name:"Saint Eustatius",code:"BQ-SE",country:"Netherlands Antilles",type:.territory,region:.possession,flagImgName:"Netherlands",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                    static let SaintMartin:JurisdictionStruct = JurisdictionStruct(name:"Saint Martin",code:"MF",country:"France Overseas Region",type:.territory,region:.possession,flagImgName:"France",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                    static let SaintMaartin:JurisdictionStruct = JurisdictionStruct(name:"Saint Maartin",code:"SX",country:"Netherlands Antilles",type:.territory,region:.possession,flagImgName:"SaintMartin",currency:"Netherlands Antillean Guilder",currencyCode:"ANG",currencySymbol:"NAƒ")
                    static let TurksAndCaicosIslands:JurisdictionStruct = JurisdictionStruct(name:"Turks and Caicos Islands",code:"TC",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"TurksAndCaicos",currency:"US Dollar",currencyCode:"USD",currencySymbol:"$")
                    static let all:[JurisdictionStruct] = [
                        Anguilla,Aruba,Bermuda,Bonaire,BritishVirginIslands,CaymanIslands,Curacao,Guadeloupe,
                        Martinique,Montserrat,Saba,SaintBarthelemy,SaintEustatius,SaintMartin,SaintMaartin,
                        TurksAndCaicosIslands
                    ].sorted(by: { ($0.name < $1.name) })
                }
            }
            
            struct Other {
                static let all:[JurisdictionStruct] = [
                    Gibraltar,Guernsey,HongKong,IsleofMan,Jersey,Macau,BouvetIsland,ChristmasIsland,CocosIsland,
                    FalklandIslands,FaroeIslands,Greenland,HeardAndMcDonaldIslands,Mayotte,Reunion,SaintHelena,
                    Ascension,TristanDaCunha,SaintPierreAndMiquelon,SouthGeorgia,SandwichIslands,
                    SvalbardAndJanMayen,WesternSahara
                ].sorted(by: { ($0.name < $1.name) })
                
                static let Gibraltar:JurisdictionStruct = JurisdictionStruct(name:"Gibraltar",code:"GI",country:"United Kingdom",type:.territory,region:.possession,flagImgName:"Gibraltar",currency:"Gibraltar Pound",currencyCode:"GIP",currencySymbol:"£")
                static let Guernsey:JurisdictionStruct = JurisdictionStruct(name:"Guernsey",code:"GG",country:"United Kingdom",type:.territory,region:.possession,flagImgName:"United Kingdom",currency:"Guernsey Pound",currencyCode:"GGP",currencySymbol:"£")
                static let HongKong:JurisdictionStruct = JurisdictionStruct(name:"Hong Kong",code:"HK",country:"China",type:.district,region:.possession,flagImgName:"HongKong",currency:"Hong Kong Dollar",currencyCode:"HKD",currencySymbol:"$")
                static let IsleofMan:JurisdictionStruct = JurisdictionStruct(name:"Isle of Man",code:"IM",country:"United Kingdom",type:.territory,region:.possession,flagImgName:"IsleOfMan",currency:"Isle of Man Pound",currencyCode:"IMP",currencySymbol:"£")
                static let Jersey:JurisdictionStruct = JurisdictionStruct(name:"Jersey",code:"JE",country:"United Kingdom",type:.territory,region:.possession,flagImgName:"Jersey",currency:"Jersey Pound",currencyCode:"JEP",currencySymbol:"£")
                static let Macau:JurisdictionStruct = JurisdictionStruct(name:"Macau",code:"MO",country:"China",type:.district,region:.possession,flagImgName:"Macau",currency:"Pataca",currencyCode:"MOP",currencySymbol:"MOP$")
                static let BouvetIsland:JurisdictionStruct = JurisdictionStruct(name:"Bouvet Island",code:"BV",country:"Norway",type:.territory,region:.possession,flagImgName:"Norway",currency:"Norwegian Krone",currencyCode:"NOK",currencySymbol:"kr")
                static let ChristmasIsland:JurisdictionStruct = JurisdictionStruct(name:"Christmas Island",code:"CX",country:"Australia",type:.territory,region:.possession,flagImgName:"ChristmasIsland",currency:"Australia Dollar",currencyCode:"AUD",currencySymbol:"$")
                static let CocosIsland:JurisdictionStruct = JurisdictionStruct(name:"Cocos Island",code:"CC",country:"Costa Rico",type:.territory,region:.possession,flagImgName:"CocosKeelingIslands",currency:"Australia Dollar",currencyCode:"AUD",currencySymbol:"$")
                static let FalklandIslands:JurisdictionStruct = JurisdictionStruct(name:"Falkland Islands",code:"FK",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"FalklandIslands",currency:"Falkland Islands (Malvinas) Pound",currencyCode:"FKP",currencySymbol:"£")
                static let FaroeIslands:JurisdictionStruct = JurisdictionStruct(name:"Faroe Islands",code:"FO",country:"United Kingdom",type:.territory,region:.possession,flagImgName:"FaroeIslands",currency:"Denmark Krona",currencyCode:"DKK",currencySymbol:"kr")
                static let Greenland:JurisdictionStruct = JurisdictionStruct(name:"Greenland",code:"GL",country:"Denmark",type:.territory,region:.possession,flagImgName:"Greenland",currency:"Danish Krone",currencyCode:"DKK",currencySymbol:"kr")
                static let HeardAndMcDonaldIslands:JurisdictionStruct = JurisdictionStruct(name:"Heard & McDonald Islands",code:"HM",country:"Australia",type:.territory,region:.possession,flagImgName:"Australia",currency:"Australia Dollar",currencyCode:"AUD",currencySymbol:"$")
                static let Mayotte:JurisdictionStruct = JurisdictionStruct(name:"Mayotte",code:"YT",country:"France",type:.territory,region:.possession,flagImgName:"Mayotte",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let Reunion:JurisdictionStruct = JurisdictionStruct(name:"Reunion",code:"RE",country:"France",type:.territory,region:.possession,flagImgName:"France",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let SaintHelena:JurisdictionStruct = JurisdictionStruct(name:"Saint Helena",code:"SH",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"SaintHelena",currency:"Saint Helena Pound",currencyCode:"SHP",currencySymbol:"£")
                static let Ascension:JurisdictionStruct = JurisdictionStruct(name:"Ascension",code:"SH",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"BritishIndianOceanTerritory",currency:"Saint Helena Pound",currencyCode:"SHP",currencySymbol:"£")
                static let TristanDaCunha:JurisdictionStruct = JurisdictionStruct(name:"Tristan Da Cunha",code:"SH",country:"British Overseas Territory",type:.territory,region:.possession,flagImgName:"BritishIndianOceanTerritory",currency:"Saint Helena Pound",currencyCode:"SHP",currencySymbol:"£")
                static let SaintPierreAndMiquelon:JurisdictionStruct = JurisdictionStruct(name:"Saint Pierre and Miquelon",code:"PM",country:"Saint Pierre and Miquelon",type:.territory,region:.possession,flagImgName:"SaintPierreAndMiquelon",currency:"Euro",currencyCode:"EUR",currencySymbol:"€")
                static let SouthGeorgia:JurisdictionStruct = JurisdictionStruct(name:"South Georgia",code:"GS",country:"South Georia and the Sandwich Islands",type:.territory,region:.possession,flagImgName:"SouthGeorgia",currency:"Pound Sterling",currencyCode:"GBP",currencySymbol:"£")
                static let SandwichIslands:JurisdictionStruct = JurisdictionStruct(name:"Sandwich Islands",code:"GS",country:"South Georia and the Sandwich Islands",type:.territory,region:.possession,flagImgName:"SouthGeorgia",currency:"Pound Sterling",currencyCode:"GBP",currencySymbol:"£")
                static let SvalbardAndJanMayen:JurisdictionStruct = JurisdictionStruct(name:"Svalbard and Jan Mayen",code:"SJ",country:"Svalbard and Jan Mayen",type:.territory,region:.possession,flagImgName:"Norway",currency:"Norwegian Krone",currencyCode:"NOK",currencySymbol:"kr")
                static let WesternSahara:JurisdictionStruct = JurisdictionStruct(name:"Western Sahara",code:"EH",country:"Western Sahara",type:.territory,region:.possession,flagImgName:"WesternSahara",currency:"Moroccan Dirham",currencyCode:"MAD",currencySymbol:"MAD")
            }
        }
    }

// MARK: ├─➤ FUNCTIONS
    func returnISO_LocaleForCountryCode(code:String) -> String {
        let itemsArray = Locale.availableIdentifiers
        
        let matchingTerms = itemsArray.filter({
            $0.range(of: code.uppercased() ) != nil
        })

        if matchingTerms.count > 0 {
            return matchingTerms.first!
        }
        
        return ""
    }
    
    func returnCurrencyInfoForCurrencyCode(code:String) -> (found:Bool,name:String,code:String,symbol:String) {
        guard let arr = (Jurisdictions.Countries.all.filter({ $0.currencyCode == code }) as [JurisdictionStruct]?) else {
            return (found:false,name:"n/a",code:"n/a",symbol:"n/a")
        }
        
        let name = arr.first?.currency ?? ""
        let code = arr.first?.currencyCode ?? ""
        let symbol = arr.first?.currencySymbol ?? ""
        
        return (found:true,name:name,code:code,symbol:symbol)
    }
    
    func returnNameForCode(code:String) -> (found:Bool,name:String) {
        guard let arr = (Jurisdictions.Countries.all.filter({ $0.code == code }) as [JurisdictionStruct]?) else {
            return (found:false,name:"")
        }
        
        let name = arr.first?.name ?? ""

        return (found:true,name:name)
    }
    
    func returnInfo(jusridiction name:String) -> (found:Bool,name:String,code:String,country:String,type:Juristype,
                                                  region:JurisRegion,flagImgName:String,currency:String,currencyCode:String,
                                                  currencySymbol:String,codeISO:String) {
            
        guard let arr = (Jurisdictions.Countries.all.filter(
            { $0.name.uppercased() == name.uppercased() ||
              $0.code.uppercased() == name.uppercased()}
            ) as [JurisdictionStruct]?)
        else {
            return (found:false,
                    name:"",
                    code:"",
                    country:"",
                    type:.unknown,
                    region:.unknown,
                    flagImgName:"",
                    currency:"",
                    currencyCode:"",
                    currencySymbol:"",
                    codeISO:"")
        }

        let name = arr.first?.name ?? ""
        let code = arr.first?.code ?? ""
        let country = arr.first?.country ?? ""
        let type = arr.first?.type ?? Juristype.unknown
        let region = arr.first?.region ?? JurisRegion.unknown
        let flagImgName = arr.first?.flagImgName ?? ""
        let currency = arr.first?.currency ?? ""
        let currencyCode = arr.first?.currencyCode ?? ""
        let currencySymbol = arr.first?.currencySymbol ?? ""
        let codeISO = arr.first?.codeISO ?? ""
        
        return (found:true,
                name:name,
                code:code,
                country:country,
                type:type,
                region:region,
                flagImgName:flagImgName,
                currency:currency,
                currencyCode:currencyCode,
                currencySymbol:currencySymbol,
                codeISO:codeISO)
    }

    func returnJurisdictionForCode(_ code:String,andType:Juristype) -> [JurisdictionStruct] {
        guard let jurisdictions = (Jurisdictions.Countries.all.filter({ $0.code == code && $0.type == andType }) as [JurisdictionStruct]?) else {
            return []
        }
        
        return jurisdictions
    }

    func returnJurisdictionsForType(_ type:Juristype) -> (found:Bool,jurisdiction:[JurisdictionStruct]) {
        guard let arr = (Jurisdictions.Countries.all.filter({ $0.type == type }) as [JurisdictionStruct]?) else {
            return (found:false, jurisdiction:[])
        }
        
        return (found:true,jurisdiction:arr)
    }
    
    func returnJurisdictionsForRegion(_ region:JurisRegion) -> (found:Bool,region:[JurisdictionStruct]) {
        guard var countries = (Jurisdictions.Countries.all.filter({ $0.region == region }) as [JurisdictionStruct]?) else {
            return (found:false, region:[])
        }

        countries.sort(by: { $0.name < $1.name })
        
        return (found:true,region:countries)
    }

    func returnCountries() -> [JurisdictionStruct] {
        guard var countries = (Jurisdictions.Countries.all.filter({ $0.type == .country }) as [JurisdictionStruct]?) else {
            return []
        }

        countries.sort(by: { $0.name < $1.name })
        
        return countries
    }
}
