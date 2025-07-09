/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A class for generating an image based on a generated text description.
*/

import FoundationModels
import ImagePlayground
import SwiftUI

@MainActor
@Observable
final class GenerableImage: Generable, Equatable {

    nonisolated static func == (lhs: GenerableImage, rhs: GenerableImage) -> Bool {
        lhs === rhs
    }

    @Guide(description: "Avoid descriptions that look human-like. Stick to animals, plants, or objects.")
    let imageDescription: String
    
    let imageStyle: ImagePlaygroundStyle = .sketch

    var isResponding: Bool { task != nil }
    private(set) var image: CGImage?

    private var task: Task<Void, Error>?

    nonisolated static var generationSchema: GenerationSchema {
        GenerationSchema(
            type: GenerableImage.self,
            description: "A description of an image to be given to a image generation model. The description should be short and non-human-like.",
            properties: [
                GenerationSchema.Property(
                    name: "imageDescription",
                    type: String.self
                )
            ]
        )
    }

    nonisolated var generatedContent: GeneratedContent {
        GeneratedContent(properties: [
            "imageDescription": imageDescription
        ])
    }

    nonisolated init(_ content: GeneratedContent) throws {
        self.imageDescription = try content.value(forProperty: "imageDescription")
        Logging.general.log("Generating image for description: \(self.imageDescription)")
        Task { try await self.generateImage() }
    }

    private func generateImage() throws {
        task?.cancel()
        task = Task {
            do {
                let generator = try await ImageCreator()

                let generations = generator.images(
                    for: [.text(imageDescription)],
                    style: imageStyle,
                    limit: 1
                )

                for try await generation in generations {
                    self.image = generation.cgImage
                    self.task = nil
                    return
                }

            } catch let error {
                self.task = nil
                Logging.general.log("Image generation failed for prompt: \(self.imageDescription). Error: \(error)")
                throw error
            }
        }
    }
}
