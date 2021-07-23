//
//  AddTodoView.swift
//  WaToDo
//
//  Created by Ronald on 20/7/21.
//

import SwiftUI

struct AddTodoView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    @State private var erroShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    let priorities = ["High", "Normal", "Low"]
    
    //Theme
    @ObservedObject var theme = ThemeSettings()
    var themes : [Theme] = themeData
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 30, weight: .bold, design: .default))
                    
                    Picker("Priority", selection: $priority){
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button(action: {
                        if self.name != "" {
                            let todo = Todo(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        } else {
                            self.erroShowing = true
                            self.errorTitle = "Invalid name"
                            self.errorMessage = "Make sure to enter something for\nthe new todo item"
                            return
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)
                    }
                } //VStack
                .padding(.horizontal)
                .padding(.vertical, 30)
                Spacer()
            } //VStack
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "xmark")
                }
            )
            .alert(isPresented: $erroShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }//Navigation
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
            .previewDevice("iPhone 12")
    }
}
