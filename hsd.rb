class Hsd < Formula
  desc "hsd"
  version "1.19"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.19/hsd-darwin-arm64"
      sha256 "eaa4c8fb1f2070329b59a6e085f1e463725cd41bd92e39cf38461df2210cf252"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.19/hsd-darwin-amd64"
      sha256 "3c9251deb4c4456dc3eccf8c061368f35390e6d9806d653980b80e070cebc9b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.19/hsd-linux-arm64"
      sha256 "fd51ad510e12aa3915642bae90c945b9bb88a536d56a04ef7d370b2ab0896961"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.19/hsd-linux-amd64"
      sha256 "cb43e1416543c08e63915331883a9fc2d2b355d616f4eb53565e48f19d0c5d73"
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