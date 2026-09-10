//
//  EditProfileView.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {

    @Environment(\.dismiss)
    private var dismiss

    @AppStorage("flixora_profile_name")
    private var storedName = "Flixora User"

    @AppStorage("flixora_profile_email")
    private var storedEmail = "user@flixora.com"

    @AppStorage("flixora_profile_phone")
    private var storedPhone = ""

    @AppStorage("flixora_profile_dob")
    private var storedDOB = ""

    @AppStorage("flixora_profile_gender")
    private var storedGender = "Prefer not to say"

    @AppStorage("flixora_profile_bio")
    private var storedBio = ""

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var dateOfBirth = ""
    @State private var gender = "Prefer not to say"
    @State private var bio = ""

    @AppStorage("flixora_profile_image")
    private var storedProfileImage = Data()

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: UIImage?

    @State private var pendingProfileImageData: Data?
    @State private var showRemovePhotoAlert = false

    @State private var showDiscardAlert = false

    private let genders = [
        "Male",
        "Female",
        "Non-binary",
        "Prefer not to say"
    ]

    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {

            VStack(spacing: 24) {

                profilePhotoSection

                personalInformationSection

                bioSection

                saveButton
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadProfile()
        }
    }
}

// MARK: - Profile Photo

private extension EditProfileView {

    var profilePhotoSection: some View {

        VStack(spacing: 14) {

            ZStack(alignment: .bottomTrailing) {

                profileImageView
                    .frame(
                        width: 110,
                        height: 110
                    )
                    .clipShape(Circle())

                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {

                    ZStack {

                        Circle()
                            .fill(Color.red)
                            .frame(
                                width: 36,
                                height: 36
                            )

                        Image(
                            systemName: "camera.fill"
                        )
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.white)
                    }
                    .overlay {

                        Circle()
                            .stroke(
                                Color(.systemBackground),
                                lineWidth: 3
                            )
                    }
                }
                .offset(
                    x: -2,
                    y: -4
                )
            }

            HStack(spacing: 18) {

                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {

                    Label(
                        profileImage == nil
                            ? "Add Photo"
                            : "Change Photo",
                        systemImage: "photo"
                    )
                    .font(
                        .subheadline.weight(
                            .semibold
                        )
                    )
                    .foregroundStyle(.red)
                }

                if profileImage != nil {

                    Button {

                        showRemovePhotoAlert = true

                    } label: {

                        Label(
                            "Remove",
                            systemImage: "trash"
                        )
                        .font(
                            .subheadline.weight(
                                .semibold
                            )
                        )
                        .foregroundStyle(.red)
                    }
                }
            }
        }
        .task(id: selectedPhoto) {

            await loadSelectedPhoto()
        }
        .alert(
            "Remove Profile Photo?",
            isPresented: $showRemovePhotoAlert
        ) {

            Button(
                "Cancel",
                role: .cancel
            ) {}

            Button(
                "Remove",
                role: .destructive
            ) {

                removeProfilePhoto()
            }

        } message: {

            Text(
                "Your profile photo will be removed when you save your changes."
            )
        }
    }

    @ViewBuilder
    var profileImageView: some View {

        if let profileImage {

            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()

        } else {

            ZStack {

                Circle()
                    .fill(
                        Color.red.opacity(0.12)
                    )

                Image(
                    systemName:
                        "person.crop.circle.fill"
                )
                .font(.system(size: 100))
                .foregroundStyle(.red)
            }
        }
    }
}

// MARK: - Personal Information

private extension EditProfileView {

    var personalInformationSection: some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            sectionHeader(
                title: "Personal Information",
                icon: "person.fill"
            )

            profileTextField(
                title: "Full Name",
                icon: "person",
                text: $name
            )

            profileTextField(
                title: "Email",
                icon: "envelope",
                text: $email,
                keyboardType: .emailAddress
            )

            profileTextField(
                title: "Phone Number",
                icon: "phone",
                text: $phone,
                keyboardType: .phonePad
            )

            profileTextField(
                title: "Date of Birth",
                icon: "calendar",
                text: $dateOfBirth,
                placeholder: "DD/MM/YYYY"
            )

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                Text("Gender")
                    .font(
                        .system(
                            size: 13,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(.secondary)

                HStack(spacing: 10) {

                    Image(systemName: "person.2")
                        .foregroundStyle(.red)
                        .frame(width: 24)

                    Picker(
                        "Gender",
                        selection: $gender
                    ) {

                        ForEach(genders, id: \.self) { value in

                            Text(value)
                                .tag(value)
                        }
                    }
                    .pickerStyle(.menu)

                    Spacer()
                }
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(
                    Color.gray.opacity(0.10)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
            }
        }
    }
}

// MARK: - Bio

private extension EditProfileView {

    var bioSection: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            sectionHeader(
                title: "About You",
                icon: "text.alignleft"
            )

            ZStack(alignment: .topLeading) {

                if bio.isEmpty {

                    Text("Tell us a little about yourself...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(
                            EdgeInsets(
                                top: 16,
                                leading: 14,
                                bottom: 0,
                                trailing: 14
                            )
                        )
                }

                TextEditor(text: $bio)
                    .font(.subheadline)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .frame(height: 120)
            }
            .background(
                Color.gray.opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14
                )
            )
        }
    }
}

// MARK: - Save

private extension EditProfileView {

    var saveButton: some View {

        Button {

            saveProfile()

        } label: {

            HStack(spacing: 8) {

                Image(systemName: "checkmark")

                Text("Save Changes")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                Color.red
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 15
                )
            )
        }
        .padding(.top, 4)
    }
}

// MARK: - Components

private extension EditProfileView {

    func sectionHeader(
        title: String,
        icon: String
    ) -> some View {

        HStack(spacing: 8) {

            Image(systemName: icon)
                .foregroundStyle(.red)

            Text(title)
                .font(.title3.bold())
        }
    }

    func profileTextField(
        title: String,
        icon: String,
        text: Binding<String>,
        placeholder: String = "",
        keyboardType: UIKeyboardType = .default
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(title)
                .font(
                    .system(
                        size: 13,
                        weight: .medium
                    )
                )
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {

                Image(systemName: icon)
                    .foregroundStyle(.red)
                    .frame(width: 24)

                TextField(
                    placeholder.isEmpty
                        ? title
                        : placeholder,
                    text: text
                )
                .keyboardType(keyboardType)
                .textInputAutocapitalization(
                    title == "Email"
                        ? .never
                        : .words
                )
                .autocorrectionDisabled()
            }
            .padding(.horizontal, 14)
            .frame(height: 52)
            .background(
                Color.gray.opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14
                )
            )
        }
    }
}

// MARK: - Persistence

private extension EditProfileView {

    func loadProfile() {

        name = storedName
        email = storedEmail
        phone = storedPhone
        dateOfBirth = storedDOB
        gender = storedGender
        bio = storedBio

        if !storedProfileImage.isEmpty {

            profileImage = UIImage(
                data: storedProfileImage
            )

        } else {

            profileImage = nil
        }

        pendingProfileImageData =
            storedProfileImage
    }

    func saveProfile() {

        storedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        storedEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        storedPhone = phone.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        storedDOB = dateOfBirth.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        storedGender = gender

        storedBio = bio.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if let pendingProfileImageData {

            storedProfileImage =
                pendingProfileImageData
        }

        dismiss()
    }
}

// MARK: - Photo Handling

private extension EditProfileView {

    func loadSelectedPhoto() async {

        guard let selectedPhoto else {
            return
        }

        do {

            guard let data =
                try await selectedPhoto.loadTransferable(
                    type: Data.self
                )
            else {
                return
            }

            guard let image = UIImage(
                data: data
            )
            else {
                return
            }

            await MainActor.run {

                profileImage = image

                pendingProfileImageData =
                    image.jpegData(
                        compressionQuality: 0.8
                    )
            }

        } catch {

            print(
                "Failed to load profile photo:",
                error.localizedDescription
            )
        }
    }

    func removeProfilePhoto() {

        profileImage = nil

        pendingProfileImageData = Data()
    }
}
