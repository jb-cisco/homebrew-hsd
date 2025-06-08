class Hsd < Formula
  desc "hsd"
  version "1.43"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.43/hsd-darwin-arm64"
      sha256 "ddef06d47b4fdf445b0f1aefe2035e9eac57f01f81524e14ffbf9d8013b475c9"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.43/hsd-darwin-amd64"
      sha256 "f0ab853d6a6012932db60f511353ded4376b7b0630446eafb3560f0e8e676467"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.43/hsd-linux-arm64"
      sha256 "d0703ff417c81a097fd8b342485cdf8159faff151f134bbfd2496777b3bab95e"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.43/hsd-linux-amd64"
      sha256 "fbacd6b8cafb7bd2df767638fbdcd7fc074182ad3ed6402c30dc9c13cf9efd3d"
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