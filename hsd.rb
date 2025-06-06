class Hsd < Formula
  desc "hsd"
  version "1.33"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.33/hsd-darwin-arm64"
      sha256 "80b8f2740d33d50277bc01edb6bc773496279718d18bfa8f1efdf0744e1192b9"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.33/hsd-darwin-amd64"
      sha256 "02dcc2ac1ce3db6cb87b3e3417c510a34d887e79a0e32725b13b7ba5f32e7506"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.33/hsd-linux-arm64"
      sha256 "7f82ca85f8b9a8fed5c2eb2b9dfef8c77c5beba08a3d74773cf8c560c42d6762"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.33/hsd-linux-amd64"
      sha256 "d21895f961888ef4859c309300e643db50c4cea21dde5e411bd95983bf1d217b"
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