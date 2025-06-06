class Hsd < Formula
  desc "hsd"
  version "1.32"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.32/hsd-darwin-arm64"
      sha256 "3ae3f912311bb7a6dedcbd30f86426e2221d72b7d0e3595ce05b0e911d55ca39"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.32/hsd-darwin-amd64"
      sha256 "e87dede3ef1329753144e55b83f45cf20fde63de6e4dfd7a31fb01d2183c134e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.32/hsd-linux-arm64"
      sha256 "236af54c2134957262327317698581b17ead497ef3fa5be9a7318d00eb6909a0"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.32/hsd-linux-amd64"
      sha256 "ad415208299d5c457eccfe9f4713b0cce9f13f5dd44a96d2fb54ec6e47acb466"
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