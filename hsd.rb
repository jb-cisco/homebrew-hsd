class Hsd < Formula
  desc "hsd"
  version "1.16"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.16/hsd-darwin-arm64"
      sha256 "37338a4d002173684653f2ea1e298f6a375138991e942a4e1e2d9c6358acd21e"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.16/hsd-darwin-amd64"
      sha256 "3be5979f1154140cdb30561ef4e7955b30efd1ecef44ff51152ded6bb66765b9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.16/hsd-linux-arm64"
      sha256 "9dbde321adda44ef51e84a9518d413ba43aeabf7ddc4b0b1d36e246fcc6c687f"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.16/hsd-linux-amd64"
      sha256 "5169a44e1f58bbbd14ffc169996dfcfbcdf79019419eeb4009ab66a04b3ee2af"
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