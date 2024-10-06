// //
// //  FeedbackFlow.swift
// //  Res
// //
// //  Created by Steven Sarmiento on 9/19/24.
// //

// //
// //  FeedbackFlow.swift
// //  Res
// //
// //  Created by Steven Sarmiento on 9/19/24.
// //

// import MessageUI
// import SwiftUI

// struct FeedbackFlow: View {
//     @Binding var isPresented: Bool
//     @State private var feedbackStep = 1
//     @State private var selectedFeedbackType: FeedbackType?
//     @State private var selectedAppParts: Set<AppPart> = []
//     @State private var feedbackSubject = ""
//     @State private var feedbackText = ""
//     @State private var isShowingMailView = false
//     @State private var mailResult: Result<MFMailComposeResult, Error>?

//     @StateObject private var keyboardResponder = KeyboardResponder()

//     var body: some View {
//         feedbackModalContent(keyboardResponder: keyboardResponder)
//             .sheet(isPresented: $isShowingMailView) {
//                 MailView(
//                     isShowing: $isShowingMailView, result: $mailResult,
//                     subject: prepareEmailSubject(),
//                     messageBody: prepareEmailBody(),
//                     toRecipients: ["feedback@example.com"])
//             }
//             .background(Color(red: 0.945, green: 0.945, blue: 0.918))

//     }

//     private func feedbackModalContent(keyboardResponder: KeyboardResponder) -> some View {
//         VStack {
//             ZStack {
//                 HStack {
//                     ZStack {
//                         HStack {
//                             Image(systemName: "bubble.left.and.bubble.right.fill")
//                                 .resizable()
//                                 .foregroundColor(.white.opacity(0.05))
//                                 .frame(width: 85, height: 85)
//                             Spacer()
//                         }
//                         .offset(x: 10, y: -15)

//                         HStack {
//                             VStack(alignment: .leading) {
//                                 Text(feedbackStepTitle)
//                                     .font(.system(size: 20, design: .rounded))
//                                     .bold()
//                                     .foregroundColor(Color.white.opacity(1))
//                                     .padding(.bottom, 2)
//                             }
//                             .padding(.horizontal)
//                             .offset(x: 10)
//                             Spacer()
//                         }
//                     }
//                 }
//             }
//             .overlay(
//                 XMarkButton {
//                     withAnimation(.easeOut(duration: 0.15)) {
//                         if feedbackStep > 1 {
//                             feedbackStep -= 1
//                         } else {
//                             isPresented = false
//                         }
//                     }
//                 }
//                 .offset(x: -20, y: 0),
//                 alignment: .topTrailing
//             )

//             VStack {
//                 switch feedbackStep {
//                 case 1:
//                     feedbackTypeSelection()
//                 case 2:
//                     appPartSelection()
//                 case 3:
//                     feedbackInput()
//                 default:
//                     EmptyView()
//                 }
//             }
//             .padding(.horizontal, 20)

//             if feedbackStep > 1 {
//                 continueButton()
//             }
//         }
//         .padding(.vertical)
//         .onTapGesture {
//             // This empty gesture prevents taps from dismissing the modal
//         }
//     }

//     private func continueButton() -> some View {
//         VStack {
//             ZStack {
//                 RoundedRectangle(cornerRadius: 18)
//                     .foregroundColor(Color.white)
//                     .frame(height: 60)
//                 HStack {
//                     Text(feedbackStep < 3 ? "Continue" : "Send Email")
//                         .font(.system(.title2, design: .rounded))
//                         .fontWeight(.bold)
//                         .foregroundColor(.black)
//                 }
//             }
//             .onTapGesture {
//                 if feedbackStep < 3 {
//                     if (feedbackStep == 1 && selectedFeedbackType != nil)
//                         || (feedbackStep == 2 && !selectedAppParts.isEmpty)
//                     {
//                         feedbackStep += 1
//                     }
//                 } else {
//                     isShowingMailView = true
//                 }
//             }
//             .padding(.top, 5)
//             .pressAnimation()
//             .opacity(
//                 (feedbackStep == 1 && selectedFeedbackType != nil)
//                     || (feedbackStep == 2 && !selectedAppParts.isEmpty) || feedbackStep == 3
//                     ? 1 : 0.5)
//         }
//         .padding(.horizontal, 20)
//     }

//     private func feedbackTypeSelection() -> some View {
//         VStack(spacing: 10) {
//             ForEach(FeedbackType.allCases, id: \.self) { type in
//                 Button(action: {
//                     softHaptic()
//                     selectedFeedbackType = type
//                     feedbackStep = 2
//                 }) {
//                     HStack(alignment: .center) {
//                         HStack(alignment: .top) {
//                             ZStack {
//                                 Circle()
//                                     .fill(Color.white.opacity(0.1))
//                                     .frame(width: 36, height: 36)

//                                 Image(systemName: type.iconName)
//                                     .font(.system(size: 16))
//                                     .bold()
//                                     .foregroundColor(.white.opacity(0.6))
//                             }
//                             .padding(.trailing, 5)

//                             VStack(alignment: .leading, spacing: 2) {
//                                 Text(type.rawValue)
//                                     .fontDesign(.rounded)
//                                     .font(.system(size: 16))
//                                     .foregroundColor(.white)
//                                     .bold()

//                                 Text(type.description)
//                                     .fontDesign(.monospaced)
//                                     .font(.system(size: 12))
//                                     .foregroundColor(.white.opacity(0.6))
//                                     .multilineTextAlignment(.leading)
//                             }
//                         }

//                         Spacer()
//                     }
//                     .padding()
//                     .background(
//                         RoundedRectangle(cornerRadius: 16)
//                             .foregroundColor(Color.white.opacity(0.07))
//                     )
//                 }
//                 .pressAnimation()
//             }
//         }
//     }

//     private func appPartSelection() -> some View {
//         VStack(alignment: .leading, spacing: 0) {
//             ForEach(AppPart.allCases, id: \.self) { part in
//                 VStack {
//                     Button(action: {
//                         softHaptic()
//                         if selectedAppParts.contains(part) {
//                             selectedAppParts.remove(part)
//                         } else {
//                             selectedAppParts.insert(part)
//                         }
//                     }) {
//                         HStack {
//                             ZStack {
//                                 Image(systemName: part.iconName)
//                                     .font(.system(size: 16))
//                                     .bold()
//                                     .foregroundColor(.white.opacity(0.6))
//                             }
//                             .padding(.trailing, 5)

//                             VStack(alignment: .leading) {
//                                 Text(part.rawValue)
//                                     .fontDesign(.rounded)
//                                     .font(.system(size: 16))
//                                     .foregroundColor(.white)
//                                     .bold()
//                             }
//                             Spacer()
//                             Image(
//                                 systemName: selectedAppParts.contains(part)
//                                     ? "checkmark.circle.fill" : "circle.dashed"
//                             )
//                             .foregroundColor(
//                                 selectedAppParts.contains(part) ? .green : .white.opacity(0.3)
//                             )
//                             .contentTransition(.symbolEffect(.replace.offUp.byLayer))
//                         }
//                         .padding(.vertical, 10)
//                         .padding(.horizontal, 15)
//                         .background(
//                             RoundedRectangle(cornerRadius: 12)
//                                 .fill(
//                                     Color.white.opacity(selectedAppParts.contains(part) ? 0.1 : 0))
//                         )
//                     }
//                     .padding(.vertical, 5)
//                 }
//             }
//         }
//     }

//     private func feedbackInput() -> some View {
//         VStack(alignment: .leading, spacing: 15) {
//             CustomTextField(text: $feedbackSubject, placeholder: "Subject")

//             CustomTextArea(text: $feedbackText, placeholder: placeholderForFeedbackType)
//                 .frame(height: 150)
//         }
//     }

//     private func prepareEmailSubject() -> String {
//         let typeString = selectedFeedbackType?.rawValue ?? "Feedback"
//         let partString =
//             selectedAppParts.isEmpty
//             ? "App" : selectedAppParts.map { $0.rawValue }.joined(separator: ", ")
//         return "[ \(feedbackSubject)\(typeString)] [\(partString)]"
//     }

//     private func prepareEmailBody() -> String {
//         """
//         Feedback Type: \(selectedFeedbackType?.rawValue ?? "Not specified")
//         App Parts: \(selectedAppParts.isEmpty ? "Not specified" : selectedAppParts.map { $0.rawValue }.joined(separator: ", "))

//         Feedback:
//         \(feedbackText)
//         """
//     }

//     private func sendEmail() {
//         if MFMailComposeViewController.canSendMail() {
//             isShowingMailView = true
//         } else {
//             // Handle the case where the device can't send emails
//             print("Device can't send emails")
//         }
//     }

//     private var placeholderForFeedbackType: String {
//         switch selectedFeedbackType {
//         case .bugReport:
//             return
//                 "Please describe the issue you're experiencing in detail. Include steps to reproduce if possible."
//         case .feedback:
//             return "Share some feedback on how to improve Senkō."
//         case .generalComment:
//             return "Let us know what you think about Senkō. We love hearing from you!"
//         case .none:
//             return "Describe your feedback in more detail"
//         }
//     }

//     private var feedbackStepTitle: String {
//         switch feedbackStep {
//         case 1:
//             return "How can I help?"
//         case 2:
//             return "Choose areas of focus."
//         case 3:
//             return "Add details for your feedback."
//         default:
//             return "Help us improve Senkō"
//         }
//     }
// }

// enum FeedbackType: String, CaseIterable {
//     case bugReport = "Report Bug"
//     case feedback = "Share Feedback"
//     case generalComment = "Something Else"

//     var iconName: String {
//         switch self {
//         case .bugReport: return "ant.fill"
//         case .feedback: return "text.bubble.fill"
//         case .generalComment: return "lightbulb.fill"
//         }
//     }

//     var description: String {
//         switch self {
//         case .bugReport: return "Let me know about a specific issue you're experiencing."
//         case .feedback: return "How can I improve Senkō? Provide suggestions or ideas."
//         case .generalComment:
//             return "Request a new feature, leave a nice comment, or anything else."
//         }
//     }
// }

// enum AppPart: String, CaseIterable {
//     case camera = "Camera"
//     case photoFeed = "Photo Feed"
//     case photoLab = "Photo Lab"
//     case settings = "Settings"
//     case userInterface = "User Interface"
//     case performance = "Performance"
//     case other = "Other"

//     var iconName: String {
//         switch self {
//         case .camera: return "camera.fill"
//         case .photoFeed: return "photo.on.rectangle.angled"
//         case .photoLab: return "wand.and.stars"
//         case .settings: return "gearshape.fill"
//         case .userInterface: return "iphone"
//         case .performance: return "gauge.with.needle.fill"
//         case .other: return "questionmark.circle.fill"
//         }
//     }
// }

// struct MailView: UIViewControllerRepresentable {
//     @Binding var isShowing: Bool
//     @Binding var result: Result<MFMailComposeResult, Error>?

//     let subject: String
//     let messageBody: String
//     let toRecipients: [String]

//     class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
//         @Binding var isShowing: Bool
//         @Binding var result: Result<MFMailComposeResult, Error>?

//         init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
//             _isShowing = isShowing
//             _result = result
//         }

//         func mailComposeController(
//             _ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult,
//             error: Error?
//         ) {
//             defer {
//                 isShowing = false
//             }
//             if let error = error {
//                 self.result = .failure(error)
//             } else {
//                 self.result = .success(result)
//             }
//         }
//     }

//     func makeCoordinator() -> Coordinator {
//         return Coordinator(isShowing: $isShowing, result: $result)
//     }

//     func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>)
//         -> MFMailComposeViewController
//     {
//         let vc = MFMailComposeViewController()
//         vc.mailComposeDelegate = context.coordinator
//         vc.setSubject(subject)
//         vc.setMessageBody(messageBody, isHTML: false)
//         vc.setToRecipients(toRecipients)

//         // Set the modal presentation style to full screen
//         vc.modalPresentationStyle = .fullScreen

//         return vc
//     }

//     func updateUIViewController(
//         _ uiViewController: MFMailComposeViewController,
//         context: UIViewControllerRepresentableContext<MailView>
//     ) {}
// }

// struct CustomTextField: View {
//     @Binding var text: String
//     let placeholder: String

//     var body: some View {
//         TextField(placeholder, text: $text)
//             .padding(.horizontal, 12)
//             .padding(.vertical, 10)
//             .background(Color.white.opacity(0.1))
//             .cornerRadius(12)
//             .overlay(
//                 RoundedRectangle(cornerRadius: 12)
//                     .stroke(Color.white.opacity(0.2), lineWidth: 1)
//             )
//             .foregroundColor(.white)
//     }
// }

// struct CustomTextArea: View {
//     @Binding var text: String
//     let placeholder: String

//     private struct TextEditorWithPlaceholder: View {
//         @Binding var text: String
//         let placeholder: String

//         @State private var placeholderOffset: CGPoint = .zero

//         var body: some View {
//             ZStack(alignment: .topLeading) {
//                 TextEditor(text: $text)
//                     .scrollContentBackground(.hidden)
//                     .background(Color.clear)
//                     .foregroundColor(.white)
//                     .padding(.horizontal, 10)
//                     .padding(.vertical, 2)
//                     .alignmentGuide(.leading) { d in
//                         DispatchQueue.main.async {
//                             self.placeholderOffset = CGPoint(x: -d[.leading], y: -d[.top])
//                         }
//                         return d[.leading]
//                     }

//                 if text.isEmpty {
//                     Text(placeholder)
//                         .foregroundColor(.white.opacity(0.3))
//                         .allowsHitTesting(false)
//                         .offset(x: placeholderOffset.x + 12, y: placeholderOffset.y + 10)
//                 }
//             }
//         }
//     }

//     var body: some View {
//         TextEditorWithPlaceholder(text: $text, placeholder: placeholder)
//             .background(Color.white.opacity(0.1))
//             .cornerRadius(12)
//             .overlay(
//                 RoundedRectangle(cornerRadius: 12)
//                     .stroke(Color.white.opacity(0.2), lineWidth: 1)
//             )
//     }
// }

// //struct XMarkButton: View {
// //    let action: () -> Void
// //
// //    var body: some View {
// //        Button(action: action) {
// //            Image(systemName: "xmark")
// //                .foregroundColor(.white)
// //                .padding(8)
// //                .background(Color.white.opacity(0.2))
// //                .clipShape(Circle())
// //        }
// //    }
// //}

// class KeyboardResponder: ObservableObject {
//     @Published var currentHeight: CGFloat = 0

//     init() {
//         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//     }

//     deinit {
//         NotificationCenter.default.removeObserver(self)
//     }

//     @objc func keyboardWillShow(notification: Notification) {
//         if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//             DispatchQueue.main.async {
//                 self.currentHeight = keyboardSize.height
//             }
//         }
//     }

//     @objc func keyboardWillHide(notification: Notification) {
//         DispatchQueue.main.async {
//             self.currentHeight = 0
//         }
//     }
// }

// //extension View {
// //    func pressAnimation() -> some View {
// //        self.buttonStyle(PressButtonStyle())
// //    }
// //}

// struct PressButtonStyle: ButtonStyle {
//     func makeBody(configuration: Configuration) -> some View {
//         configuration.label
//             .scaleEffect(configuration.isPressed ? 0.95 : 1)
//             .opacity(configuration.isPressed ? 0.9 : 1)
//             .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
//     }
// }
