import Foundation
import SwiftData
import SwiftUI

@Model
final class SelfCareActivity {
    var id: UUID
    var name: String
    var icon: String
    var colorHex: String // Store color as hex string since Color isn't directly storable
    private var patternData: Data
    var startDate: Date
    var activityDescription: String?
    var isCompleted: Bool
    
    var pattern: RecurringPattern {
        get {
            do {
                return try JSONDecoder().decode(RecurringPattern.self, from: patternData)
            } catch {
                print("❌ Failed to decode pattern: \(error)")
                // Return a default pattern if decoding fails
                return .interval(1)
            }
        }
        set {
            do {
                patternData = try JSONEncoder().encode(newValue)
            } catch {
                print("❌ Failed to encode pattern: \(error)")
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        color: Color,
        pattern: RecurringPattern,
        startDate: Date,
        activityDescription: String? = nil,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = color.toHex() ?? "#000000"
        self.patternData = (try? JSONEncoder().encode(pattern)) ?? Data()
        self.startDate = startDate
        self.activityDescription = activityDescription
        self.isCompleted = isCompleted
    }
    
    var color: Color {
        Color(hex: self.colorHex) ?? .black
    }
}

// Define RecurringPattern outside the model
enum RecurringPattern: Codable {
    case fixedDays([RecurringPattern.Weekday])
    case interval(Int)  // Every X days
    
    enum Weekday: Int, CaseIterable, Codable {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
}

// Add a transformer for RecurringPattern
@objc(RecurringPatternTransformer)
final class RecurringPatternTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let pattern = value as? RecurringPattern else { 
            print("⚠️ Transform failed: Input value is not RecurringPattern")
            return nil 
        }
        
        do {
            let data = try JSONEncoder().encode(pattern)
            print("✅ Successfully transformed RecurringPattern to Data")
            return data as NSData
        } catch {
            print("❌ Failed to encode RecurringPattern: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { 
            print("⚠️ Reverse transform failed: Input value is not Data")
            return nil 
        }
        
        do {
            let pattern = try JSONDecoder().decode(RecurringPattern.self, from: data)
            print("✅ Successfully reverse transformed Data to RecurringPattern")
            return pattern
        } catch {
            print("❌ Failed to decode RecurringPattern: \(error)")
            return nil
        }
    }
}

// Register the transformer
extension RecurringPatternTransformer {
    static let name = NSValueTransformerName("RecurringPatternTransformer")
    
    public static func register() {
        print("🔄 Registering RecurringPatternTransformer as: \(name.rawValue)")
        ValueTransformer.setValueTransformer(
            RecurringPatternTransformer(),
            forName: name
        )
    }
} 
