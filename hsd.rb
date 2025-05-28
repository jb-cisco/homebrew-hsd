class Hsd < Formula
  desc "hsd"
  version "1.29"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.29/hsd-darwin-arm64"
      sha256 "6383b39385d8b61f9a39b5e540b5d84c4e0ee0071fb2e272c70836f37eb106d9"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.29/hsd-darwin-amd64"
      sha256 "c0b8dbc7ddd85f25e595a13cc22036ea753b5f48096e3e27d15eb2c0048ccf20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.29/hsd-linux-arm64"
      sha256 "5c8f0075fced19831a0b947092d7832f661ecea2f3a232a270cb0c5e33d4e89a"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.29/hsd-linux-amd64"
      sha256 "ff14956b1133a249680a1c0add452b4919bb0e134be6eb3eb7d3d4a40fcbf26d"
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