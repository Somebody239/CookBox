//
//  RecipeView.swift
//  CookBox
//
//  Created by Kishan on 2026-07-22.
//

import Foundation
import SwiftUI
import SwiftData

@available(iOS 26.0, *)
struct RecipeView: View {
    @Bindable var recipe: Recipe

    @State private var selectedServings: Int
    @State private var completedStepIDs: Set<UUID> = []

    init(recipe: Recipe) {
        self.recipe = recipe
        self._selectedServings = State(initialValue: max(recipe.servings, 1))
    }

    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    heroSection
                    overviewSection

                    ingredientsSection
                    instructionsSection

                    if let nutritionInfo = recipe.nutritionInfo {
                        nutritionSection(nutritionInfo)
                    }

                    if !trimmed(recipe.notes).isEmpty {
                        notesSection
                    }

                    if !trimmed(recipe.sourceName).isEmpty || !trimmed(recipe.sourceURL).isEmpty {
                        sourceSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    recipe.isFavourite.toggle()
                    recipe.dateUpdated = Date()
                } label: {
                    Image(systemName: recipe.isFavourite ? "heart.fill" : "heart")
                }
                .accessibilityLabel(recipe.isFavourite ? "Remove from Favourites" : "Add to Favourites")
            }
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack {
                        Color.gray.opacity(0.18)

                        Image(systemName: "fork.knife")
                            .font(.system(size: 54, weight: .light))
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.72)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 6) {
                if !recipeSubtitle.isEmpty {
                    Text(recipeSubtitle.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .tracking(1.1)
                        .foregroundColor(.white.opacity(0.82))
                }

                Text(displayName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            if !trimmed(recipe.recipeDescription).isEmpty {
                Text(recipe.recipeDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()
            }

            HStack(alignment: .top, spacing: 10) {
                overviewItem(
                    systemImage: "clock",
                    value: recipe.totalTimeMinutes > 0 ? formattedMinutes(recipe.totalTimeMinutes) : "Not set",
                    label: "Total"
                )

                Divider()

                overviewItem(
                    systemImage: "person.2",
                    value: "\(selectedServings)",
                    label: "Servings"
                )

                Divider()

                overviewItem(
                    systemImage: "chart.bar",
                    value: trimmed(recipe.difficulty).isEmpty ? "Not set" : recipe.difficulty,
                    label: "Difficulty"
                )
            }

            if !recipe.tags.isEmpty {
                Divider()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(recipe.tags.enumerated()), id: \.offset) { _, tag in
                            Text(tag)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .glassEffect(.regular, in: Capsule())
                        }
                    }
                }
            }
        }
        .padding(18)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Ingredients", systemImage: "carrot")

            VStack(spacing: 0) {
                Stepper(value: $selectedServings, in: servingRange) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Servings")
                            .fontWeight(.semibold)

                        Text(servingDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 12)

                if selectedServings != originalServings {
                    Divider()

                    Button {
                        selectedServings = originalServings
                    } label: {
                        Label("Reset to original servings", systemImage: "arrow.counterclockwise")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 12)
                }

                Divider()

                if availableIngredients.isEmpty {
                    Text("No ingredients have been added yet.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 14)
                } else {
                    ForEach(availableIngredients) { ingredient in
                        HStack(alignment: .firstTextBaseline, spacing: 16) {
                            Text(ingredient.name)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if !trimmed(ingredient.measurement).isEmpty {
                                Text(scaledMeasurement(ingredient.measurement))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        .padding(.vertical, 12)

                        if ingredient.id != availableIngredients.last?.id {
                            Divider()
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 4)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
        }
    }

    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Instructions", systemImage: "list.number")

            VStack(spacing: 0) {
                if availableSteps.isEmpty {
                    Text("No cooking instructions have been added yet.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 14)
                } else {
                    HStack(spacing: 12) {
                        ProgressView(value: cookingProgress)

                        Text("\(completedStepIDs.count) of \(availableSteps.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .monospacedDigit()
                    }
                    .padding(.vertical, 12)

                    Divider()

                    ForEach(availableSteps) { step in
                        Button {
                            toggleStep(step.id)
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                if completedStepIDs.contains(step.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.accentColor)
                                        .frame(width: 26, height: 26)
                                } else {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.secondary, lineWidth: 1.5)

                                        Text("\(step.stepNumber)")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 24, height: 24)
                                    .frame(width: 26, height: 26)
                                }

                                Text(step.instruction)
                                    .foregroundColor(.primary)
                                    .strikethrough(completedStepIDs.contains(step.id), color: .secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 14)

                        if step.id != availableSteps.last?.id {
                            Divider()
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 4)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
        }
    }

    private func nutritionSection(_ nutritionInfo: NutritionInfo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Nutrition", systemImage: "leaf")

            VStack(spacing: 0) {
                detailRow(label: "Calories", value: "\(nutritionInfo.calories) kcal")
                Divider()
                detailRow(label: "Protein", value: "\(formattedNutrition(nutritionInfo.protein)) g")
                Divider()
                detailRow(label: "Carbohydrates", value: "\(formattedNutrition(nutritionInfo.carbohydrates)) g")
                Divider()
                detailRow(label: "Fat", value: "\(formattedNutrition(nutritionInfo.fat)) g")
                Divider()
                detailRow(label: "Fibre", value: "\(formattedNutrition(nutritionInfo.fibre)) g")
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 4)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Notes", systemImage: "note.text")

            Text(recipe.notes)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(18)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
        }
    }

    private var sourceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Source", systemImage: "link")

            Group {
                if let sourceLink {
                    Link(destination: sourceLink) {
                        HStack(spacing: 12) {
                            Image(systemName: "safari")
                                .foregroundColor(.accentColor)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(sourceTitle)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)

                                if !trimmed(recipe.sourceURL).isEmpty {
                                    Text(recipe.sourceURL)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }

                            Spacer()

                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    Text(sourceTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(18)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
        }
    }

    private func sectionTitle(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .font(.title2)
            .fontWeight(.bold)
    }

    private func overviewItem(systemImage: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .foregroundColor(.accentColor)

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
    }

    private var originalServings: Int {
        max(recipe.servings, 1)
    }

    private var servingRange: ClosedRange<Int> {
        1...max(50, originalServings)
    }

    private var servingMultiplier: Double {
        Double(selectedServings) / Double(originalServings)
    }

    private var servingDescription: String {
        if selectedServings == originalServings {
            return "\(selectedServings) original servings"
        }

        return "\(selectedServings) servings • \(servingMultiplier.formatted(.number.precision(.fractionLength(0...2))))× ingredients"
    }

    private var availableSteps: [CookingStep] {
        recipe.steps.filter {
            !trimmed($0.instruction).isEmpty
        }
    }

    private var availableIngredients: [Ingredient] {
        recipe.ingredients.filter {
            !trimmed($0.name).isEmpty || !trimmed($0.measurement).isEmpty
        }
    }

    private var cookingProgress: Double {
        guard !availableSteps.isEmpty else {
            return 0
        }

        return Double(completedStepIDs.count) / Double(availableSteps.count)
    }

    private var recipeSubtitle: String {
        [trimmed(recipe.dishType), trimmed(recipe.cuisine)]
            .filter { !$0.isEmpty }
            .joined(separator: " • ")
    }

    private var displayName: String {
        let name = trimmed(recipe.name)
        return name.isEmpty ? "Untitled Recipe" : name
    }

    private var sourceTitle: String {
        let name = trimmed(recipe.sourceName)

        if !name.isEmpty {
            return name
        }

        let url = trimmed(recipe.sourceURL)
        return url.isEmpty ? "Recipe source" : url
    }

    private var sourceLink: URL? {
        let source = trimmed(recipe.sourceURL)

        guard !source.isEmpty else {
            return nil
        }

        if let url = URL(string: source), url.scheme != nil {
            return url
        }

        return URL(string: "https://\(source)")
    }

    private func toggleStep(_ id: UUID) {
        if completedStepIDs.contains(id) {
            completedStepIDs.remove(id)
        } else {
            completedStepIDs.insert(id)
        }
    }

    private func scaledMeasurement(_ measurement: String) -> String {
        guard selectedServings != originalServings else {
            return measurement
        }

        let parts = measurement
            .split(whereSeparator: { $0.isWhitespace })
            .map(String.init)

        guard let firstPart = parts.first else {
            return measurement
        }

        var amount: Double?
        var usedParts = 1

        if let wholeNumber = Double(firstPart) {
            amount = wholeNumber

            if parts.count > 1, let fraction = fractionValue(parts[1]) {
                amount = wholeNumber + fraction
                usedParts = 2
            }
        } else {
            amount = quantityValue(firstPart)
        }

        guard let amount else {
            return measurement
        }

        let scaledAmount = formattedAmount(amount * servingMultiplier)
        let unit = parts.dropFirst(usedParts).joined(separator: " ")

        return unit.isEmpty ? scaledAmount : "\(scaledAmount) \(unit)"
    }

    private func quantityValue(_ text: String) -> Double? {
        if let fraction = fractionValue(text) {
            return fraction
        }

        guard let lastCharacter = text.last, let fraction = unicodeFractionValue(lastCharacter) else {
            return nil
        }

        let wholeText = String(text.dropLast())
        let wholeNumber = wholeText.isEmpty ? 0 : Double(wholeText)

        guard let wholeNumber else {
            return nil
        }

        return wholeNumber + fraction
    }

    private func fractionValue(_ text: String) -> Double? {
        if text.count == 1, let character = text.first, let value = unicodeFractionValue(character) {
            return value
        }

        let values = text.split(separator: "/", omittingEmptySubsequences: false)

        guard
            values.count == 2,
            let numerator = Double(values[0]),
            let denominator = Double(values[1]),
            denominator != 0
        else {
            return nil
        }

        return numerator / denominator
    }

    private func unicodeFractionValue(_ character: Character) -> Double? {
        switch character {
        case "⅛": return 1.0 / 8.0
        case "¼": return 1.0 / 4.0
        case "⅓": return 1.0 / 3.0
        case "⅜": return 3.0 / 8.0
        case "½": return 1.0 / 2.0
        case "⅝": return 5.0 / 8.0
        case "⅔": return 2.0 / 3.0
        case "¾": return 3.0 / 4.0
        case "⅞": return 7.0 / 8.0
        default: return nil
        }
    }

    private func formattedAmount(_ amount: Double) -> String {
        let wholeNumber = floor(amount)
        let decimal = amount - wholeNumber
        let fractions: [(value: Double, text: String)] = [
            (0, ""),
            (1.0 / 8.0, "⅛"),
            (1.0 / 4.0, "¼"),
            (1.0 / 3.0, "⅓"),
            (3.0 / 8.0, "⅜"),
            (1.0 / 2.0, "½"),
            (5.0 / 8.0, "⅝"),
            (2.0 / 3.0, "⅔"),
            (3.0 / 4.0, "¾"),
            (7.0 / 8.0, "⅞"),
            (1, "")
        ]

        if let closestFraction = fractions.min(by: {
            abs($0.value - decimal) < abs($1.value - decimal)
        }) {
            let roundsPositiveAmountToZero = wholeNumber == 0 && closestFraction.value == 0
            let tolerance = roundsPositiveAmountToZero ? 0.005 : 0.025

            guard abs(closestFraction.value - decimal) < tolerance else {
                return amount.formatted(.number.precision(.fractionLength(0...2)))
            }

            let adjustedWholeNumber = closestFraction.value == 1 ? wholeNumber + 1 : wholeNumber
            let wholeText = adjustedWholeNumber > 0 ? String(Int(adjustedWholeNumber)) : ""

            if closestFraction.text.isEmpty {
                return wholeText.isEmpty ? "0" : wholeText
            }

            return wholeText.isEmpty ? closestFraction.text : "\(wholeText) \(closestFraction.text)"
        }

        return amount.formatted(.number.precision(.fractionLength(0...2)))
    }

    private func formattedMinutes(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        if hours > 0 && remainingMinutes > 0 {
            return "\(hours) hr \(remainingMinutes) min"
        } else if hours > 0 {
            return "\(hours) hr"
        } else {
            return "\(remainingMinutes) min"
        }
    }

    private func formattedNutrition(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...1)))
    }

    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        NavigationStack {
            RecipeView(
                recipe: Recipe(
                    name: "Creamy Tomato Pasta",
                    recipeDescription: "A simple tomato pasta with a silky cream sauce.",
                    ingredients: [
                        Ingredient(name: "Pasta", measurement: "2 cups"),
                        Ingredient(name: "Tomato sauce", measurement: "1 1/2 cups"),
                        Ingredient(name: "Cream", measurement: "1/2 cup")
                    ],
                    steps: [
                        CookingStep(stepNumber: 1, instruction: "Boil the pasta until tender."),
                        CookingStep(stepNumber: 2, instruction: "Warm the sauce and stir in the cream."),
                        CookingStep(stepNumber: 3, instruction: "Combine the pasta and sauce, then serve.")
                    ],
                    prepTimeMinutes: 10,
                    cookingTimeMinutes: 20,
                    servings: 2,
                    dishType: "Main Dish",
                    cuisine: "Italian",
                    difficulty: "Easy",
                    tags: ["Comfort Food", "Quick"],
                    notes: "Save a little pasta water in case the sauce needs thinning.",
                    nutritionInfo: NutritionInfo(
                        calories: 520,
                        protein: 18,
                        carbohydrates: 72,
                        fat: 19,
                        fibre: 5
                    )
                )
            )
        }
        .modelContainer(for: Recipe.self, inMemory: true)
    }
}
