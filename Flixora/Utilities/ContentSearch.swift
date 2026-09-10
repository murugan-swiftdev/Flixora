//
//  ContentSearch.swift
//  Flixora
//
//  Reusable search utilities for OTTContent collections
//

import Foundation

/// Reusable search helper that filters an array of `OTTContent` by query, language and genre.
/// - Parameters:
///   - contents: input collection of OTTContent
///   - query: optional search query; if nil or empty the function will not filter by text
///   - selectedLanguage: optional language filter; pass "All" or nil to disable
///   - selectedGenre: optional genre filter; pass "All" or nil to disable
///   - deduplicate: when true, removes duplicated items by `id` preserving first occurrence
/// - Returns: filtered array of `OTTContent`
func searchContents(
    _ contents: [OTTContent],
    query: String? = nil,
    selectedLanguage: String? = nil,
    selectedGenre: String? = nil,
    deduplicate: Bool = false
) -> [OTTContent] {

    let trimmedQuery = query?
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()

    var seen = Set<UUID>()

    return contents.filter { content in

        // Deduplication check
        if deduplicate {
            if seen.contains(content.id) { return false }
            seen.insert(content.id)
        }

        // Language filter
        if let lang = selectedLanguage, lang != "All" {
            if content.language != lang { return false }
        }

        // Genre filter
        if let genre = selectedGenre, genre != "All" {
            if content.genre != genre { return false }
        }

        // Textual search
        guard let q = trimmedQuery, !q.isEmpty else {
            return true
        }

        // Check fields we want to search
        if content.title.lowercased().contains(q) { return true }
        if content.genre.lowercased().contains(q) { return true }
        if content.language.lowercased().contains(q) { return true }
        if content.description.lowercased().contains(q) { return true }

        return false
    }
}
