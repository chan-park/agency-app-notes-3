import Foundation
import SwiftUI

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "SavedNotes"
    
    init() {
        loadNotes()
    }
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes.sorted { $0.updatedAt > $1.updatedAt }
        } else {
            return notes.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.body.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.updatedAt > $1.updatedAt }
        }
    }
    
    func addNote() -> Note {
        let newNote = Note()
        notes.append(newNote)
        saveNotes()
        return newNote
    }
    
    func updateNote(_ note: Note, title: String, body: String) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].update(title: title, body: body)
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    func deleteNotes(at offsets: IndexSet) {
        let notesToDelete = offsets.map { filteredNotes[$0] }
        for note in notesToDelete {
            deleteNote(note)
        }
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            userDefaults.set(encoded, forKey: notesKey)
        }
    }
    
    private func loadNotes() {
        if let data = userDefaults.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decodedNotes
        }
    }
}