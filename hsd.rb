class Hsd < Formula
  desc "hsd"
  version "1.23"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.23/hsd-darwin-arm64"
      sha256 "0bc5da018d4c4a59ef76ad140770b80f85dd92258c5c28e868fde06db160c8f9"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.23/hsd-darwin-amd64"
      sha256 "89d4e1d732842effbe7a64fe9794ae2abef1bbee6ff926b746272289c7f20dd6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.23/hsd-linux-arm64"
      sha256 "41d75adb2ba576c0bb8119904f561688ea026f7ced946d365899ccf152e08bfe"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.23/hsd-linux-amd64"
      sha256 "06d4c6dbdb81996057d4707ac7717225567006066b55f1bc2ea1e6251945f3fb"
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