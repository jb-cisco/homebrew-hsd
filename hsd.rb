class Hsd < Formula
  desc "hsd"
  version "1.9"

  on_arm do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.9/hsd-arm64"
    sha256 "84c4717add85e831c68d3a0a1f9933537c250bf62cc828bbfd5e3f987f100453"
  end

  on_intel do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.9/hsd-amd64"
    sha256 "1fdac90e470077e2573605fed2170bfd9e84d814841241d427d07b3ddfa40b5d"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "hsd-#{arch}" => "hsd"
  end

  def post_install
    config_path = File.expand_path("~/.hsd")
    unless File.exist?(config_path)
      opoo "No existing hsd config found. Run: hsd config init"
    end

    recommended = ["awscli", "kubernetes-cli", "helm"]
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