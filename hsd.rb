class Hsd < Formula
  desc "hsd"
  version "1.36"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.36/hsd-darwin-arm64"
      sha256 "e94caf267bbd84f0e4bb3e1be079be6416291eb9bfa549d7c3d206c59c33be13"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.36/hsd-darwin-amd64"
      sha256 "8686f16fa3b7ea54a3715ffa84e745c820a1d194bf04ad6425ca8cbe0720550d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.36/hsd-linux-arm64"
      sha256 "b09d67cc5f5be02416742d5d654468c5e744c4b52e1e7588eadd30be94b154f7"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.36/hsd-linux-amd64"
      sha256 "9cff1cc645b8c4ba58251727e6207e21d80bfeb07c61361052fa95a2c51aa500"
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