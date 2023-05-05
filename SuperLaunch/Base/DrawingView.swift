//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Karin Prater on 18.06.21.
//

import SwiftUI

struct DrawingView: View {
    var onEndedCallback: () -> Void
    
    @State private var lines = [Line]()
    @State private var deletedLines = [Line]()
    
    @Binding var lastLine: Line? // binding variable for the last line
    
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    
    let engine = DrawingEngine()
    @State private var showConfirmation: Bool = false
    
    var body: some View {
        
        VStack {
            
            //            HStack {
            //                ColorPicker("line color", selection: $selectedColor)
            //                    .labelsHidden()
            //                Slider(value: $selectedLineWidth, in: 1...20) {
            //                    Text("linewidth")
            //                }.frame(maxWidth: 100)
            //                Text(String(format: "%.0f", selectedLineWidth))
            //
            //                Spacer()
            //
            //                Button {
            //                    let last = lines.removeLast()
            //                    deletedLines.append(last)
            //                } label: {
            //                    Image(systemName: "arrow.uturn.backward.circle")
            //                        .imageScale(.large)
            //                }.disabled(lines.count == 0)
            //
            //                Button {
            //                    let last = deletedLines.removeLast()
            //
            //                    lines.append(last)
            //                } label: {
            //                    Image(systemName: "arrow.uturn.forward.circle")
            //                        .imageScale(.large)
            //                }.disabled(deletedLines.count == 0)
            //
            //                Button(action: {
            //                    showConfirmation = true
            //                }) {
            //                    Text("Delete")
            //                }.foregroundColor(.red)
            //                    .confirmationDialog(Text("Are you sure you want to delete everything?"), isPresented: $showConfirmation) {
            //
            //                        Button("Delete", role: .destructive) {
            //                            lines = [Line]()
            //                            deletedLines = [Line]()
            //                        }
            //                    }
            //
            //            }.padding()
            //
            
            ZStack {
                Color.black.opacity(0.01) //TODO cleaner fix
                if(!lines.isEmpty){
                    let line = lines.last!
                    DrawingShape(points: line.points)
                        .stroke(.black, style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                }

                
                
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
                let newPoint = value.location
//                print("NPX:",newPoint.x,"NPY:",newPoint.y)
                if value.translation.width + value.translation.height == 0 {
                    //TODO: use selected color and linewidth
                    lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
                    
                } else {
                    let index = lines.count - 1
                    lines[index].points.append(newPoint)
                }
                lastLine = lines.last
            }).onEnded({ value in
                if let last = lines.last?.points, last.isEmpty {
                    lines.removeLast()
                }
                onEndedCallback()
            })
                     
            )
            
        }
    }
}
