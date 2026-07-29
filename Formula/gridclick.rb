class Gridclick < Formula
  desc "Keyboard-driven mouse navigation for macOS"
  homepage "https://github.com/shubham-021/GridClick"
  url "https://github.com/shubham-021/GridClick/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "5c58ca7f3fc857ccbef8501cb2fa699cb59749a52b88de504791297305d1616e"
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
