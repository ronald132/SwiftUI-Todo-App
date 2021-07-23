//
//  ContentView.swift
//  WaToDo
//
//  Created by Ronald on 20/7/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos : FetchedResults<Todo>
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    
    @EnvironmentObject var iconSettings: IconNames
    
    //Theme
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                List{
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Uknown")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(todo.priority ?? "Uknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        } //HStack
                        .padding(.vertical, 10)
                    }
                    .onDelete(perform: deleteTodo)
                }
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor) , trailing:
                    Button(action: {
                        print("add todo")
                        self.showingSettingsView.toggle()
                    }){
                        Image(systemName: "paintbrush")
                            .imageScale(.large)
                    } //Settings button
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .sheet(isPresented: $showingSettingsView){
                        SettingsView().environmentObject(self.iconSettings)
                    }
                )
                
                if todos.count == 0 {
                    EmptyListView()
                }
            } //ZStacck
            .sheet(isPresented: $showingAddTodoView){
                AddTodoView()
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(animatingButton ? 0.2 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(animatingButton ? 0.15 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    //.animation(.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    .onAppear(perform: {
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)){
                                self.animatingButton.toggle()
                            }
                        }
                    })
                    
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width:48, height: 48, alignment: .center)
                    }
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                } //ZStack
                .padding(.bottom, 15)
                .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Functions
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            do {
                try managedObjectContext.save()
            }catch {
                print(error)
            }
        }
    }
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared
        ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
