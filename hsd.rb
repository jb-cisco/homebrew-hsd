class Hsd < Formula
  desc "hsd"
  version "1.14"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.14/hsd-darwin-arm64"
      sha256 "e8539b9b23092bfaef124d9b5d0fea0f224fd50b7f618e32759181ed49934fe5"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.14/hsd-darwin-amd64"
      sha256 "437325a5f6ab86957f8026a4fbdfa2d7ce0c566ed74136dfa219005e9455f140"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.14/hsd-linux-arm64"
      sha256 "6b9b98661cb67319dd473d17091ad752676faea3f645c73fe1940fde5fb532ee"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.14/hsd-linux-amd64"
      sha256 "b39d310b18a69822d6ec39f17aa1a685ba99a3fdbd30236be08b8ccc017989a0"
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