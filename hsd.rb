class Hsd < Formula
  desc "hsd"
  version "1.42"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.42/hsd-darwin-arm64"
      sha256 "6764a59ec6083f1d33b72d2589fc62cae8f9c46d08eb9fc88898cd1b1b7825c8"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.42/hsd-darwin-amd64"
      sha256 "3adbba206cc4e14bfa810df03869232294a4e1a15c9cf686c5baeef7bd136c8a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.42/hsd-linux-arm64"
      sha256 "1539e9a865209e08ee5d5c69f6dd43546dfe53284443087411c1fe364ed0d421"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.42/hsd-linux-amd64"
      sha256 "b115df667d850963791605b7dbaebdf710ae9c298ba35ebe20804ed211d0eb27"
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