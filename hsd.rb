class Hsd < Formula
  desc "hsd"
  version "1.38"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.38/hsd-darwin-arm64"
      sha256 "40f5d0b93c500cfcada0470c00a956b9d855576005b780975538a9ee3dd3dea2"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.38/hsd-darwin-amd64"
      sha256 "f303385ecc58bf8833a6f0748737ccbba66acfd0516bae344152c572c4f62f0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.38/hsd-linux-arm64"
      sha256 "89e1620cf2447c7dc2ef57c545c58063cdae4113abbaad7c8f2cce6aae2b8ff3"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.38/hsd-linux-amd64"
      sha256 "f5a0f178dccc9b7bce4381f0ea5de1918c1077d0fd49380f06096714fdb8a1a0"
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