class Gridclick < Formula
  desc "Keyboard-driven mouse navigation for macOS"
  homepage "https://github.com/shubham-021/GridClick"
  url "https://github.com/shubham-021/GridClick/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "89127fc1039b1564fa94a80f44f16ebd08c597d1026edfb33e2f219ec5fb37db"
  license "MIT"

  depends_on :macos => :sonoma    # macOS 14+

  def install
    # Build the release binary
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Assemble the .app bundle
    app_dir = prefix/"GridClick.app/Contents"
    (app_dir/"MacOS").mkpath
    (app_dir/"Resources").mkpath

    cp ".build/release/GridClick", app_dir/"MacOS/GridClick"
    cp "Resources/Info.plist", app_dir/"Info.plist"
    cp "Resources/AppIcon.icns", app_dir/"Resources/AppIcon.icns"

    # Ad-hoc code sign (needed for Accessibility permission stability)
    system "codesign", "--force", "--deep", "--sign", "-",
           "--identifier", "com.shubham007.gridclick",
           prefix/"GridClick.app"
  end

  def caveats
    <<~EOS
      GridClick.app has been installed to:
        #{prefix}/GridClick.app

      To add to your Applications folder:
        ln -sf "#{prefix}/GridClick.app" "/Applications/GridClick.app"

      To start GridClick:
        open "#{prefix}/GridClick.app"

      On first launch, grant Accessibility permission:
        System Settings → Privacy & Security → Accessibility → Enable GridClick
    EOS
  end
end
