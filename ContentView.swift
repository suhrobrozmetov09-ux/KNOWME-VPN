import SwiftUI
import NetworkExtension
import UIKit

@main
struct KNOWME_VPN_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var fixLagValue: Double = 90.0
    @State private var optimizeFpsValue: Double = 50.0
    @State private var smoothDeviceValue: Double = 50.0
    @State private var isVPNConnected: Bool = false
    @State private var statusText: String = "SOZLANISHGA TAYYOR"
    
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
                        .fill(isVPNConnected ? Color.green : goldColor)
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
                    customSlider(title: "FIX LAG", subtitle: "Ping va paket yo'qolishini kamaytirish", value: $fixLagValue)
                    customSlider(title: "OPTIMIZE FPS", subtitle: "Tarmoq oqimini barqarorlash", value: $optimizeFpsValue)
                    customSlider(title: "SMOOTH DEVICE", subtitle: "Ma'lumotlar uzatishni silliqlash", value: $smoothDeviceValue)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    toggleVPN()
                }) {
                    Text(isVPNConnected ? "VPN-NI O'CHIRISH" : "OPTIMIZATSIYANI YOQISH")
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
    
    func toggleVPN() {
        if isVPNConnected {
            NEVPNManager.shared().connection.stopVPNTunnel()
            isVPNConnected = false
            statusText = "SOZLANISHGA TAYYOR"
        } else {
            statusText = "PUBG SERVERLARI OPTIMIZATSIYA QILINMOQDA..."
            let p = NEVPNProtocolIKEv2()
            p.serverAddress = "://knowmevpn.com"
            p.username = "pubg_user"
            
            let dnsSettings = NEDNSSettings(servers: ["1.1.1.1", "1.0.0.1"])
            dnsSettings.matchDomains = ["tencentgames.com", "pubgmobile.com"]
            p.dnsSettings = dnsSettings
            
            NEVPNManager.shared().protocolConfiguration = p
            NEVPNManager.shared().isEnabled = true
            
            NEVPNManager.shared().saveToPreferences { error in
                if let error = error {
                    print(error.localizedDescription)
                    statusText = "XATOLIK YUZ BERDI"
                } else {
                    do {
                        try NEVPNManager.shared().connection.startVPNTunnel()
                        isVPNConnected = true
                        statusText = "FAOL: LAGLAR KAMAYTIRILDI"
                    } catch {
                        statusText = "ULANISHDA XATOLIK"
                    }
                }
            }
        }
    }
}
