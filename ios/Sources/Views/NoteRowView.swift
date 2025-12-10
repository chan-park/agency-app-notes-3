import SwiftUI

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(note.title.isEmpty ? "New Note" : note.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                Text(note.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(note.preview)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    List {
        NoteRowView(note: Note(title: "Meeting Notes", body: "Discussed project timeline and deliverables for Q4. Key points to remember for next week's follow-up meeting."))
        NoteRowView(note: Note(title: "Grocery List", body: "Milk, Bread, Eggs, Apples"))
        NoteRowView(note: Note(title: "", body: "This is a note without a title"))
    }
}