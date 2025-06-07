class Hsd < Formula
  desc "hsd"
  version "1.41"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.41/hsd-darwin-arm64"
      sha256 "f5e0346eef39c249877beac4eccee1b907deb2d9354138117036821ebe64bf34"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.41/hsd-darwin-amd64"
      sha256 "1f598f21aacd0ba2fd919c1c61e903bbb6cba2000a2bd995946e302a2e200be8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.41/hsd-linux-arm64"
      sha256 "d77010b69fac3b621f264a5f20f16735ffbab5cc8cd5654f163858c585652eb8"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.41/hsd-linux-amd64"
      sha256 "e2dd92eee44a408ffa8387f63f9c9d706662c605bf6cfc05e524c26ad188bfad"
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