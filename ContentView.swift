import SwiftUI
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: ContentView())
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

struct ContentView: View {
    @State private var fixLagValue: Double = 90.0
    @State private var optimizeFpsValue: Double = 50.0
    @State private var smoothDeviceValue: Double = 50.0
    @State private var isConnected: Bool = false
    @State private var statusText: String = "READY TO OPTIMIZE / ГОТОВ К НАСТРОЙКЕ"
    
    let goldColor = Color(red: 0.85, green: 0.65, blue: 0.2)
    let darkBg = Color(red: 0.05, green: 0.04, blue: 0.02)
    let cardBg = Color(red: 0.12, green: 0.10, blue: 0.06)

    var body: some View {
        ZStack {
            darkBg.ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Header (Sarlavha)
                VStack(alignment: .leading, spacing: 5) {
                    Text("KNOWME VPN")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("PUBG Mobile Optimization Panel")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Status Panel
                HStack {
                    Circle()
                        .fill(isConnected ? Color.green : goldColor)
                        .frame(width: 10, height: 10)
                    Text("STATUS: \(statusText)")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBg)
                .cornerRadius(10)
                .padding(.horizontal)

                // Sliders (Slayderlar)
                VStack(spacing: 20) {
                    customSlider(
                        title: "FIX LAG /АНТИЛАГ", 
                        subtitle: "Reduce ping and packet loss / Снижение пинга", 
                        value: $fixLagValue
                    )
                    
                    customSlider(
                        title: "OPTIMIZE FPS / ФПС", 
                        subtitle: "Stabilize network stream / Стабилизация потока", 
                        value: $optimizeFpsValue
                    )
                    
                    customSlider(
                        title: "SMOOTH DEVICE / СГЛАЖИВАНИЕ", 
                        subtitle: "Smooth data transmission / Сглаживание данных", 
                        value: $smoothDeviceValue
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Main Button (Asosiy Tugma)
                Button(action: {
                    toggleOptimization()
                }) {
                    Text(isConnected ? "STOP OPTIMIZATION / ОТКЛЮЧИТЬ" : "START OPTIMIZATION / ЗАПУСТИТЬ")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(goldColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.top)
        }
    }
    
    @ViewBuilder
    func customSlider(title: String, subtitle: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline).foregroundColor(.white)
                    Text(subtitle).font(.caption2).foregroundColor(.gray)
                }
                Spacer()
                Text("\(Int(value.wrappedValue))%").font(.title3).bold().foregroundColor(goldColor)
            }
            Slider(value: value, in: 0...100, step: 1)
                .accentColor(goldColor)
        }
        .padding()
        .background(cardBg)
        .cornerRadius(12)
    }
    
    func toggleOptimization() {
        if isConnected {
            isConnected = false
            statusText = "READY TO OPTIMIZE / ГОТОВ К НАСТРОЙКЕ"
        } else {
            statusText = "CONFIGURING SERVER / НАСТРОЙКА СЕРВЕРА..."
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let calculatedPing = Int(20 + (100 - fixLagValue) * 0.4)
                self.isConnected = true
                self.statusText = "ACTIVE: PING OPTIMIZED (\(calculatedPing)ms) / ОПТИМИЗИРОВАНО"
            }
        }
    }
}
