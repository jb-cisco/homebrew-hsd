class Hsd < Formula
  desc "hsd"
  version "1.15"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.15/hsd-darwin-arm64"
      sha256 "31d83a841324fdd30b9805906cd775d8f042c660e8fde36e2f389bc3d71421fe"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.15/hsd-darwin-amd64"
      sha256 "9aec1769091bfb0e9be975f26dad65306d35223e309fd9fbd1bf072d9a31d348"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.15/hsd-linux-arm64"
      sha256 "985408804605f23cfee9a2e1579cdb381fe6aa56b4d2caceb1324a8d0a308b5a"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.15/hsd-linux-amd64"
      sha256 "3e4c919ce47e0498c08b4774c0b49494d4ec4af11439cc02ea1792127110a7ce"
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