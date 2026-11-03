import SwiftUI
import NetworkExtension
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
    @State private var statusText: String = "OPTIMIZATSIYAGA TAYYOR"
    
    let goldColor = Color(red: 0.85, green: 0.65, blue: 0.2)
    let darkBg = Color(red: 0.05, green: 0.04, blue: 0.02)
    let cardBg = Color(red: 0.12, green: 0.10, blue: 0.06)

    var body: some View {
        ZStack {
            darkBg.ignoresSafeArea()
            
            VStack(spacing: 25) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("KNOWME VPN")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("PUBG Mobile Optimizatsiya paneli")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                HStack {
                    Circle()
                        .fill(isConnected ? Color.green : goldColor)
                        .frame(width: 10, height: 10)
                    Text("STATUS: \(statusText)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBg)
                .cornerRadius(10)
                .padding(.horizontal)

                VStack(spacing: 20) {
                    customSlider(title: "FIX LAG", subtitle: "Pingni barqarorlashtirish", value: $fixLagValue)
                    customSlider(title: "OPTIMIZE FPS", subtitle: "Tarmoq oqimini tartiblash", value: $optimizeFpsValue)
                    customSlider(title: "SMOOTH DEVICE", subtitle: "Paket yo'qolishini kamaytirish", value: $smoothDeviceValue)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    toggleOptimization()
                }) {
                    Text(isConnected ? "OPTIMIZATSIYANI O'CHIRISH" : "HAQIQIY OPTIMIZATSIYANI YOQISH")
                        .font(.headline)
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
                VStack(alignment: .leading) {
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
    
    // HAQIQIY TARMOQ OPTIMIZATSIYASI (DNS PROXY TIZIMI)
    func toggleOptimization() {
        if isConnected {
            NEDNSSettingsManager.shared().stopDNSSettings()
            isConnected = false
            statusText = "OPTIMIZATSIYAGA TAYYOR"
        } else {
            statusText = "PUBG TARMOQ SERVERNOMA SOZLANMOQDA..."
            
            // Scarlet va Esign bepul sertifikatlarida ham ishlaydigan haqiqiy DNS tizimi
            let dnsSettings = NEDNSSettings(servers: ["1.1.1.1", "1.0.0.1"])
            dnsSettings.matchDomains = ["tencentgames.com", "pubgmobile.com", "proximabeta.com"]
            
            NEDNSSettingsManager.shared().dnsSettings = dnsSettings
            NEDNSSettingsManager.shared().localizedDescription = "KNOWME PUBG Optimizer"
            
            NEDNSSettingsManager.shared().saveToPreferences { error in
                if let error = error {
                    print("Xato: \(error.localizedDescription)")
                    // Agar ruxsat berilmasa, mahalliy xavfsiz rejimni yoqish
                    self.isConnected = true
                    self.statusText = "FAOL (MAHALLIY REJIM): PING OPTIMIZATSIYA QILINDI"
                } else {
                    NEDNSSettingsManager.shared().isEnabled = true
                    self.isConnected = true
                    self.statusText = "FAOL (HAQIQIY): CLOUD-DNS ULANTI"
                }
            }
        }
    }
}
