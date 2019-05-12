//
//  Recognizer.swift
//  Antybec
//
//  Created by Wiktor Biruk on 08/04/2019.
//  Copyright © 2019 Wiktor Biruk. All rights reserved.
//

import Foundation

struct Recognizer {

    // TODO: set real parameters
    func findPathologyWithNextSensorsLoad(accZ: Double?, gyrZ: Double?, mag: Double?) -> Double {

        // NOTE: fake implementation, add real one

        if accZ != nil {
            var accZ = accZ!
            accZ += 4
            return accZ/4
        }

        if gyrZ != nil {
            var gyrZ = gyrZ!
            gyrZ += 4
            return gyrZ/4
        }

        if mag != nil {
            var mag = mag!
            mag += 3
            return mag/6
        }

        return 0
    }
}
