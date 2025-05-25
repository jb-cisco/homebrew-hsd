class Hsd < Formula
  desc "hsd"
  version "1.17"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.17/hsd-darwin-arm64"
      sha256 "87c0afa2e718cb6ad8bef9eae7df8d777981bc8ab429899518e7e612a10b70e7"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.17/hsd-darwin-amd64"
      sha256 "9cca22bc0b82cd82847dd2d1c612780e3226aa959a9d5ac3b1e862a5afcf6712"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.17/hsd-linux-arm64"
      sha256 "56aa7a04ec97b072b63880bcad8286982eee30183e7af4ba5bb9925c969777e0"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.17/hsd-linux-amd64"
      sha256 "a3e0bf019ed1f74e5ed94da01aba7a87807887fcbcec4afc34b38a6c47375392"
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