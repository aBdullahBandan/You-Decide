//
//  OpenCageRespones.swift
//  You Decide
//
//  Created by Abdullah Bandan on 24/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct OpenCageRespones: Codable {
        let results: [Result]?
        let status: Status?

        enum CodingKeys: String, CodingKey {
            case  results, status
        }
    }

    // MARK: - Result
    struct Result: Codable {
        let annotations: Annotations?
        let components: Components?
        let formatted: String?
    }

    // MARK: - Annotations
    struct Annotations: Codable {
        let callingcode: Int?
        let currency: Currency?
        let timezone: Timezone?

        enum CodingKeys: String, CodingKey {
            case callingcode, currency, timezone
        }
    }

    // MARK: - Currency
    struct Currency: Codable {
        let iso_code: String?
        let name: String?

        enum CodingKeys: String, CodingKey {
            case iso_code
            case name
 
        }
    }

    // MARK: - Timezone
    struct Timezone: Codable {
        let name: String?
        let short_name: String?

        enum CodingKeys: String, CodingKey {
            case name
            case short_name
        }
    }


    // MARK: - Components
    struct Components: Codable {
        let iso31661_Alpha2, iso31661_Alpha3: String?
        let continent, country, countryCode: String?

        enum CodingKeys: String, CodingKey {
            case iso31661_Alpha2 = "ISO_3166-1_alpha-2"
            case iso31661_Alpha3 = "ISO_3166-1_alpha-3"
            case continent, country
            case countryCode = "country_code"
        }
    }

    // MARK: - Status
    struct Status: Codable {
        let code: Int?
        let message: String?
    }

