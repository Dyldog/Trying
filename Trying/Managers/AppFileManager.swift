//
//  AppFileManager.swift
//  Graby
//
//  Created by Dylan Elliott on 17/10/2022.
//

import Foundation

enum AppFolder: String {
    case goals = "Goals"
}

enum AppFile: String {
    case goals = "goals.json"
    case completions = "completions.json"
    
    var parent: AppFolder { .goals }
}

extension URL {
    func appendingPathComponent(_ folder: AppFolder) -> URL {
        self.appendingPathComponent(folder.rawValue)
    }
    func appendingPathComponent(_ file: AppFile) -> URL {
        self.appendingPathComponent(file.parent).appendingPathComponent(file.rawValue)
    }
}

class AppFileManager {
    static let shared: AppFileManager = .init()
    
    let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    
    private func createFolder(_ location: AppFolder) {
        guard let driveURL = driveURL else { return }
        try! FileManager.default.createDirectory(at: driveURL.appendingPathComponent(location), withIntermediateDirectories: true)
    }
    
    func save(_ data: Data, to location: AppFile) {
        guard let driveURL = driveURL else { return }
        createFolder(location.parent)
        let fileURL = driveURL.appendingPathComponent(location)
        try! data.write(to: fileURL)
    }
    
    func getData(_ location: AppFile) -> Data? {
        guard let driveURL = driveURL else { return nil }
        let fileURL = driveURL.appendingPathComponent(location)
        return try? Data(contentsOf: fileURL)
    }
    
    func getFromFiles<T: Codable>(_ location: AppFile) -> T? {
        guard let data = getData(location) else { return nil }
        return (try? JSONDecoder().decode(T.self, from: data))
    }
        
    func saveToUserDefaults<T: Codable>(_ value: T, location: AppFile, named name: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        save(data, to: location)
    }
}
