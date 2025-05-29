class Hsd < Formula
  desc "hsd"
  version "1.30"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.30/hsd-darwin-arm64"
      sha256 "34f370f2b038a64ed4b9f085bda456a90628e3762d95ab73a41bb15fe68a04f3"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.30/hsd-darwin-amd64"
      sha256 "8ba9d689e01345f68060e8dd5f2d1bae0bece87e87e85f35bf8c9d70018dec8a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.30/hsd-linux-arm64"
      sha256 "9b3155a64f66a6349bd61028db09c096e348bec3d80434d4a8f9b8acefa75974"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.30/hsd-linux-amd64"
      sha256 "d1ae5cf6e4096163a302a3320d8b6ca71e6bab94891fb57f3a32ce3a5e9870da"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "hsd-#{os}-#{arch}" => "hsd"
  end

  def post_install
    config_path = File.expand_path("~/.hsd")
    unless File.exist?(config_path)
      opoo "No existing hsd config found. Run: hsd config init"
    end

    if OS.mac?
      recommended = ["awscli", "kubernetes-cli", "helm"]
    else
      # For Linux, the package names might be different
      recommended = ["awscli", "kubernetes-cli", "helm"]
    end

    missing = recommended.reject do |pkg|
      quiet_system "brew", "list", "--formula", pkg
    end
    
    unless missing.empty?
      ohai "Recommended Homebrew packages missing: #{missing.join(', ')}"
      ohai "You can install them with:"
      ohai "  brew install #{missing.join(' ')}"
    end
  end
end