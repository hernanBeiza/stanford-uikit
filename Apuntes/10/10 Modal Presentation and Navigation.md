# 10 Modal Presentation and Navigation

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=CKexGQuIO7E

## Topics

- Presentings view on screen
- Many view models
- .sheet
- .popover
- TextField
- Form
- Hashable y Equatable
- NavigationView, NavigationLink .navigationBarTitle/Items
- Alerts
- Deletin from ForEach with .onDelete
- EditButton
- EditMode @Environment variable @Binding
- Setting @Environiment Variables
- .zIndex

## PopOver

- También podría ser un sheet, con .sheet

```swift
@State private var showPalleteEditor = false;

.popover(isPresented: $showPalleteEditor, content: {
  PaletteEditor()
  .frame(minWidth: 300, minHeight: 500)
})
```

### Forms

- Agregan scroll a los inputs
- También sirve para agrupar inputs de texto. Con un título

```swift
//Agrega scrolls y títulos
Form {
    Section(header: Text("Palette Name")){
        TextField("Palette Name", text:$paletteName, onEditingChanged: { began in                                                                      if !began {
      self.document.renamePalette(self.chosenPalette, to: self.paletteName)
                        }
                    })
                }
  Section(header: Text("Add Emoji")){
                    TextField("Add Emoji", text:$emojisToAdd, onEditingChanged: { began in
                        if !began {
                            self.chosenPalette = self.document.addEmoji(self.emojisToAdd, toPalette: self.chosenPalette)
                            self.emojisToAdd = "";
            }                                                                                  })
  }
}
```

### Lists y NavigationView!

```swift
var body: some View {
  NavigationView {
    //TableView!
    List {
      ForEach(store.documents) { document in
                                NavigationLink(destination: EmojiArtDocumentView(document: document)
                                               //Al entrar a la vista, el título cambiará
                                               .navigationBarTitle(self.store.name(for: document))) {
                                  Text(self.store.name(for: document))
                                }
                               }
    }
    .navigationTitle(self.store.name)
    //Solo para cuando se muestra la lista
    .navigationBarItems(leading: Button(action: {self.store.addDocument()},label: { Image(systemName: "plus").imageScale(.large)}))
  }
}
```

### Alerts

```swift
// NO se pueden poner dos alertas en el mismo elemento
.alert(isPresented: self.$confirmBackgroundPaste){
  return Alert(
    title: Text("Paste background"),
    message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
    primaryButton: .default(Text("Ok")) {
      self.document.backgroundURL = UIPasteboard.general.url
    },
    secondaryButton: .cancel()
  )
}
```
