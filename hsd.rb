class Hsd < Formula
  desc "hsd"
  version "1.28"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.28/hsd-darwin-arm64"
      sha256 "45a6114c64c261ae9a6d1593227724f72cb2ecb03129c7cebfef1a9818ae1069"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.28/hsd-darwin-amd64"
      sha256 "767a8256d958fc34a64542c49e9e93c1c876904b1163318b55afdc6a14195ea3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.28/hsd-linux-arm64"
      sha256 "148c5fb1fa847e6897afc9875cb4864417b7425387d87c81bd52bf065937e336"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.28/hsd-linux-amd64"
      sha256 "277329cf9090e7becf3d91a2cb3a9af8e83b2217bd842e7b2f09e9ce77b75ea4"
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