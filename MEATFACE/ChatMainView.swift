import SwiftUI

struct ChatMainView: View {
    @Binding var activeScene: String
    @EnvironmentObject var vm: ChatViewModel
    @EnvironmentObject var fontManager: FontManager
    @StateObject var threadStore = ThreadStore()

    @State private var showingSettings = false
    @State private var showSidebar = true
    @State private var sidebarWidth: CGFloat = 240
    @State private var scrollTag: String? = nil
    @State private var mouseLocation: CGPoint = .zero
    @State private var glowSize: CGFloat = 22
    @State private var showSummary = false
    
    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack {
            GhostCursorBloom(position: $mouseLocation)
            Color.black.ignoresSafeArea()

            HStack(spacing: 0) {
                if showSidebar {
                    sidebarSection
                }

                Divider().background(Color.gray.opacity(0.3))

                VStack(spacing: 0) {
                    messageFeed
                    Divider().background(Color.gray.opacity(0.3))
                    inputBar
                }
            }

            if let tag = scrollTag {
                Text("⇌ \(tag)")
                    .font(.custom("Andale Mono", size: 11))
                    .foregroundColor(.gray)
                    .padding(.bottom, 6)
                    .transition(.opacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }

            topOverlay
        }
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                mouseLocation = CGPoint(
                    x: event.locationInWindow.x,
                    y: NSScreen.main?.frame.height ?? 800 - event.locationInWindow.y
                )
                glowSize = 28
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    glowSize = 22
                }
                return event
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }

    private var sidebarSection: some View {
        SidebarView(threadStore: threadStore)
            .frame(width: sidebarWidth)
            .background(Color.black.opacity(0.4))
            .font(fontManager.font(for: .sidebar))
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged { gesture in
                        let newWidth = max(180, min(360, sidebarWidth + gesture.translation.width))
                        sidebarWidth = newWidth
                    }
            )
    }


    private var messageFeed: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(vm.messages, id: \.id) { msg in
                            HStack {
                                if msg.isBob {
                                    MessageBubble(msg: msg)
                                    Spacer()
                                } else {
                                    Spacer()
                                    MessageBubble(msg: msg)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .id(msg.id)
                        }
                    }
                    .padding(.top, 10)
                }

                // ⬇️ FLOATING DOT + SUMMARY POPUP
                VStack {
                    if showSummary {
                        ResponseSummaryPopup(
                          foil: vm.lastFoil,
                          summary1: vm.lastSummary1,
                          summary2: vm.lastSummary2,
                          isVisible: $showSummary
                        )

                    Button(action: { showSummary.toggle() }) {
                        Circle()
                            .fill(showSummary ? Color.mint : Color.gray)
                            .frame(width: 12, height: 12)
                            .shadow(color: showSummary ? .mint : .clear, radius: 5)
                    }
                    .padding(.bottom, 6)
                }
                .padding(.trailing, 8)
            }
            .onChange(of: vm.messages.count) {
                if let last = vm.messages.last {
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }


    private var inputBar: some View {
        HStack(alignment: .bottom) {
            CustomTextView(text: $vm.inputText) {
                vm.sendToBob()
            }
            .frame(minHeight: 60, maxHeight: 120)
            .background(Color.white.opacity(0.2))
            .cornerRadius(0)
            .focusable(true)

            Button("send") {
                vm.sendToBob()
            }
            .frame(minHeight: 60)
            .padding(.horizontal)
        }
        .padding()
        .background(Color.black.opacity(0.7))
    }

    private var topOverlay: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showingSettings.toggle() }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.gray)
                            .padding(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .zIndex(99)
    }
}
