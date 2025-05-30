class Hsd < Formula
  desc "hsd"
  version "1.31"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.31/hsd-darwin-arm64"
      sha256 "495c58e322b03b1968f62cbc60168acc2bc5fed807cce5fa48a8cb9c3f6c4eca"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.31/hsd-darwin-amd64"
      sha256 "1cc4ab6f0a4ab33634b94bfcab268f2163c25a98bd2d306953951cd2c14bc77d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.31/hsd-linux-arm64"
      sha256 "ff94b800574f4cd4347080c8fd5a99ea9a40be91eb12bd54d854b28ed8627623"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.31/hsd-linux-amd64"
      sha256 "1c7049d5f5250f70134853eb25d95cdf7f46e683f6d377f07c1d8ea65e02762f"
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