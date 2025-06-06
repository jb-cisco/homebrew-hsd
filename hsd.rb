class Hsd < Formula
  desc "hsd"
  version "1.35"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.35/hsd-darwin-arm64"
      sha256 "3a9a09df940e6d2a50574e48a674d87b09cfa032f867f8d022bbcad86610e86d"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.35/hsd-darwin-amd64"
      sha256 "0a1593bec6c369d5bfaae25b99c246b72a33e60141ed016412ba26a1872644b0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.35/hsd-linux-arm64"
      sha256 "9779f53db6b2d8fddec01809f57726f8426f69f4cab0c19d67348fba0180ce2b"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.35/hsd-linux-amd64"
      sha256 "d6730be7eab015dc24b5371685d3d9c42005e016734737a845dfe9401e26385b"
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