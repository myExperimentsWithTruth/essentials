import SwiftUI
import Contacts

// MARK: - Theme System

enum AppTheme: String, CaseIterable {
    case dark = "default"
    case eink = "e-ink"
    case oled = "power saver"
}

struct ThemeColors {
    let bg: Color
    let mainText: Color
    let dimText: Color
    let lineColor: Color
    let searchBg: Color
    let callButton: Color
    let callButtonText: Color
}

class ThemeManager: ObservableObject {
    @Published var current: AppTheme {
        didSet {
            UserDefaults.standard.set(current.rawValue, forKey: "appTheme")
        }
    }

    var colors: ThemeColors {
        switch current {
        case .dark:
            return ThemeColors(
                bg: Color(red: 0x12/255.0, green: 0x12/255.0, blue: 0x12/255.0),
                mainText: .white,
                dimText: Color(white: 0.82),
                lineColor: Color(white: 0.3),
                searchBg: Color(white: 0.22),
                callButton: .green,
                callButtonText: Color(red: 0x12/255.0, green: 0x12/255.0, blue: 0x12/255.0)
            )
        case .eink:
            return ThemeColors(
                bg: Color(red: 0.96, green: 0.95, blue: 0.92),
                mainText: Color(white: 0.12),
                dimText: Color(white: 0.42),
                lineColor: Color(white: 0.78),
                searchBg: Color(white: 0.88),
                callButton: Color(red: 0.25, green: 0.52, blue: 0.25),
                callButtonText: Color(red: 0.96, green: 0.95, blue: 0.92)
            )
        case .oled:
            return ThemeColors(
                bg: .black,
                mainText: Color(white: 0.55),
                dimText: Color(white: 0.30),
                lineColor: Color(white: 0.12),
                searchBg: Color(white: 0.08),
                callButton: Color(red: 0.0, green: 0.35, blue: 0.0),
                callButtonText: Color(white: 0.55)
            )
        }
    }

    var colorScheme: ColorScheme {
        current == .eink ? .light : .dark
    }

    init() {
        let saved = UserDefaults.standard.string(forKey: "appTheme") ?? "default"
        self.current = AppTheme(rawValue: saved) ?? .dark
    }
}

// MARK: - Launcher

struct LauncherItem: Identifiable {
    let id = UUID()
    let label: String
    let url: String
}

struct ContentView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var showCamera = false
    @State private var showPhone = false
    @State private var showSettings = false

    private let items: [LauncherItem] = [
        LauncherItem(label: "phone", url: "phone://"),
        LauncherItem(label: "whatsapp", url: "whatsapp://"),
        LauncherItem(label: "google maps", url: "comgooglemaps://"),
        LauncherItem(label: "apple music", url: "music://"),
        LauncherItem(label: "youtube", url: "youtube://"),
        LauncherItem(label: "camera", url: "camera://"),
        LauncherItem(label: "settings", url: "App-prefs:"),
    ]

    private var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: now)
    }

    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, d MMMM"
        return f.string(from: now).lowercased()
    }

    var body: some View {
        ZStack {
            theme.colors.bg.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // Time
                Text(timeString)
                    .font(.system(size: 64, weight: .ultraLight, design: .default))
                    .foregroundColor(theme.colors.mainText)
                    .kerning(-1)

                // Date
                Text(dateString)
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(theme.colors.dimText)
                    .padding(.top, 4)

                Spacer()
                    .frame(height: 60)

                // App list
                Rectangle()
                    .fill(theme.colors.lineColor)
                    .frame(height: 0.5)

                ForEach(items) { item in
                    Button {
                        launchItem(item)
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(item.label)
                                .font(.system(size: 21, weight: .light))
                                .foregroundColor(theme.colors.mainText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 18)

                            Rectangle()
                                .fill(theme.colors.lineColor)
                                .frame(height: 0.5)
                        }
                    }
                    .buttonStyle(LauncherButtonStyle())
                }

                Spacer()

                // Footer
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("crafted with claude")
                            .font(.system(size: 11, weight: .light, design: .serif))
                            .italic()
                            .foregroundColor(theme.colors.dimText.opacity(0.5))
                        Text("pair with grayscale for calm")
                            .font(.system(size: 10, weight: .light, design: .serif))
                            .italic()
                            .foregroundColor(theme.colors.dimText.opacity(0.35))
                    }

                    Spacer()

                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(theme.colors.dimText)
                    }
                    .buttonStyle(LauncherButtonStyle())
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
        .statusBarHidden(true)
        .onReceive(timer) { self.now = $0 }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView()
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showPhone) {
            PhoneView()
                .environmentObject(theme)
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(theme)
        }
    }

    private func launchItem(_ item: LauncherItem) {
        switch item.url {
        case "phone://":
            showPhone = true
        case "camera://":
            showCamera = true
        default:
            if let url = URL(string: item.url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @EnvironmentObject var theme: ThemeManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            theme.colors.bg.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("back")
                            .font(.system(size: 21, weight: .light))
                            .foregroundColor(theme.colors.dimText)
                    }
                    Spacer()
                }
                .padding(.top, 20)

                Text("theme")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(theme.colors.dimText)
                    .padding(.top, 40)

                Rectangle()
                    .fill(theme.colors.lineColor)
                    .frame(height: 0.5)
                    .padding(.top, 12)

                ForEach(AppTheme.allCases, id: \.self) { t in
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            theme.current = t
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text(t.rawValue)
                                    .font(.system(size: 21, weight: .light))
                                    .foregroundColor(theme.colors.mainText)

                                Spacer()

                                if theme.current == t {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .light))
                                        .foregroundColor(theme.colors.mainText)
                                }
                            }
                            .padding(.vertical, 18)

                            Rectangle()
                                .fill(theme.colors.lineColor)
                                .frame(height: 0.5)
                        }
                    }
                    .buttonStyle(LauncherButtonStyle())
                }

                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .statusBarHidden(true)
        .preferredColorScheme(theme.colorScheme)
    }
}

// MARK: - Phone View (tabs: favourites / dialer)

struct PhoneView: View {
    @EnvironmentObject var theme: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            theme.colors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar: back + tabs
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("back")
                            .font(.system(size: 21, weight: .light))
                            .foregroundColor(theme.colors.dimText)
                    }

                    Spacer()

                    HStack(spacing: 24) {
                        Button {
                            selectedTab = 0
                        } label: {
                            Text("favourites")
                                .font(.system(size: 21, weight: .light))
                                .foregroundColor(selectedTab == 0 ? theme.colors.mainText : theme.colors.dimText)
                        }

                        Button {
                            selectedTab = 1
                        } label: {
                            Text("dialer")
                                .font(.system(size: 21, weight: .light))
                                .foregroundColor(selectedTab == 1 ? theme.colors.mainText : theme.colors.dimText)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)

                if selectedTab == 0 {
                    FavouritesView()
                        .environmentObject(theme)
                } else {
                    DialerView()
                        .environmentObject(theme)
                }
            }
        }
        .statusBarHidden(true)
        .preferredColorScheme(theme.colorScheme)
    }
}

// MARK: - Favourites

struct FavouriteContact: Identifiable {
    let id: String // CNContact.identifier
    let name: String
    let number: String
}

struct FavouritesView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var favourites: [FavouriteContact] = []
    @State private var showContactPicker = false

    var body: some View {
        VStack(spacing: 0) {
            if favourites.isEmpty {
                Spacer()
                Text("no favourites yet")
                    .font(.system(size: 21, weight: .light))
                    .foregroundColor(theme.colors.dimText)
                Spacer()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Rectangle()
                            .fill(theme.colors.lineColor)
                            .frame(height: 0.5)
                            .padding(.top, 24)

                        ForEach(favourites) { contact in
                            Button {
                                let digits = contact.number.filter { $0.isNumber }
                                let cleaned = digits.hasPrefix("0") ? String(digits.dropFirst()) : digits
                                if let url = URL(string: "whatsapp://send?phone=\(cleaned)") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(contact.name)
                                        .font(.system(size: 21, weight: .light))
                                        .foregroundColor(theme.colors.mainText)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 18)

                                    Rectangle()
                                        .fill(theme.colors.lineColor)
                                        .frame(height: 0.5)
                                }
                            }
                            .buttonStyle(LauncherButtonStyle())
                            .contextMenu {
                                Button(role: .destructive) {
                                    removeFavourite(contact.id)
                                } label: {
                                    Label("Remove", systemImage: "minus.circle")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }

            // Add button
            HStack {
                Spacer()
                Button {
                    showContactPicker = true
                } label: {
                    Text("+")
                        .font(.system(size: 21, weight: .light))
                        .foregroundColor(theme.colors.mainText)
                        .frame(width: 48, height: 48)
                }
                .buttonStyle(LauncherButtonStyle())
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
        .onAppear { loadFavourites() }
        .sheet(isPresented: $showContactPicker, onDismiss: { loadFavourites() }) {
            ContactListView()
                .environmentObject(theme)
        }
    }

    private func loadFavourites() {
        let ids = UserDefaults.standard.stringArray(forKey: "favouriteContactIDs") ?? []
        guard !ids.isEmpty else {
            favourites = []
            return
        }

        let store = CNContactStore()
        let status = CNContactStore.authorizationStatus(for: .contacts)

        switch status {
        case .authorized, .limited:
            fetchFavouriteContacts(store: store, ids: ids)
        case .notDetermined:
            store.requestAccess(for: .contacts) { _, _ in
                DispatchQueue.main.async { loadFavourites() }
            }
        default:
            break
        }
    }

    private func fetchFavouriteContacts(store: CNContactStore, ids: [String]) {
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
        ]

        var loaded: [FavouriteContact] = []
        for id in ids {
            if let contact = try? store.unifiedContact(withIdentifier: id, keysToFetch: keysToFetch),
               let phone = contact.phoneNumbers.first?.value.stringValue {
                let name = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                loaded.append(FavouriteContact(id: id, name: name.lowercased(), number: phone.replacingOccurrences(of: " ", with: "")))
            }
        }

        DispatchQueue.main.async {
            favourites = loaded
        }
    }

    private func removeFavourite(_ contactID: String) {
        var ids = UserDefaults.standard.stringArray(forKey: "favouriteContactIDs") ?? []
        ids.removeAll { $0 == contactID }
        UserDefaults.standard.set(ids, forKey: "favouriteContactIDs")
        favourites.removeAll { $0.id == contactID }
    }
}

// MARK: - Contact List (native SwiftUI)

struct ContactEntry: Identifiable {
    let id: String
    let name: String
    let number: String
}

struct ContactListView: View {
    @EnvironmentObject var theme: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @State private var contacts: [ContactEntry] = []
    @State private var search = ""
    @State private var authorized = false
    @State private var denied = false
    @State private var limitedAccess = false

    private var filtered: [ContactEntry] {
        if search.isEmpty { return contacts }
        return contacts.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        ZStack {
            theme.colors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("cancel")
                            .font(.system(size: 21, weight: .light))
                            .foregroundColor(theme.colors.dimText)
                    }
                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                .padding(.bottom, 16)

                // Search
                TextField("search", text: $search)
                    .font(.system(size: 17, weight: .light))
                    .foregroundColor(theme.colors.mainText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(theme.colors.searchBg)
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 12)
                    .autocorrectionDisabled()

                // Contact list
                Rectangle().fill(theme.colors.lineColor).frame(height: 0.5).padding(.horizontal, 40)

                if denied {
                    Spacer()
                    VStack(spacing: 8) {
                        Text("contacts access denied")
                            .font(.system(size: 21, weight: .light))
                            .foregroundColor(theme.colors.mainText)
                        Text("grant full access in settings > privacy > contacts")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(theme.colors.dimText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 40)
                    Spacer()
                } else if !authorized {
                    Spacer()
                    Text("loading contacts...")
                        .font(.system(size: 21, weight: .light))
                        .foregroundColor(theme.colors.dimText)
                    Spacer()
                } else if filtered.isEmpty {
                    Spacer()
                    Text(search.isEmpty ? "no contacts found" : "no matches")
                        .font(.system(size: 21, weight: .light))
                        .foregroundColor(theme.colors.dimText)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(filtered) { contact in
                                Button {
                                    saveFavourite(contact.id)
                                    dismiss()
                                } label: {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(contact.name)
                                            .font(.system(size: 21, weight: .light))
                                            .foregroundColor(theme.colors.mainText)
                                        Text(contact.number)
                                            .font(.system(size: 14, weight: .light))
                                            .foregroundColor(theme.colors.dimText)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 14)
                                }
                                .buttonStyle(LauncherButtonStyle())

                                Rectangle().fill(theme.colors.lineColor).frame(height: 0.5)
                            }

                            if limitedAccess {
                                Text("only showing contacts you've shared -- grant full access in settings > privacy > contacts")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(theme.colors.dimText)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 20)
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                }
            }
        }
        .preferredColorScheme(theme.colorScheme)
        .onAppear { fetchContacts() }
    }

    private func fetchContacts() {
        let store = CNContactStore()
        let status = CNContactStore.authorizationStatus(for: .contacts)

        switch status {
        case .authorized:
            loadAllContacts(store: store)
        case .limited:
            DispatchQueue.main.async { limitedAccess = true }
            loadAllContacts(store: store)
        case .notDetermined:
            store.requestAccess(for: .contacts) { _, _ in
                DispatchQueue.main.async { fetchContacts() }
            }
        default:
            DispatchQueue.main.async { denied = true }
        }
    }

    private func loadAllContacts(store: CNContactStore) {
        let keys: [CNKeyDescriptor] = [
            CNContactIdentifierKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
        ]
        let request = CNContactFetchRequest(keysToFetch: keys)
        request.sortOrder = .givenName

        var results: [ContactEntry] = []
        try? store.enumerateContacts(with: request) { contact, _ in
            guard let phone = contact.phoneNumbers.first?.value.stringValue else { return }
            let name = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
            guard !name.isEmpty else { return }
            results.append(ContactEntry(id: contact.identifier, name: name.lowercased(), number: phone))
        }

        DispatchQueue.main.async {
            contacts = results
            authorized = true
        }
    }

    private func saveFavourite(_ contactID: String) {
        var ids = UserDefaults.standard.stringArray(forKey: "favouriteContactIDs") ?? []
        if !ids.contains(contactID) {
            ids.append(contactID)
            UserDefaults.standard.set(ids, forKey: "favouriteContactIDs")
        }
    }
}

// MARK: - Dialer

struct DialerView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var number = ""

    private let keys = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["*", "0", "#"],
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Number display
            Text(number.isEmpty ? " " : number)
                .font(.system(size: 36, weight: .ultraLight))
                .foregroundColor(theme.colors.mainText)
                .kerning(2)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)

            // Keypad
            VStack(spacing: 16) {
                ForEach(keys, id: \.self) { row in
                    HStack(spacing: 32) {
                        ForEach(row, id: \.self) { key in
                            Button {
                                number.append(key)
                            } label: {
                                Text(key)
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundColor(theme.colors.mainText)
                                    .frame(width: 64, height: 64)
                            }
                            .buttonStyle(LauncherButtonStyle())
                        }
                    }
                }
            }

            // Call and delete row
            HStack(spacing: 32) {
                Button {
                    if !number.isEmpty { number.removeLast() }
                } label: {
                    Image(systemName: "delete.left")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(theme.colors.dimText)
                        .frame(width: 64, height: 64)
                }
                .buttonStyle(LauncherButtonStyle())

                Button {
                    guard !number.isEmpty,
                          let url = URL(string: "tel:\(number)") else { return }
                    UIApplication.shared.open(url)
                } label: {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 20))
                        .foregroundColor(theme.colors.callButtonText)
                        .frame(width: 64, height: 64)
                        .background(theme.colors.callButton)
                        .clipShape(Circle())
                }
                .buttonStyle(LauncherButtonStyle())

                Color.clear
                    .frame(width: 64, height: 64)
            }
            .padding(.top, 24)

            Spacer()
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(dismiss: dismiss) }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let dismiss: DismissAction
        init(dismiss: DismissAction) { self.dismiss = dismiss }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss()
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            dismiss()
        }
    }
}

struct LauncherButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.4 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}

#Preview("Phone") {
    PhoneView()
        .environmentObject(ThemeManager())
}
