class Hsd < Formula
  desc "hsd"
  version "1.34"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.34/hsd-darwin-arm64"
      sha256 "c14ab1e3a36996a3efe1ce110a01448eb6d580fa724dd2041407b93902dec502"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.34/hsd-darwin-amd64"
      sha256 "ed6c42dd38cb843ee7b892b16c15d5d5901e7abeb551172d0610556eb9aec833"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.34/hsd-linux-arm64"
      sha256 "c75d284f9c1dc42b096c54a37c2ea0d87edcceec9237af7f131a932ed4ec1794"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.34/hsd-linux-amd64"
      sha256 "d79e93f4b9a18686b10b9968b756d0122e79c3a755188c2fc6624e6ebffbc0d8"
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