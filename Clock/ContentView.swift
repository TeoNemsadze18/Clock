//
//  ContentView.swift
//  Clock
//
//  Created by teona nemsadze on 20.10.23.
//

import SwiftUI

struct ContentView: View {
    @State var isDark = false
    var body: some View {
        VStack {
            NavigationView {
                Home(isDark: $isDark)
                    .navigationBarHidden(true)
                    .preferredColorScheme(isDark ? .dark : .light)
            }
        LocationView()
                .padding(.top)
            Spacer()
        }
        
        .padding(.vertical)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Home: View {
    @Binding var isDark : Bool
    var width = UIScreen.main.bounds.width
    @State var current_Time = Time(min: 0, sec: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    var body: some View {
        VStack {
            HStack {
                Text("Clock")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer(minLength: 0)
                Button(action: {isDark.toggle()}) {
                    Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
                        .font(.system(size: 22))
                        .foregroundColor(isDark ? .black : .white)
                        .padding()
                        .background(Color.primary)
                        .clipShape(Circle())
                }
            }
            .padding()
            Spacer(minLength: 0)
            ZStack {
                
                Circle()
                    .fill(Color.black).opacity(0.1)
                ForEach(0..<60, id: \.self) { i in
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)
                        .offset(y: (width - 110) / 2)
                        .rotationEffect(.init(degrees: Double(i) * 6))
                }
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: (width - 180) / 2)
                    .offset(y: (width - 240) / 4)
                    .rotationEffect(.init(degrees: Double(current_Time.sec) * 6))
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (width - 200) / 2)
                    .offset(y: (width - 330) / 4)
                    .rotationEffect(.init(degrees: Double(current_Time.min) * 30))
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (width - 200) / 2)
                    .offset(y: (width - 200) / 4)
                    .rotationEffect(.init(degrees: Double(current_Time.hour) * 30))
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
            }
            .frame(width: width - 80, height: width - 80)
            Spacer(minLength: 0)
        }
        .onAppear(perform: {
            let calendar = Calendar.current
            let min = calendar.component(.minute, from: Date())
            let sec = calendar.component(.second, from: Date())
            let hour = calendar.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)) {
                self.current_Time = Time(min: min, sec: sec, hour: hour)
            }
        })
        .onReceive(receiver) { (_) in
            let calendar = Calendar.current
            let min = calendar.component(.minute, from: Date())
            let sec = calendar.component(.second, from: Date())
            let hour = calendar.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)) {
                self.current_Time = Time(min: min, sec: sec, hour: hour)
            }
        }
    }
}
struct LocationView: View {
    var body: some View {
        VStack {
            Text("Georgia")
                .font(.system(size: 50))
            Text("11:00 PM")
                .font(.title2)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

struct Time {
    var min : Int
    var sec : Int
    var hour : Int
}



