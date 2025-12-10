import SwiftUI

struct NoteDetailView: View {
    let note: Note
    let viewModel: NotesViewModel
    
    @State private var title: String
    @State private var body: String
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    init(note: Note, viewModel: NotesViewModel) {
        self.note = note
        self.viewModel = viewModel
        self._title = State(initialValue: note.title)
        self._body = State(initialValue: note.body)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Title Input
                TextField("Title", text: $title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                
                Divider()
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Body Input
                TextEditor(text: $body)
                    .font(.body)
                    .padding(.horizontal)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        
                        Button("Done") {
                            saveNote()
                            dismiss()
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
            .alert("Delete Note", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteNote(note)
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this note? This action cannot be undone.")
            }
        }
        .onDisappear {
            saveNote()
        }
    }
    
    private func saveNote() {
        viewModel.updateNote(note, title: title, body: body)
    }
}

#Preview {
    NoteDetailView(
        note: Note(title: "Sample Note", body: "This is a sample note body with some content to preview."),
        viewModel: NotesViewModel()
    )
}