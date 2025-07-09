/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Project utilites for logging, UI and other miscellaneous needs.
*/

import os

enum Logging {
    static let subsystem = "com.example.apple-samplecode.AFM-CoffeeGame"

    static let general = Logger(subsystem: subsystem, category: "General")
}
