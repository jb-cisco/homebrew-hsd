class Hsd < Formula
  desc "hsd"
  version "1.40"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.40/hsd-darwin-arm64"
      sha256 "f8d8db21c45748ea43f4e3cb7cb760b9633cb473d5b7b741fbf874a4e0d531eb"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.40/hsd-darwin-amd64"
      sha256 "1dfb19128866951ecee5133f5f0a4ca552fed4114127fefe98857ff8cc48b988"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.40/hsd-linux-arm64"
      sha256 "43e9736c26e886bf34116d22963a7ef5019cb33e08b1869755fa4dfba7d41256"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.40/hsd-linux-amd64"
      sha256 "792c2ddbf40b8f20011e17063e5eb4bd8922af469a1906109c232b79e43f4830"
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