class Hsd < Formula
  desc "hsd"
  version "1.8"

  on_arm do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.8/hsd-arm64"
    sha256 "0327a86d5d6c6ccc5237f96faf80e1cabbfedea5bc7bae9115bcd29f9bae686d"
  end

  on_intel do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.8/hsd-amd64"
    sha256 "5566ad753b8266835db0313a0f1a669fdd2442b849fdce3a0991a81012b7a581"
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