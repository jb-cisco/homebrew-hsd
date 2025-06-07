class Hsd < Formula
  desc "hsd"
  version "1.39"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.39/hsd-darwin-arm64"
      sha256 "38a354064a9b658bb80ccf25bba39b2bb63b953e3b794e896957622505f2b54b"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.39/hsd-darwin-amd64"
      sha256 "f0166960ac46dd219fc8659977e7006666f24341741ab37006e6d3870d587926"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.39/hsd-linux-arm64"
      sha256 "125ea034297e2a5c0255a284940e1125b75a291daa6aec8c37c5f1b2500fb35c"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.39/hsd-linux-amd64"
      sha256 "3e6ec8ebc44bf401bfce349939d2ddfdfacab8891bef13e2a1313df2133efa0b"
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