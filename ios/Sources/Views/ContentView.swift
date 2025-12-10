import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showingNoteDetail = false
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Notes List
                if viewModel.filteredNotes.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(viewModel.filteredNotes) { note in
                            NoteRowView(note: note)
                                .onTapGesture {
                                    selectedNote = note
                                    showingNoteDetail = true
                                }
                        }
                        .onDelete(perform: viewModel.deleteNotes)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let newNote = viewModel.addNote()
                        selectedNote = newNote
                        showingNoteDetail = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingNoteDetail) {
                if let note = selectedNote {
                    NoteDetailView(note: note, viewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}