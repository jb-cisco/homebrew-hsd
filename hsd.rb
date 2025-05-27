class Hsd < Formula
  desc "hsd"
  version "1.20"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.20/hsd-darwin-arm64"
      sha256 "db56390ed6cd61e9adc810114a24262b2c32a805f42789129afa77e5ce783646"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.20/hsd-darwin-amd64"
      sha256 "8c2e7f1b29e00baebc8405b18657b1b6effefd5763ad7c09d9514f8169b2ff4f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.20/hsd-linux-arm64"
      sha256 "1889f05aecd9ebc58131bdc6d0fc07038e948e777ca7ef814004df8a1ca5be60"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.20/hsd-linux-amd64"
      sha256 "0fd7052f50be561dfde82d24abf63735f7089ec8e1afe050c5939d41a62ee8c0"
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